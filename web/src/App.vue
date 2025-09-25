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
  { path: '/db_init', icon: chatIcon, text: '数据初始化' },
  { path: '/batch-export', icon: ToolsIcon, text: '批量导出' },
  { path: '/statistics', icon: StatisticsIcon, text: '统计分析' },
  { path: '/wxinfo', icon: ToolsIcon, text: '账号信息' },
  { path: '/bias', icon: ToolsIcon, text: '基址偏移' },
  { path: '/decrypt', icon: ToolsIcon, text: '解密数据' },
  { path: '/merge', icon: ToolsIcon, text: '数据库合并' }
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
    background: var(--background) !important;
    padding-top: 80px !important;
    height: 100vh !important;
    padding: 20px; 
    overflow-y: scroll;
}

/* 美化滚动条 - 透明玻璃柱效果 */
.main-content::-webkit-scrollbar {
    width: 20px;
}

.main-content::-webkit-scrollbar-track {
    background: transparent;
    border-radius: 6px;
}

.main-content::-webkit-scrollbar-thumb {
    background: 
        linear-gradient(135deg, 
            rgba(255, 255, 255, 0.25) 0%,
            rgba(255, 255, 255, 0.15) 25%,
            rgba(255, 255, 255, 0.05) 50%,
            rgba(255, 255, 255, 0.15) 75%,
            rgba(255, 255, 255, 0.25) 100%
        ),
        radial-gradient(circle at 30% 20%, rgba(255, 255, 255, 0.4) 0%, transparent 50%),
        radial-gradient(circle at 70% 80%, rgba(255, 255, 255, 0.3) 0%, transparent 50%);
    backdrop-filter: blur(15px) saturate(1.2);
    -webkit-backdrop-filter: blur(15px) saturate(1.2);
    border: 1px solid rgba(255, 255, 255, 0.4);
    border-radius: 6px;
    transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
    box-shadow: 
        0 4px 12px rgba(0, 0, 0, 0.1),
        inset 0 1px 0 rgba(255, 255, 255, 0.6),
        inset 0 -1px 0 rgba(0, 0, 0, 0.1),
        inset 1px 0 0 rgba(255, 255, 255, 0.3),
        inset -1px 0 0 rgba(0, 0, 0, 0.05);
    position: relative;
}

.main-content::-webkit-scrollbar-thumb::before {
    content: '';
    position: absolute;
    top: 0;
    left: 0;
    right: 0;
    bottom: 0;
    background: 
        repeating-linear-gradient(
            90deg,
            transparent 0px,
            transparent 1px,
            rgba(255, 255, 255, 0.1) 1px,
            rgba(255, 255, 255, 0.1) 2px
        ),
        repeating-linear-gradient(
            0deg,
            transparent 0px,
            transparent 2px,
            rgba(255, 255, 255, 0.05) 2px,
            rgba(255, 255, 255, 0.05) 4px
        );
    border-radius: 6px;
    pointer-events: none;
}

.main-content::-webkit-scrollbar-thumb:hover {
    background: 
        linear-gradient(135deg, 
            rgba(255, 255, 255, 0.35) 0%,
            rgba(255, 255, 255, 0.25) 25%,
            rgba(255, 255, 255, 0.15) 50%,
            rgba(255, 255, 255, 0.25) 75%,
            rgba(255, 255, 255, 0.35) 100%
        ),
        radial-gradient(circle at 30% 20%, rgba(255, 255, 255, 0.5) 0%, transparent 50%),
        radial-gradient(circle at 70% 80%, rgba(255, 255, 255, 0.4) 0%, transparent 50%);
    border-color: rgba(255, 255, 255, 0.6);
    box-shadow: 
        0 6px 20px rgba(0, 0, 0, 0.15),
        inset 0 1px 0 rgba(255, 255, 255, 0.8),
        inset 0 -1px 0 rgba(0, 0, 0, 0.15),
        inset 1px 0 0 rgba(255, 255, 255, 0.4),
        inset -1px 0 0 rgba(0, 0, 0, 0.1);
    transform: scale(1.05);
}

.main-content::-webkit-scrollbar-thumb:active {
    background: 
        linear-gradient(135deg, 
            rgba(255, 255, 255, 0.45) 0%,
            rgba(255, 255, 255, 0.35) 25%,
            rgba(255, 255, 255, 0.25) 50%,
            rgba(255, 255, 255, 0.35) 75%,
            rgba(255, 255, 255, 0.45) 100%
        ),
        radial-gradient(circle at 30% 20%, rgba(255, 255, 255, 0.6) 0%, transparent 50%),
        radial-gradient(circle at 70% 80%, rgba(255, 255, 255, 0.5) 0%, transparent 50%);
    border-color: rgba(255, 255, 255, 0.8);
    box-shadow: 
        0 2px 8px rgba(0, 0, 0, 0.2),
        inset 0 1px 0 rgba(255, 255, 255, 0.9),
        inset 0 -1px 0 rgba(0, 0, 0, 0.2),
        inset 1px 0 0 rgba(255, 255, 255, 0.5),
        inset -1px 0 0 rgba(0, 0, 0, 0.15);
    transform: scale(0.98);
}

/* 滚动条角落 */
.main-content::-webkit-scrollbar-corner {
    background: transparent;
}

/* Firefox 滚动条样式 - 玻璃效果 */
.main-content {
    scrollbar-width: thin;
    scrollbar-color: rgba(255, 255, 255, 0.3) transparent;
}
</style>
