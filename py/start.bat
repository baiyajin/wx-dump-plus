@echo off
echo Starting wx-dump-plus...
echo.

REM 检查是否安装了uv
where uv >nul 2>nul
if %errorlevel% neq 0 (
    echo Error: uv is not installed. Please install uv first.
    echo Run: pip install uv
    pause
    exit /b 1
)

REM 检查是否存在虚拟环境
if not exist ".venv" (
    echo Creating virtual environment...
    uv venv
)

REM 安装依赖
echo Installing dependencies...
uv sync

REM 运行程序
echo Starting wx-dump-plus...
REM use the installed console script name 'wxdump' (defined in setup.py) instead of 'main'
uv run wxdump %*

pause
