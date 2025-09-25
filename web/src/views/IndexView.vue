<script setup lang="ts">
import http from '@/utils/axios.js';
import {onMounted, ref} from "vue";
import {apiVersion, api_db_init} from "@/api/base";
import DbInitComponent from "@/components/utils/DbInitComponent.vue";
import router from "@/router";

const version = ref(''); // 用于显示返回值
const isDbInit = ref(false); // 数据库是否已初始化
const showInitComponent = ref(false); // 是否显示初始化组件

const getVersion = () => {
  apiVersion().then((data: string) => {
    version.value = data;
  }).catch((error: string) => {
    console.error('Error fetching API version:', error);
  });
}

const checkDbInit = async () => {
  try {
    isDbInit.value = await api_db_init();
  } catch (error) {
    console.error('Error checking DB init status:', error);
  }
}

const showInit = () => {
  showInitComponent.value = true;
}

const hideInit = () => {
  showInitComponent.value = false;
  // 重新检查初始化状态
  checkDbInit();
}

onMounted(() => {
  getVersion();
  checkDbInit();
});

</script>

<template>
  <div style="background-color: #d2d2fa; height: 100vh; display: flex; flex-direction: column; align-items: center; justify-content: center;">
    <!-- 如果数据库未初始化，显示初始化界面 -->
    <div v-if="!isDbInit && !showInitComponent" style="text-align: center;">
      <h2 style="margin-bottom: 30px;">欢迎使用<a href="https://github.com/baiyajin/wx-dump-plus">wx-dump-plus</a>聊天记录查看工具!</h2>
      <p style="margin-bottom: 20px; font-size: 16px;">当前版本：{{ version }}</p>
      <p style="margin-bottom: 30px; color: #666;">请先进行数据库初始化设置</p>
      <el-button type="primary" size="large" @click="showInit">开始初始化</el-button>
    </div>

    <!-- 如果数据库已初始化，显示主界面 -->
    <div v-else-if="isDbInit && !showInitComponent" style="text-align: center;">
      <h2 style="margin-bottom: 30px;">欢迎使用<a href="https://github.com/baiyajin/wx-dump-plus">wx-dump-plus</a>聊天记录查看工具!</h2>
      <p style="margin-bottom: 20px; font-size: 16px;">当前版本：{{ version }}</p>
      <p style="margin-bottom: 30px; color: #28a745;">✅ 数据库已初始化，可以开始使用</p>
      <div style="display: flex; gap: 20px; justify-content: center;">
        <el-button type="primary" size="large" @click="() => router.push('/chat')">查看聊天记录</el-button>
        <el-button type="default" size="large" @click="showInit">重新初始化</el-button>
      </div>
    </div>

    <!-- 初始化组件 -->
    <div v-if="showInitComponent" style="width: 100%; height: 100%; position: relative;">
      <div style="position: absolute; top: 20px; right: 20px; z-index: 1000;">
        <el-button type="default" @click="hideInit">返回</el-button>
      </div>
      <DbInitComponent />
    </div>
  </div>
</template>

<style scoped>
.el-button {
  margin: 0 10px;
}
</style>