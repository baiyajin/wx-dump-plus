#!/bin/bash

echo "Starting wx-dump-plus..."
echo

# 检查是否安装了uv
if ! command -v uv &> /dev/null; then
    echo "Error: uv is not installed. Please install uv first."
    echo "Run: pip install uv"
    exit 1
fi

# 检查是否存在虚拟环境
if [ ! -d ".venv" ]; then
    echo "Creating virtual environment..."
    uv venv
fi

# 安装依赖
echo "Installing dependencies..."
uv sync

# 运行程序
echo "Starting wx-dump-plus..."
uv run main "$@"
