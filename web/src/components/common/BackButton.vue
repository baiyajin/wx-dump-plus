<template>
  <button @click="handleClick" class="back-button">
    <svg class="back-icon" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
      <path d="M19 12H5M12 19L5 12L12 5" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"/>
    </svg>
    <span>返回选择</span>
  </button>
</template>

<script setup lang="ts">
// 定义事件
const emit = defineEmits<{
  click: []
}>()

// 处理点击事件
const handleClick = () => {
  emit('click')
}
</script>

<style scoped>
/* 返回按钮样式 */
.back-button {
  display: inline-flex;
  align-items: center;
  gap: 8px;
  padding: 10px 16px;
  background: linear-gradient(135deg, #f5f7fa 0%, #e8ecf0 100%);
  border: 1px solid #dcdfe6;
  border-radius: 8px;
  color: #606266;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
  text-decoration: none;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
  position: relative;
  overflow: hidden;
}

.back-button::before {
  content: '';
  position: absolute;
  top: 0;
  left: -100%;
  width: 100%;
  height: 100%;
  background: linear-gradient(90deg, transparent, rgba(255, 255, 255, 0.4), transparent);
  transition: left 0.5s;
}

.back-button:hover {
  background: linear-gradient(135deg, #409eff 0%, #36a3f7 100%);
  border-color: #409eff;
  color: white;
  transform: translateX(-3px);
  box-shadow: 0 4px 12px rgba(64, 158, 255, 0.3);
}

.back-button:hover::before {
  left: 100%;
}

.back-button:active {
  transform: translateX(-1px);
  box-shadow: 0 2px 6px rgba(64, 158, 255, 0.4);
}

.back-icon {
  width: 16px;
  height: 16px;
  transition: transform 0.3s ease;
}

.back-button:hover .back-icon {
  transform: translateX(-2px);
}

.back-button span {
  font-weight: 500;
  letter-spacing: 0.5px;
}
</style>
