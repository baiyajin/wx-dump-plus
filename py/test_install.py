#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
测试安装是否成功
"""

def test_imports():
    """测试关键模块导入"""
    try:
        import pywxdump
        print(f"✅ pywxdump 导入成功，版本: {pywxdump.__version__}")
    except ImportError as e:
        print(f"❌ pywxdump 导入失败: {e}")
        return False
    
    try:
        from pywxdump import get_wx_info, batch_decrypt, start_server
        print("✅ 核心函数导入成功")
    except ImportError as e:
        print(f"❌ 核心函数导入失败: {e}")
        return False
    
    try:
        import fastapi
        print(f"✅ FastAPI 导入成功，版本: {fastapi.__version__}")
    except ImportError as e:
        print(f"❌ FastAPI 导入失败: {e}")
        return False
    
    try:
        import uvicorn
        print(f"✅ Uvicorn 导入成功，版本: {uvicorn.__version__}")
    except ImportError as e:
        print(f"❌ Uvicorn 导入失败: {e}")
        return False
    
    return True

def test_cli():
    """测试命令行接口"""
    try:
        from pywxdump.cli import console_run
        print("✅ CLI 模块导入成功")
        return True
    except ImportError as e:
        print(f"❌ CLI 模块导入失败: {e}")
        return False

if __name__ == "__main__":
    print("🔍 测试 wx-dump-plus 安装...")
    print("=" * 50)
    
    success = True
    success &= test_imports()
    success &= test_cli()
    
    print("=" * 50)
    if success:
        print("🎉 所有测试通过！安装成功！")
        print("\n📖 使用方法:")
        print("  uv run main -h          # 查看帮助")
        print("  uv run main info        # 获取微信信息")
        print("  uv run main ui          # 启动Web界面")
    else:
        print("❌ 部分测试失败，请检查安装")
        exit(1)
