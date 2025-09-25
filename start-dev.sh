#!/bin/bash

echo "========================================"
echo "   wx-dump-plus 开发模式启动脚本"
echo "========================================"
echo

# 检查是否安装了uv
if ! command -v uv &> /dev/null; then
    echo "[错误] 未检测到 uv，请先安装 uv"
    echo "安装命令: pip install uv"
    exit 1
fi

# 检查是否安装了pnpm
if ! command -v pnpm &> /dev/null; then
    echo "[错误] 未检测到 pnpm，请先安装 pnpm"
    echo "安装命令: npm install -g pnpm"
    exit 1
fi

echo "[信息] 开始安装后端开发依赖..."
cd py
uv sync --dev --index-url https://mirrors.aliyun.com/pypi/simple
if [ $? -ne 0 ]; then
    echo "[错误] 后端依赖安装失败"
    exit 1
fi
echo "[成功] 后端开发依赖安装完成"

echo
echo "[信息] 开始安装前端依赖..."
cd ../web
pnpm install
if [ $? -ne 0 ]; then
    echo "[错误] 前端依赖安装失败"
    exit 1
fi
echo "[成功] 前端依赖安装完成"

echo
echo "[信息] 启动开发服务..."
echo "[后端] 启动API服务 (端口: 5000)"
echo "[前端] 启动开发服务器 (端口: 8080)"
echo
echo "按 Ctrl+C 停止所有服务"
echo "========================================"

# 启动后端服务
cd ../py
uv run main.py &
BACKEND_PID=$!

# 等待2秒让后端启动
sleep 2

# 启动前端服务
cd ../web
pnpm run dev &
FRONTEND_PID=$!

echo
echo "[成功] 开发服务启动完成！"
echo "后端API: http://localhost:5000"
echo "前端界面: http://localhost:8080"
echo

# 等待用户中断
trap "echo '正在停止服务...'; kill $BACKEND_PID $FRONTEND_PID 2>/dev/null; exit 0" INT

# 等待进程结束
wait
