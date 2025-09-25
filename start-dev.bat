@echo off
chcp 65001 >nul
echo ========================================
echo    wx-dump-plus 开发模式启动脚本
echo ========================================
echo.

REM 检查是否安装了uv
where uv >nul 2>nul
if %errorlevel% neq 0 (
    echo [错误] 未检测到 uv，请先安装 uv
    echo 安装命令: pip install uv
    pause
    exit /b 1
)

REM 检查是否安装了pnpm
where pnpm >nul 2>nul
if %errorlevel% neq 0 (
    echo [错误] 未检测到 pnpm，请先安装 pnpm
    echo 安装命令: npm install -g pnpm
    pause
    exit /b 1
)

echo [信息] 开始安装后端开发依赖...
cd py
call uv sync --dev --index-url https://mirrors.aliyun.com/pypi/simple
if %errorlevel% neq 0 (
    echo [错误] 后端依赖安装失败
    pause
    exit /b 1
)
echo [成功] 后端开发依赖安装完成

echo.
echo [信息] 开始安装前端依赖...
cd ..\web
call pnpm install
if %errorlevel% neq 0 (
    echo [错误] 前端依赖安装失败
    pause
    exit /b 1
)
echo [成功] 前端依赖安装完成

echo.
echo [信息] 启动开发服务...
echo [后端] 启动API服务 (端口: 5000)
echo [前端] 启动开发服务器 (端口: 8080)
echo.
echo 按 Ctrl+C 停止所有服务
echo ========================================

REM 启动后端服务
start "wx-dump-plus 后端" cmd /k "cd /d %~dp0py && uv run main.py"

REM 等待2秒让后端启动
timeout /t 2 /nobreak >nul

REM 启动前端服务
start "wx-dump-plus 前端" cmd /k "cd /d %~dp0web && pnpm run dev"

echo.
echo [成功] 开发服务启动完成！
echo 后端API: http://localhost:5000
echo 前端界面: http://localhost:8080
echo.
pause
