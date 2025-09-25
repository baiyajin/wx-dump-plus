<script setup lang="ts">
import {onMounted} from "vue";
import router from "@/router";

onMounted(() => {
  // 直接重定向到主页（IndexView）
  router.push('/');
});

</script>

<template>
  <div style="background-color: #d2d2fa; height: 100vh; display: grid; place-items: center; ">
    <h2 style="text-align: center">正在跳转到主页...
    </h2>
  </div>
</template>

<style scoped>

</style>