<script setup lang="ts">
import http from "@/utils/axios.js";
import ProgressBar from "@/components/utils/ProgressBar.vue";
import {defineEmits, onMounted, ref, watch} from "vue";
import {ElTable, ElTableColumn, ElMessage, ElMessageBox} from "element-plus";
import type {Action} from 'element-plus'
import router from "@/router";

interface wxinfo {
  pid: string;
  version: string;
  account: string;
  mobile: string;
  nickname: string;
  mail: string;
  wxid: string;
  wx_dir: string;
  key: string;
}

const percentage = ref(0);
const startORstop = ref(-1);  // 用于进度条的开始和停止 0表示0% 1表示100%

const init_type = ref("");

// 初始化选项配置
const initOptions = [
  {
    value: 'last',
    title: '使用历史数据',
    description: '使用上次保存的配置和数据',
    icon: '📁',
    color: '#409eff'
  },
  {
    value: 'auto',
    title: '自动解密已登录微信',
    description: '自动检测并解密当前登录的微信数据',
    icon: '🔓',
    color: '#67c23a'
  },
  {
    value: 'custom',
    title: '自定义文件位置',
    description: '手动指定微信数据文件的位置',
    icon: '⚙️',
    color: '#e6a23c'
  }
];

const is_init = ref(false);
const wxinfoData = ref<wxinfo[]>([]);

const oneWx = ref("");
const decryping = ref(false);
const isErrorShow = ref(false);
const isUseKey = ref("false");

const merge_path = ref("");
const wx_path = ref("");
const key = ref("");
const my_wxid = ref("");

const local_wxids = ref([]);

const db_init = (init: boolean) => {
  if (init) {
    localStorage.setItem('isDbInit', "t");
    router.push('/');
    ElMessage({
      type: 'success',
      message: '初始化成功！',
    })
  }
}

// ** 是否使用key的初始化** START
const init_key = async () => {
  if (decryping.value) {
    console.log("正在解密中，请稍后再试！")
    return;
  }
  decryping.value = true;
  try {
    decryping.value = true;
    startORstop.value = 0; // 进度条开始
    let reqdata = {
      "wx_path": wx_path.value,
      "key": key.value,
      "my_wxid": my_wxid.value
    }
    const body_data = await http.post('/api/ls/init_key', reqdata);
    is_init.value = body_data.is_init;
    if (body_data.is_init) {
      percentage.value = 100; // 进度条 100%
    }
    decryping.value = false;
    db_init(body_data.is_init);
  } catch (error) {
    percentage.value = 0; // 进度条 0%
    isErrorShow.value = true;
    decryping.value = false;
    ElMessageBox.alert(error, 'error', {
      confirmButtonText: '确认',
      callback: (action: Action) => {
        ElMessage({
          type: 'error',
          message: `action: ${action}`,
        })
      },
    })
    return [];
  }
  decryping.value = false;
}

const init_nokey = async () => {
  try {
    let reqdata = {
      "wx_path": wx_path.value,
      "merge_path": merge_path.value,
      "my_wxid": my_wxid.value
    }
    const body_data = await http.post('/api/ls/init_nokey', reqdata);
    is_init.value = body_data.is_init;
    if (body_data.is_init) {
      percentage.value = 100; // 进度条 100%
    }
    decryping.value = false;
    db_init(body_data.is_init);
    // emits('isAutoShow', body_data.is_init);
  } catch (error) {
    percentage.value = 0; // 进度条 0%
    isErrorShow.value = true;
    decryping.value = false;
    ElMessageBox.alert(error, 'error', {
      confirmButtonText: '确认',
      callback: (action: Action) => {
        init_type.value = "";// 刷新
      },
    })
    // console.error('Error fetching data:', error);
    return [];
  }
  decryping.value = false;
}
// ** 是否使用key的初始化** END

// ** 使用上次数据部分** START
const selectLastWx = async (row: wxinfo) => {
  // console.log(row)
  my_wxid.value = row.wxid;
}

const get_init_last_local_wxid = async () => {
  try {
    const body_data = await http.post('/api/ls/init_last_local_wxid'); //[ 'wx1234567890', 'wx0987654321' ]
    local_wxids.value = body_data.local_wxids.map((item: string) => {
      return {wxid: item}
    });
    if (local_wxids.value.length === 1) {
      my_wxid.value = local_wxids.value[0].wxid;
      // console.log("init_last")
      await init_last();
    }
  } catch (error) {
    console.error('Error fetching data:', error);
    return [];
  }
}


const init_last = async () => {
  try {
    let reqdata = {
      "wx_path": wx_path.value,
      "merge_path": merge_path.value,
      "my_wxid": my_wxid.value
    }
    const body_data = await http.post('/api/ls/init_last', reqdata);
    is_init.value = body_data.is_init;
    if (body_data.is_init) {
      percentage.value = 100; // 进度条 100%
      decryping.value = false;
      db_init(body_data.is_init);
      // emits('isAutoShow', body_data.is_init);
    } else {
      isErrorShow.value = true;
      decryping.value = false;
      ElMessageBox.alert("未发现上次的设置数据！", 'error', {
        confirmButtonText: '确认',
        callback: (action: Action) => {
          init_type.value = "";// 刷新
        },
      })
    }

    decryping.value = false;
  } catch (error) {
    // percentage.value = 0; // 进度条 0%
    isErrorShow.value = true;
    decryping.value = false;
    ElMessageBox.alert(error, 'error', {
      confirmButtonText: '确认',
      callback: (action: Action) => {
        init_type.value = "";
      },
    })
    // console.error('Error fetching data:', error);
    return [];
  }

  decryping.value = false;
}

// ** 使用上次数据部分** END

// **自动解密微信部分** START 查看有多少个微信正在登录 ， 并调用init_key解密初始化
const get_wxinfo = async () => {
  try {
    wxinfoData.value = await http.post('/api/ls/wxinfo');
    if (wxinfoData.value.length === 1) {
      selectWx(wxinfoData.value[0]);
      oneWx.value = " (检测到只有一个微信，将在5秒后自动选择) ";
      setTimeout(okWx, 5000);
    }
  } catch (error) {
    console.error('Error fetching data:', error);
    return [];
  }
}

const selectWx = async (row: wxinfo) => {
  merge_path.value = "";
  wx_path.value = row.wx_dir;
  key.value = row.key;
  my_wxid.value = row.wxid;
}

const okWx = () => {
  if (wx_path.value === '' && key.value === '' && my_wxid.value === '') {
    console.log("请填写完整信息! ")
    return;
  }
  if (decryping.value) {
    console.log("正在解密...，请稍后再试！")
    return;
  }
  init_key();
}

// **自动解密微信部分**  END 查看有多少个微信正在登录 ， 并调用init_key解密初始化


// 监测isAutoShow是否为aoto，如果是则执行get_wxinfo
watch(init_type, (val) => {
  if (val === 'auto') {
    get_wxinfo();
  } else if (val === 'custom') {
    // init();
  } else if (val === 'last') {
    get_init_last_local_wxid();
    // init_last();
  }
})

</script>

<template>
  <div style="background-color: #d2d2fa; height: 100%; display: flex; justify-content: center; align-items: center;">
    <!-- 上次数据 -->
    <div v-if="init_type==='last'">
      <div
          style="background-color: #fff; width: 90%;min-width: 800px; height: 80%; border-radius: 10px; padding: 20px; overflow: auto;">
        <div style="display: flex; justify-content: space-between; align-items: center;">
          <div style="font-size: 20px; font-weight: bold;">选择要查看的微信</div>
        </div>
        <div style="margin-top: 20px;">
          <el-table :data="local_wxids" @current-change="selectLastWx" highlight-current-row style="width: 100%">
            <el-table-column :min-width="50" prop="wxid" label="微信原始id"></el-table-column>
          </el-table>
        </div>
        <div style="margin-top: 20px;">
          <el-button style="margin-right: 10px;margin-top: 10px;width: 100%;" type="success" @click="init_last">确定
          </el-button>
        </div>
      </div>
    </div>
    <!-- END -->

    <!-- 自动解密和显示 -->
    <div v-else-if="init_type==='auto'">

      <!--      <el-progress v-if="decryping && !isErrorShow" type="dashboard" :percentage="percentage" :color="colors"/>-->
      <div v-if="decryping">
        <ProgressBar v-if="decryping" :startORstop="startORstop"/>
      </div>
      <div v-else
           style="background-color: #fff; width: 90%;min-width: 800px; height: 80%; border-radius: 10px; padding: 20px; overflow: auto;">
        <div style="display: flex; justify-content: space-between; align-items: center;">
          <div style="font-size: 20px; font-weight: bold;">选择要查看的微信(会清空work下对应wxid数据)</div>
        </div>
        <div style="margin-top: 20px;">
          <el-table :data="wxinfoData" @current-change="selectWx" highlight-current-row style="width: 100%">
            <el-table-column :min-width="30" prop="pid" label="进程id"></el-table-column>
            <el-table-column :min-width="40" prop="version" label="微信版本"></el-table-column>
            <el-table-column :min-width="40" prop="account" label="账号"></el-table-column>
            <el-table-column :min-width="40" prop="nickname" label="昵称"></el-table-column>
            <el-table-column :min-width="50" prop="wxid" label="微信原始id"></el-table-column>
          </el-table>
        </div>
        <div style="margin-top: 20px;">
          <el-button style="margin-right: 10px;margin-top: 10px;width: 100%;" type="success" @click="okWx">确定{{
              oneWx
            }}
          </el-button>
        </div>
      </div>
    </div>
    <!-- END -->

    <!-- 用于自定义参数 -->
    <div v-else-if="init_type==='custom'">
      <div v-if="decryping">
        <ProgressBar v-if="decryping" :startORstop="startORstop"/>
      </div>
      <div v-else
           style="background-color: #fff; width: 80%;min-width: 800px; height: 70%; border-radius: 10px; padding: 20px; overflow: auto;">
        <div style="display: flex; justify-content: space-between; align-items: center;">
          <div style="font-size: 20px; font-weight: bold;">自定义-文件位置</div>
          <div style="display: flex; justify-content: space-between; align-items: center;">
            <!--          <el-button style="margin-right: 10px;" @click="exportData">导出</el-button>-->
          </div>
        </div>
        <div style="margin-top: 20px;">
          <!--    单选按钮      -->
          <input type="radio" v-model="isUseKey" value="true"/> 使用 KEY &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
          <input type="radio" v-model="isUseKey" value="false"/> 不使用 KEY
          <div v-if="isUseKey=='false'">
            说明：1、表示数据库已解密并合并<br>2、合并后的数据库需要包含(MediaMSG,MSG,MicroMsg,OpenIMMsg)这些数据库合并的内容<br>
          </div>
          <div v-if="isUseKey=='true'">
            说明：1、自动根据key解密微信文件夹下的数据库<br>2、必须保证key正确，否则解密失败<br>
          </div>

          <el-divider></el-divider>  <!-- 分割线-->

          <div v-if="isUseKey=='true'">
            <label>密钥key(必填): </label>
            <el-input placeholder="密钥key (64位)" v-model="key" style="width: 80%;"></el-input>
            <br>
          </div>
          <div v-if="isUseKey=='false'">
            <label>merge_all.db 文件路径(必填,非文件夹): </label>
            <el-input placeholder="(MediaMSG.db,MSG.db,MicroMsg.db,OpenIMMsg.db)合并后的数据库" v-model="merge_path"
                      style="width: 80%;"></el-input>
            <br>
          </div>
          <label>微信文件夹路径(必填): </label>
          <el-input placeholder="C:\***\WeChat Files\wxid_*******" v-model="wx_path" style="width: 80%;"></el-input>
          <br>
          <label>微信原始id(必填): </label>
          <el-input placeholder="wxid_*******" v-model="my_wxid" style="width: 80%;"></el-input>
          <br>

          <el-button v-if="isUseKey=='true'" style="margin-top: 10px;width: 100%;" type="success" @click="init_key">
            确定
          </el-button>
          <el-button v-if="isUseKey=='false'" style="margin-top: 10px;width: 100%;" type="success" @click="init_nokey">
            确定
          </el-button>
        </div>
      </div>
    </div>
    <!-- END -->


    <!-- 初始选择界面 -->
    <div v-else-if="init_type === ''" class="init-selection-container">
      <div class="init-title">
        <h2>选择初始化方式</h2>
        <p>请选择一种方式来初始化微信数据</p>
      </div>
      <div class="init-options">
        <label 
          v-for="option in initOptions" 
          :key="option.value"
          class="init-option"
          :class="{ active: init_type === option.value }"
          :style="{ '--option-color': option.color }"
        >
          <input 
            type="radio" 
            v-model="init_type" 
            :value="option.value"
            class="init-radio"
          />
          <div class="init-option-content">
            <div class="init-option-icon">{{ option.icon }}</div>
            <div class="init-option-title">{{ option.title }}</div>
            <div class="init-option-description">{{ option.description }}</div>
          </div>
        </label>
      </div>
    </div>
    <!-- END -->
  </div>
</template>

<style scoped>
/* 初始化选择容器 */
.init-selection-container {
  display: flex;
  flex-direction: column;
  align-items: center;
  justify-content: center;
  height: 100%;
}

.init-title {
  text-align: center;
  margin-bottom: 40px;
  color: white;
}

.init-title h2 {
  font-size: 32px;
  font-weight: 600;
  margin: 0 0 10px 0;
  text-shadow: 0 2px 4px rgba(0, 0, 0, 0.3);
}

.init-title p {
  font-size: 16px;
  margin: 0;
  opacity: 0.9;
}

/* 选项容器 */
.init-options {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 24px;
  max-width: 900px;
  width: 100%;
}

/* 单个选项 */
.init-option {
  position: relative;
  display: block;
  background: white;
  border-radius: 16px;
  padding: 24px;
  cursor: pointer;
  transition: all 0.3s ease;
  box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
  border: 2px solid transparent;
  overflow: hidden;
}

.init-option::before {
  content: '';
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  height: 4px;
  background: var(--option-color);
  transform: scaleX(0);
  transition: transform 0.3s ease;
}

.init-option:hover {
  transform: translateY(-4px);
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.15);
}

.init-option:hover::before {
  transform: scaleX(1);
}

.init-option.active {
  border-color: var(--option-color);
  box-shadow: 0 8px 30px rgba(0, 0, 0, 0.15);
}

.init-option.active::before {
  transform: scaleX(1);
}

/* 隐藏原生radio */
.init-radio {
  position: absolute;
  opacity: 0;
  pointer-events: none;
}

/* 选项内容 */
.init-option-content {
  display: flex;
  flex-direction: column;
  align-items: center;
  text-align: center;
  height: 100%;
}

.init-option-icon {
  font-size: 48px;
  margin-bottom: 16px;
  filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.1));
}

.init-option-title {
  font-size: 20px;
  font-weight: 600;
  color: #2c3e50;
  margin-bottom: 8px;
}

.init-option-description {
  font-size: 14px;
  color: #7f8c8d;
  line-height: 1.5;
  flex: 1;
  display: flex;
  align-items: center;
}

/* 响应式设计 */
@media (max-width: 768px) {
  .init-options {
    grid-template-columns: 1fr;
    gap: 16px;
  }
  
  .init-option {
    padding: 20px;
  }
  
  .init-title h2 {
    font-size: 24px;
  }
  
  .init-option-icon {
    font-size: 40px;
  }
  
  .init-option-title {
    font-size: 18px;
  }
}
</style>