.PHONY: help install dev-install run test clean build format lint

help: ## 显示帮助信息
	@echo "wx-dump-plus Python 后端"
	@echo "可用命令："
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2}'

install: ## 安装依赖
	uv sync

dev-install: ## 安装开发依赖
	uv sync --dev

run: ## 运行程序
	uv run main

run-ui: ## 启动Web界面
	uv run main ui

run-api: ## 启动API服务
	uv run main api

test: ## 运行测试
	uv run pytest

test-cov: ## 运行测试并生成覆盖率报告
	uv run pytest --cov=pywxdump --cov-report=html

clean: ## 清理临时文件
	rm -rf build/
	rm -rf dist/
	rm -rf *.egg-info/
	rm -rf .pytest_cache/
	rm -rf .coverage
	rm -rf htmlcov/
	find . -type d -name __pycache__ -exec rm -rf {} +
	find . -type f -name "*.pyc" -delete

build: ## 构建包
	uv build

format: ## 格式化代码
	uv run black .
	uv run isort .

lint: ## 代码检查
	uv run flake8 .
	uv run mypy .

check: format lint test ## 运行所有检查

install-dev: ## 开发模式安装
	pip install -e .

install-system: ## 系统安装
	pip install .

uninstall: ## 卸载
	pip uninstall wx-dump-plus -y
