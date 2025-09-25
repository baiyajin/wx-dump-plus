.PHONY: help install dev-install start start-dev stop clean build

help: ## 显示帮助信息
	@echo "wx-dump-plus 项目管理"
	@echo "可用命令："
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

install: ## 安装所有依赖
	@echo "安装后端依赖..."
	cd py && uv sync --index-url https://mirrors.aliyun.com/pypi/simple
	@echo "安装前端依赖..."
	cd web && pnpm install

dev-install: ## 安装开发依赖
	@echo "安装后端开发依赖..."
	cd py && uv sync --dev --index-url https://mirrors.aliyun.com/pypi/simple
	@echo "安装前端依赖..."
	cd web && pnpm install

start: ## 启动生产环境服务
	@echo "启动生产环境服务..."
	@if [ -f start.bat ]; then \
		start.bat; \
	else \
		chmod +x start.sh && ./start.sh; \
	fi

start-dev: ## 启动开发环境服务
	@echo "启动开发环境服务..."
	@if [ -f start-dev.bat ]; then \
		start-dev.bat; \
	else \
		chmod +x start-dev.sh && ./start-dev.sh; \
	fi

backend: ## 只启动后端服务
	@echo "启动后端服务..."
	cd py && uv run main.py

frontend: ## 只启动前端服务
	@echo "启动前端服务..."
	cd web && pnpm run dev

build: ## 构建项目
	@echo "构建后端..."
	cd py && uv build
	@echo "构建前端..."
	cd web && pnpm run build

clean: ## 清理临时文件
	@echo "清理后端临时文件..."
	cd py && rm -rf build/ dist/ *.egg-info/ .pytest_cache/ .coverage htmlcov/
	@echo "清理前端临时文件..."
	cd web && rm -rf dist/ node_modules/.vite/
	@echo "清理完成"

test: ## 运行测试
	@echo "运行后端测试..."
	cd py && uv run pytest
	@echo "运行前端测试..."
	cd web && pnpm run test

format: ## 格式化代码
	@echo "格式化后端代码..."
	cd py && uv run black . && uv run isort .
	@echo "格式化前端代码..."
	cd web && pnpm run format

lint: ## 代码检查
	@echo "检查后端代码..."
	cd py && uv run flake8 . && uv run mypy .
	@echo "检查前端代码..."
	cd web && pnpm run lint

check: format lint test ## 运行所有检查

stop: ## 停止所有服务
	@echo "停止所有服务..."
	@pkill -f "uv run main.py" 2>/dev/null || true
	@pkill -f "pnpm run dev" 2>/dev/null || true
	@echo "服务已停止"
