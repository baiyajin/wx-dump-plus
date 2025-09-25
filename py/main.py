#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
wx-dump-plus 主程序入口
基于 PyWxDump 的优化升级版本
"""

import sys
import os

# 添加当前目录到Python路径
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from pywxdump.cli import console_run

if __name__ == "__main__":
    console_run()
