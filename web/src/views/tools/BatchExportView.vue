<script setup lang="ts">
import { ref, onMounted, computed, nextTick } from 'vue';
import { ElMessage, ElMessageBox, ElNotification } from 'element-plus';
import { Search, User as UserIcon } from '@element-plus/icons-vue';
import http from '@/utils/axios.js';
import { apiUserSessionList, apiMsgCount, apiExportCSV } from '@/api/chat';
import { gen_show_name, type User } from '@/utils/common_utils';
import { api_img } from '@/api/base';

// 联系人列表数据
const contactsList = ref<User[]>([]);
const selectedContacts = ref<string[]>([]);
const loading = ref(false);
const exportLoading = ref(false);
const searchKeyword = ref('');
const contactMsgCounts = ref<Record<string, number>>({});
const minMsgCount = ref(0);
const filterType = ref('all'); // 筛选类型：all, official, group, folded_group, friend

// 表格引用
const tableRef = ref();

// 防止同步时的循环调用
const isSyncing = ref(false);

// 消息类型常量
const MESSAGE_TYPES = ['notification_messages', 'notifymessage', '@opencustomerservicemsg'];

// 微信服务类型常量
const WECHAT_SERVICE_TYPES = ['mphelper', 'filehelper', 'fmessage', 'weixin'];

// 筛选选项
const filterOptions = [
  { label: '全部', value: 'all' },
  { label: '微信好友', value: 'friend' },
  { label: '公众号', value: 'official' },
  { label: '群聊', value: 'group' },
  { label: '折叠的群聊', value: 'folded_group' },
  { label: '企业服务', value: 'enterprise' },
  { label: '微信服务', value: 'wechat_service' },
  { label: '客服', value: 'customer_service' },
  { label: '消息', value: 'message' },
];

// 分页相关
const currentPage = ref(1);
const pageSize = ref(10);
const total = ref(0);

// 导出进度
const exportProgress = ref(0);
const exportStatus = ref('');
const isExporting = ref(false);

// 获取联系人列表
const fetchContacts = async () => {
  try {
    loading.value = true;
    const data = await apiUserSessionList();
    contactsList.value = data || [];
    total.value = contactsList.value.length;
    
    // 获取每个联系人的消息数量
    await fetchContactMsgCounts();
  } catch (error) {
    console.error('Error fetching contacts:', error);
    ElMessage.error('获取联系人列表失败');
  } finally {
    loading.value = false;
  }
};

// 获取联系人消息数量
const fetchContactMsgCounts = async () => {
  try {
    const wxids = contactsList.value.map(contact => contact.wxid);
    if (wxids.length > 0) {
      const msgCounts = await apiMsgCount(wxids);
      contactMsgCounts.value = msgCounts || {};
    }
  } catch (error) {
    console.error('Error fetching message counts:', error);
  }
};

// 过滤非公众号、非群聊、非文件夹分组用户（wxid不以gh_开头、不以@chatroom结尾、不以@placeholder_foldgroup结尾且消息数量大于0）
const nonOfficialContacts = computed(() => {
  return contactsList.value.filter(contact => {
    const msgCount = contactMsgCounts.value[contact.wxid] || 0;
    return !contact.wxid.startsWith('gh_') && 
           !contact.wxid.endsWith('@chatroom') && 
           !contact.wxid.endsWith('@placeholder_foldgroup') &&
           msgCount > 0;
  });
});

// 搜索过滤
const filteredContacts = computed(() => {
  let filtered = contactsList.value;
  
  // 按类型筛选
  if (filterType.value !== 'all') {
    filtered = filtered.filter(contact => {
      const wxid = contact.wxid;
      switch (filterType.value) {
        case 'official':
          return wxid.startsWith('gh_');
        case 'group':
          return wxid.endsWith('@chatroom');
        case 'folded_group':
          return wxid.endsWith('@placeholder_foldgroup');
        case 'enterprise':
          return wxid.endsWith('@openim');
        case 'wechat_service':
          return WECHAT_SERVICE_TYPES.includes(wxid);
        case 'customer_service':
          return wxid.endsWith('@kefu.openim');
        case 'message':
          return MESSAGE_TYPES.includes(wxid);
        case 'friend':
          return !wxid.startsWith('gh_') && 
                 !wxid.endsWith('@chatroom') && 
                 !wxid.endsWith('@placeholder_foldgroup') &&
                 !wxid.endsWith('@openim') &&
                 !WECHAT_SERVICE_TYPES.includes(wxid) &&
                 !wxid.endsWith('@kefu.openim') &&
                 !MESSAGE_TYPES.includes(wxid);
        default:
          return true;
      }
    });
  }
  
  // 按关键词搜索
  if (searchKeyword.value) {
    filtered = filtered.filter(contact => {
      const name = gen_show_name(contact).toLowerCase();
      const keyword = searchKeyword.value.toLowerCase();
      return name.includes(keyword);
    });
  }
  
  // 按消息数量过滤
  if (minMsgCount.value > 0) {
    filtered = filtered.filter(contact => {
      const msgCount = contactMsgCounts.value[contact.wxid] || 0;
      return msgCount >= minMsgCount.value;
    });
  }
  
  return filtered;
});

// 分页数据
const paginatedContacts = computed(() => {
  const start = (currentPage.value - 1) * pageSize.value;
  const end = start + pageSize.value;
  return filteredContacts.value.slice(start, end);
});

// 全选/取消全选
const handleSelectAll = (checked: boolean) => {
  if (checked) {
    selectedContacts.value = paginatedContacts.value.map(contact => contact.wxid);
  } else {
    selectedContacts.value = [];
  }
  // 同步表格选择状态
  nextTick(() => {
    syncTableSelection();
  });
};

// 处理表格选择变化（Element Plus 内置选择机制）
const handleSelectionChange = (selection: User[]) => {
  // 如果正在同步，跳过处理避免循环调用
  if (isSyncing.value) {
    return;
  }
  selectedContacts.value = selection.map(contact => contact.wxid);
};

// 同步表格选择状态
const syncTableSelection = () => {
  if (tableRef.value) {
    isSyncing.value = true;
    // 清除所有选择
    tableRef.value.clearSelection();
    // 根据 selectedContacts 重新选择
    selectedContacts.value.forEach(wxid => {
      const row = paginatedContacts.value.find(contact => contact.wxid === wxid);
      if (row) {
        tableRef.value.toggleRowSelection(row, true);
      }
    });
    // 同步完成后重置标记
    nextTick(() => {
      isSyncing.value = false;
    });
  }
};

// 单个选择（统一的选择逻辑）
const handleSelect = (wxid: string) => {
  const isSelected = selectedContacts.value.includes(wxid);
  if (isSelected) {
    // 如果已选中，则取消选择
    const index = selectedContacts.value.indexOf(wxid);
    if (index > -1) {
      selectedContacts.value.splice(index, 1);
    }
  } else {
    // 如果未选中，则选择
    selectedContacts.value.push(wxid);
  }
  // 同步表格选择状态
  nextTick(() => {
    syncTableSelection();
  });
};

// 点击行选中
const handleRowClick = (row: User) => {
  handleSelect(row.wxid);
};

// 检查是否全选
const isAllSelected = computed(() => {
  return paginatedContacts.value.length > 0 && 
         paginatedContacts.value.every(contact => selectedContacts.value.includes(contact.wxid));
});

// 检查是否部分选择
const isIndeterminate = computed(() => {
  const selectedCount = paginatedContacts.value.filter(contact => 
    selectedContacts.value.includes(contact.wxid)
  ).length;
  return selectedCount > 0 && selectedCount < paginatedContacts.value.length;
});

// 选中联系人的总消息数
const selectedTotalMsgCount = computed(() => {
  return selectedContacts.value.reduce((total, wxid) => {
    return total + (contactMsgCounts.value[wxid] || 0);
  }, 0);
});

// 批量导出CSV
const batchExportCSV = async () => {
  if (selectedContacts.value.length === 0) {
    ElMessage.warning('请选择要导出的联系人');
    return;
  }

  // 只过滤掉消息数量为0的联系人
  const validContacts = selectedContacts.value.filter(wxid => {
    const msgCount = contactMsgCounts.value[wxid] || 0;
    return msgCount > 0;
  });

  if (validContacts.length === 0) {
    ElMessage.warning('所选联系人中没有消息数量大于0的联系人');
    return;
  }

  if (validContacts.length < selectedContacts.value.length) {
    const filteredCount = selectedContacts.value.length - validContacts.length;
    try {
      await ElMessageBox.confirm(
        `所选联系人中有 ${filteredCount} 个消息数量为0的联系人将被过滤掉，确定要导出剩余的 ${validContacts.length} 个联系人的聊天记录吗？`,
        '确认导出',
        {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning',
        }
      );
    } catch (error) {
      if (error === 'cancel') return;
    }
  } else {
    try {
      await ElMessageBox.confirm(
        `确定要导出 ${validContacts.length} 个联系人的聊天记录吗？`,
        '确认导出',
        {
          confirmButtonText: '确定',
          cancelButtonText: '取消',
          type: 'warning',
        }
      );
    } catch (error) {
      if (error === 'cancel') return;
    }
  }

  try {
    await performBatchExport(validContacts);
  } catch (error) {
    console.error('批量导出失败:', error);
    ElMessage.error('批量导出失败');
  }
};

// 批量导出非公众号用户
const batchExportNonOfficial = async () => {
  const nonOfficialWxids = nonOfficialContacts.value.map(contact => contact.wxid);
  
  if (nonOfficialWxids.length === 0) {
    ElMessage.warning('没有找到符合条件的非公众号、非群聊用户');
    return;
  }

  try {
    await ElMessageBox.confirm(
      `确定要导出 ${nonOfficialWxids.length} 个非公众号、非群聊用户的聊天记录吗？`,
      '确认导出',
      {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning',
      }
    );

    await performBatchExport(nonOfficialWxids);

  } catch (error) {
    if (error !== 'cancel') {
      console.error('批量导出失败:', error);
      ElMessage.error('批量导出失败');
    }
  }
};

// 执行批量导出
const performBatchExport = async (wxids: string[]) => {
  isExporting.value = true;
  exportProgress.value = 0;
  exportStatus.value = '开始导出...';

  const totalContacts = wxids.length;
  const results: any[] = [];
  const exportPaths: string[] = [];
  let successCount = 0;

  for (let i = 0; i < totalContacts; i++) {
    const wxid = wxids[i];
    const contact = contactsList.value.find(c => c.wxid === wxid);
    
    const contactName = contact ? gen_show_name(contact) : wxid;
    exportStatus.value = `正在导出 ${contactName} 的聊天记录...`;
    exportProgress.value = Math.round((i / totalContacts) * 100);

    try {
      const response = await apiExportCSV(wxid);
      
      // 检查响应是否包含成功信息
      if (response && typeof response === 'string' && response.includes('导出成功:')) {
        successCount++;
        // 提取导出路径
        const pathMatch = response.match(/导出成功: (.+)/);
        if (pathMatch) {
          exportPaths.push(pathMatch[1]);
        }
      } else {
        console.error(`导出 ${wxid} 失败:`, response);
        ElMessage.warning(`导出 ${contactName} 的聊天记录失败`);
      }
    } catch (error) {
      console.error(`导出 ${wxid} 失败:`, error);
      ElMessage.warning(`导出 ${contactName} 的聊天记录失败`);
    }
  }

  exportStatus.value = '导出完成！';
  exportProgress.value = 100;
  
  // 显示导出结果
  if (successCount > 0) {
    const uniquePaths = [...new Set(exportPaths)];
    let pathMessage = `成功导出 ${successCount} 个联系人的聊天记录`;
    
    if (uniquePaths.length > 0) {
      // 提取目录路径（去掉文件名）
      const directoryPaths = uniquePaths.map(path => {
        const lastSlash = path.lastIndexOf('\\');
        return lastSlash > -1 ? path.substring(0, lastSlash + 1) : path;
      });
      
      const uniqueDirectories = [...new Set(directoryPaths)];
      pathMessage += `\n\n导出目录：\n${uniqueDirectories.join('\n')}`;
    }
    
    ElMessageBox.alert(pathMessage, '导出完成', {
      confirmButtonText: '确定',
      type: 'success',
    });
  } else {
    ElMessage.error('所有导出都失败了');
  }

  isExporting.value = false;
  setTimeout(() => {
    exportStatus.value = '';
    exportProgress.value = 0;
  }, 3000);
};


// 下载CSV文件
const downloadCSV = (csvContent: string, fileName: string) => {
  const blob = new Blob([new Uint8Array([0xEF, 0xBB, 0xBF]), csvContent], { 
    type: 'text/csv;charset=utf-8;' 
  });
  const link = document.createElement('a');

  if ((navigator as any).msSaveBlob) {
    (navigator as any).msSaveBlob(blob, fileName);
  } else {
    link.href = URL.createObjectURL(blob);
    link.setAttribute('download', fileName);
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
  }
};

// 清空选择
const clearSelection = () => {
  selectedContacts.value = [];
  // 同步表格选择状态
  nextTick(() => {
    syncTableSelection();
  });
};

onMounted(() => {
  fetchContacts();
});
</script>

<template>
  <div style="background-color: #d2d2fa; height: 100vh; display: grid; place-items: center;">
    <div style="background-color: #fff; width: 90%; height: 90%; border-radius: 10px; padding: 20px; overflow: auto;">
      <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
        <div style="font-size: 20px; font-weight: bold;">批量导出联系人聊天记录</div>
        <div>
          <el-button 
            type="success" 
            :disabled="isExporting"
            @click="batchExportNonOfficial"
            :loading="isExporting"
          >
            {{ isExporting ? '导出中...' : `批量导出（排除公众号、群聊、折叠群聊、消息数量为0）(${nonOfficialContacts.length}人)` }}
          </el-button>
        </div>
      </div>

      <!-- 搜索和过滤区域 -->
      <div style="margin-bottom: 20px; display: flex; gap: 15px; align-items: center; flex-wrap: wrap;">
        <el-select
          v-model="filterType"
          placeholder="选择类型"
          style="width: 150px;"
          clearable
        >
          <el-option
            v-for="option in filterOptions"
            :key="option.value"
            :label="option.label"
            :value="option.value"
          />
        </el-select>
        
        <el-input
          v-model="searchKeyword"
          placeholder="搜索联系人..."
          style="width: 300px;"
          clearable
        >
          <template #prefix>
            <el-icon><Search /></el-icon>
          </template>
        </el-input>
        
        <el-input-number
          v-model="minMsgCount"
          :min="0"
          placeholder="最小消息数"
          style="width: 150px;"
          controls-position="right"
        />
        
        <el-button @click="clearSelection" :disabled="isExporting">
          清空选择
        </el-button>
        
        <el-button @click="fetchContacts" :loading="loading">
          刷新
        </el-button>
      </div>

      <!-- 筛选结果统计 -->
      <div style="margin-bottom: 15px; padding: 10px; background-color: #f0f9ff; border-radius: 5px; border-left: 4px solid #409eff;">
        <div style="display: flex; justify-content: space-between; align-items: center;">
          <div>
            <span style="color: #666;">当前筛选：</span>
            <el-tag type="info" size="small" style="margin: 0 5px;">
              {{ filterOptions.find(opt => opt.value === filterType)?.label || '全部' }}
            </el-tag>
            <span style="color: #666;">共 {{ filteredContacts.length }} 个联系人</span>
            <span v-if="selectedContacts.length > 0" style="color: #67c23a; margin-left: 10px;">
              （已选择 {{ selectedContacts.length }} 个）
            </span>
          </div>
          <div v-if="filteredContacts.length > 0" style="color: #909399; font-size: 12px;">
            消息数量范围：{{ Math.min(...filteredContacts.map(c => contactMsgCounts[c.wxid] || 0)) }} - {{ Math.max(...filteredContacts.map(c => contactMsgCounts[c.wxid] || 0)) }}
          </div>
        </div>
      </div>

      <!-- 导出进度 -->
      <div v-if="isExporting" style="margin-bottom: 20px;">
        <el-progress 
          :percentage="exportProgress" 
          :status="exportProgress === 100 ? 'success' : undefined"
        />
        <div style="margin-top: 10px; color: #666;">{{ exportStatus }}</div>
      </div>

      <!-- 联系人列表 -->
      <el-table
        ref="tableRef"
        :data="paginatedContacts"
        v-loading="loading"
        style="width: 100%"
        max-height="400"
        @selection-change="handleSelectionChange"
        @row-click="handleRowClick"
        :row-class-name="({ row }: { row: User }) => selectedContacts.includes(row.wxid) ? 'selected-row' : ''"
      >
        <el-table-column type="selection" width="55" :selectable="() => !isExporting">
          <template #header>
            <el-checkbox
              :model-value="isAllSelected"
              :indeterminate="isIndeterminate"
              @change="handleSelectAll"
              :disabled="isExporting"
            />
          </template>
        </el-table-column>
        
        <el-table-column label="头像" width="80">
          <template #default="{ row }">
            <el-avatar :size="40" :src="api_img(row.headImgUrl)" v-if="row.headImgUrl">
              <el-icon><UserIcon /></el-icon>
            </el-avatar>
            <el-avatar :size="40" v-else>
              <el-icon><UserIcon /></el-icon>
            </el-avatar>
          </template>
        </el-table-column>
        
        <el-table-column label="联系人名称" min-width="200">
          <template #default="{ row }">
            <div style="font-weight: bold;">{{ gen_show_name(row) }}</div>
            <div style="font-size: 12px; color: #999;">{{ row.wxid }}</div>
          </template>
        </el-table-column>
        
        <el-table-column label="消息数量" width="100">
          <template #default="{ row }">
            <el-tag type="info" size="small">
              {{ contactMsgCounts[row.wxid] || 0 }}
            </el-tag>
          </template>
        </el-table-column>
        
        <el-table-column label="最后消息时间" width="180">
          <template #default="{ row }">
            {{ row.nTime || '未知' }}
          </template>
        </el-table-column>
        
        <el-table-column label="操作" width="100">
          <template #default="{ row }">
            <el-button
              type="primary"
              size="small"
              :disabled="isExporting"
              @click.stop="handleSelect(row.wxid)"
            >
              {{ selectedContacts.includes(row.wxid) ? '取消选择' : '选择' }}
            </el-button>
          </template>
        </el-table-column>
      </el-table>

      <!-- 分页和导出按钮 -->
      <div style="margin-top: 20px; display: flex; justify-content: space-between; align-items: center;">
        <!-- 第二个批量导出按钮 -->
        <div>
          <el-button 
            type="primary" 
            :disabled="selectedContacts.length === 0 || isExporting"
            @click="batchExportCSV"
            :loading="isExporting"
          >
            {{ isExporting ? '导出中...' : `按选择导出 (${selectedContacts.length}人, ${selectedTotalMsgCount}条消息)` }}
          </el-button>
        </div>
        
        <!-- 分页 -->
        <el-pagination
          v-model:current-page="currentPage"
          v-model:page-size="pageSize"
          :page-sizes="[10, 20, 50, 100, 200, 500, 1000, 2000, 5000, 10000]"
          :total="total"
          layout="total, sizes, prev, pager, next, jumper"
          @size-change="() => currentPage = 1"
        />
      </div>

      <!-- 说明信息 -->
      <div style="margin-top: 20px; padding: 15px; background-color: #f5f7fa; border-radius: 5px;">
        <h4 style="margin: 0 0 10px 0; color: #409eff;">使用说明：</h4>
        <ul style="margin: 0; padding-left: 20px; color: #666;">
          <li><strong>筛选功能</strong>：支持按类型筛选（全部、公众号、群聊、折叠的群聊、企业服务、微信服务、微信好友）</li>
          <li><strong>搜索功能</strong>：支持按联系人名称搜索</li>
          <li><strong>消息数量过滤</strong>：支持按最小消息数量过滤</li>
          <li><strong>批量导出（排除公众号、群聊、折叠群聊）</strong>：自动过滤掉wxid以"gh_"开头的公众号、以"@chatroom"结尾的群聊、以"@placeholder_foldgroup"结尾的折叠群聊和消息数量为0的联系人</li>
          <li><strong>批量导出</strong>：手动选择要导出的联系人，支持多选，会自动过滤掉消息数量为0的联系人</li>
          <li>导出格式为CSV，包含联系人名称、联系人ID和聊天记录内容</li>
          <li>导出完成后会显示导出目录路径，方便用户查找文件</li>
          <li>导出过程中请勿关闭页面，以免中断导出</li>
        </ul>
      </div>
    </div>
  </div>
</template>

<style scoped>
.el-table {
  border-radius: 5px;
}

.el-pagination {
  margin-top: 20px;
}

/* 选中行的样式 */
:deep(.selected-row) {
  background-color: #f0f9ff !important;
}

:deep(.selected-row:hover) {
  background-color: #e1f5fe !important;
}

/* 表格行点击样式 */
:deep(.el-table__row) {
  cursor: pointer;
}

:deep(.el-table__row:hover) {
  background-color: #f5f7fa;
}
</style>
