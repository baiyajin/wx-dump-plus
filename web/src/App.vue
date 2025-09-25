<script setup lang="ts">
import chatIcon from "@/assets/icon/ChatIcon.vue";
import StatisticsIcon from "@/assets/icon/StatisticsIcon.vue";
import ToolsIcon from "@/assets/icon/ToolsIcon.vue";

import {RouterView} from 'vue-router'
import {ref, onMounted} from 'vue'
import {is_db_init} from "@/utils/common_utils";
import ChatRecordsMain from "@/components/chat/ChatRecordsMain.vue";

const is_local_data = ref(true);

// 菜单项配置
const menuItems = [
  { path: '/chat', icon: chatIcon, text: '聊天查看' },
  { path: '/statistics', icon: StatisticsIcon, text: '统计分析' },
  { path: '/wxinfo', icon: ToolsIcon, text: '账号信息' },
  { path: '/bias', icon: ToolsIcon, text: '基址偏移' },
  { path: '/decrypt', icon: ToolsIcon, text: '解密数据' },
  { path: '/merge', icon: ToolsIcon, text: '数据库合并' },
  { path: '/batch-export', icon: ToolsIcon, text: '批量导出' }
];

onMounted(() => {
  is_local_data.value = localStorage.getItem('isUseLocalData') === 't';
  console.log("is_local_data", is_local_data.value);
  if(!is_local_data.value) {
    is_db_init();
  }
})

</script>

<template>
  <div class="export-main" v-if="is_local_data">
    <chat-records-main wxid="wxid_test"/>
  </div>
  <div id="appbg" v-else>
    <!-- 顶部固定导航栏 -->
    <div class="top-navbar">
      <div class="navbar-content">
        <nav class="navbar-menu">
          <div class="navbar-menu-horizontal">
            <a 
              v-for="item in menuItems" 
              :key="item.path"
              :href="'#' + item.path" 
              class="navbar-item" 
              :class="{ active: $route.path === item.path }"
            >
              <component :is="item.icon"></component>
              <span>{{ item.text }}</span>
            </a>
          </div>
        </nav>
      </div>
    </div>

    <!-- 主内容区域 -->
    <div class="main-content">
      <keep-alive>
        <RouterView/>
      </keep-alive>
    </div>
  </div>
</template>

<style scoped>

.export-main {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
}

#appbg {
  position: absolute;
  top: 0;
  left: 0;
  width: 100%;
  height: 100%;
}

header {
  line-height: 1.5;
  max-height: 100vh;
}

@media (min-width: 1024px) {
  header {
    display: flex;
    place-items: center;
    padding-right: calc(var(--section-gap) / 2);
  }

  .logo {
    margin: 0 2rem 0 0;
  }

  header .wrapper {
    display: flex;
    place-items: flex-start;
    flex-wrap: wrap;
  }

  nav {
    text-align: left;
    margin-left: -1rem;
    font-size: 1rem;

    padding: 1rem 0;
    margin-top: 1rem;
  }
}

.el-menu-vertical-demo:not(.el-menu--collapse) {
  width: 160px;
}

.layout-container-demo .el-header {
  position: relative;
  background-color: var(--el-color-primary-light-7);
  color: var(--el-text-color-primary);
}

.layout-container-demo .el-aside {
  color: var(--el-text-color-primary);
}

.layout-container-demo .el-menu {
  border-right: none;
}

.layout-container-demo .el-main {
  padding: 0;
}

.layout-container-demo .toolbar {
  display: inline-flex;
  align-items: center;
  justify-content: center;
  height: 100%;
  right: 0px;
}

/* 顶部导航栏样式 */
.top-navbar {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  z-index: 1000;
  background: rgba(255, 255, 255, 0.5);
  backdrop-filter: blur(10px);
  -webkit-backdrop-filter: blur(10px);
  border-bottom: 1px solid rgba(0, 0, 0, 0.1);
  box-shadow: 0 2px 20px rgba(0, 0, 0, 0.1);
  height: 60px;
}

.navbar-content {
  display: flex;
  align-items: center;
  justify-content: center;
  height: 100%;
  max-width: 1200px;
  margin: 0 auto;
  padding: 0 20px;
}

.navbar-menu {
  display: flex;
  justify-content: center;
  width: 100%;
}

.navbar-menu-horizontal {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 0;
}

.navbar-item {
  display: flex;
  align-items: center;
  gap: 8px;
  padding: 0 16px;
  height: 60px;
  line-height: 60px;
  text-decoration: none;
  color: #606266;
  background: transparent;
  transition: all 0.3s ease;
  white-space: nowrap;
  border: none;
  cursor: pointer;
}

.navbar-item:hover {
  background: rgba(64, 158, 255, 0.1);
  color: #409eff;
  text-decoration: none;
}

.navbar-item.active {
  background: rgba(64, 158, 255, 0.15);
  color: #409eff;
  border-bottom: 2px solid #409eff;
}

.navbar-item span {
  font-size: 14px;
  font-weight: 500;
  white-space: nowrap;
  overflow: visible;
  text-overflow: unset;
}

/* 主内容区域 */
.main-content {
  padding-top: 80px;
  background: var(--background) !important;
}
</style>
