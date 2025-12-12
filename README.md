# wx-dump-plus

[![Python](https://img.shields.io/badge/Python-3.8+-blue.svg)](https://www.python.org/)
[![Vue](https://img.shields.io/badge/Vue-3.x-green.svg)](https://vuejs.org/)
[![Element Plus](https://img.shields.io/badge/Element%20Plus-2.x-orange.svg)](https://element-plus.org/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/xaoyaoo/PyWxDump/blob/master/LICENSE)

---

## 🚀 推荐使用新项目：wx-dump-4

<div align="center">

### ⭐ 全新版本，基于 Rust + Vue 3 构建，性能更优！

<a href="https://github.com/baiyajin/wx-dump-4">
  <img src="https://github.com/baiyajin/wx-dump-4/raw/main/logo.png" alt="wx-dump-4 Logo" width="200">
</a>

### [👉 立即前往 wx-dump-4 项目 👈](https://github.com/baiyajin/wx-dump-4)

**wx-dump-4** 是使用 **Rust** 重写的全新版本，具有以下优势：

🚀 **更高性能**：Rust 原生性能，内存安全  
🔒 **更安全**：编译期安全检查，避免内存泄漏  
📦 **更小体积**：单一可执行文件，无需 Python 环境  
⚡ **更快启动**：启动速度更快，资源占用更少  
🎯 **专注 4.0+**：专门针对微信 4.0+ 版本优化

**建议新用户直接使用 [wx-dump-4](https://github.com/baiyajin/wx-dump-4)，老用户可继续使用本项目的 Python 版本。**

</div>

---

> 基于 [PyWxDump](https://github.com/xaoyaoo/PyWxDump) 和 [wxdump_web](https://github.com/xaoyaoo/wxdump_web) 的优化升级版本，集成了更多功能特性

## 📖 项目简介

wx-dump-plus 是对原版 PyWxDump 和 wxdump_web 的全面优化升级版本，在保持原有核心功能的基础上，增加了更多实用功能和改进。本项目旨在提供更好的用户体验和更强大的微信数据管理能力。

## 📖 项目预览
<img width="1912" height="924" alt="image" src="https://github.com/user-attachments/assets/4d9b8419-00e1-4dda-8f4e-99aedffdc00c" />
<img width="1912" height="924" alt="image" src="https://github.com/user-attachments/assets/b9d4a86b-45f0-48d0-b40d-f554908be6f3" />


### 🎯 核心功能

- **微信信息获取**：获取微信昵称、账号、手机号、邮箱、数据库密钥等
- **数据库解密**：支持微信数据库的自动解密和合并
- **聊天记录查看**：通过现代化Web界面查看聊天记录
- **数据导出**：支持导出为HTML、CSV、JSON等多种格式
- **统计分析**：提供聊天数据的可视化分析
- **多账户支持**：支持微信多开场景下的多用户管理

### ✨ 新增功能特性

- 🚀 **性能优化**：优化了数据库读取和界面渲染性能
- 🎨 **界面升级**：采用Vue 3 + Element Plus构建的现代化界面
- 📊 **数据分析**：新增聊天数据统计和可视化功能
- 🔧 **工具集成**：集成了更多实用工具和功能
- 📱 **响应式设计**：支持多种设备尺寸的适配
- 🛡️ **安全增强**：改进了数据安全和隐私保护机制

## 🏗️ 项目结构

```
wx-dump-plus/
├── py/                    # Python后端
│   ├── pywxdump/         # 核心功能模块
│   │   ├── wx_core/      # 微信核心功能
│   │   ├── db/           # 数据库处理
│   │   ├── api/          # API接口
│   │   ├── analyzer/     # 数据分析
│   │   └── ui/           # UI相关
│   ├── doc/              # 文档
│   ├── tests/            # 测试文件
│   └── requirements.txt  # Python依赖
├── web/                  # Vue前端
│   ├── src/              # 源代码
│   │   ├── components/   # 组件
│   │   ├── views/        # 页面
│   │   ├── api/          # API调用
│   │   └── utils/        # 工具函数
│   ├── public/           # 静态资源
│   └── package.json      # 前端依赖
└── README.md
```

## 🚀 快速开始

### 环境要求

- Python 3.8+
- Node.js 16+
- Windows 10 64位及以上
- uv (Python包管理器)
- pnpm (Node.js包管理器)

### 一键启动（推荐）

#### Windows
```cmd
# 克隆项目
git clone https://github.com/baiyajin/wx-dump-plus.git
cd wx-dump-plus

# 一键启动（自动安装依赖并启动服务）
start.bat

# 开发模式启动
start-dev.bat
```

#### Linux/Mac
```bash
# 克隆项目
git clone https://github.com/baiyajin/wx-dump-plus.git
cd wx-dump-plus

# 添加执行权限
chmod +x start.sh start-dev.sh

# 一键启动（自动安装依赖并启动服务）
./start.sh

# 开发模式启动
./start-dev.sh
```

#### 使用Makefile
```bash
# 安装所有依赖
make install

# 启动生产环境服务
make start

# 启动开发环境服务
make start-dev

# 只启动后端服务
make backend

# 只启动前端服务
make frontend
```

### 手动安装步骤

详情见py目录跟web目录的README.md文件

## 🔧 功能特性

### 核心功能

- ✅ 微信信息获取（昵称、账号、手机、邮箱、密钥）
- ✅ 数据库自动解密
- ✅ 聊天记录查看和搜索
- ✅ 多媒体文件管理
- ✅ 数据导出（HTML、CSV、JSON）

### 新增功能

- 🆕 聊天数据统计分析
- 🆕 词云生成
- 🆕 聊天趋势图表
- 🆕 联系人管理优化
- 🆕 批量操作功能
- 🆕 数据清理工具
- 🆕 实时消息监控

## 📊 技术栈

### 后端

- **Python 3.8+**
- **FastAPI** - 现代Web框架
- **SQLite** - 数据库
- **pycryptodomex** - 加密解密
- **psutil** - 系统监控

### 前端

- **Vue 3** - 渐进式框架
- **Element Plus** - UI组件库
- **ECharts** - 数据可视化
- **TypeScript** - 类型安全
- **Vite** - 构建工具

## 🤝 贡献指南

欢迎贡献代码！请遵循以下步骤：

1. Fork 本仓库
2. 创建特性分支 (`git checkout -b feature/AmazingFeature`)
3. 提交更改 (`git commit -m 'Add some AmazingFeature'`)
4. 推送到分支 (`git push origin feature/AmazingFeature`)
5. 创建 Pull Request

## ⚠️ 免责声明

**重要：本项目仅供学习交流使用，请勿用于非法用途！**

- 本项目仅用于技术研究和学习目的
- 严禁用于窃取他人隐私或进行非法活动
- 用户需自行承担使用本项目的所有责任
- 请遵守相关法律法规和道德规范

## 🙏 致谢

特别感谢以下开源项目：

- [PyWxDump](https://github.com/xaoyaoo/PyWxDump) - 原作者 [@xaoyaoo](https://github.com/xaoyaoo) 的无私开源
- [wxdump_web](https://github.com/xaoyaoo/wxdump_web) - Web界面参考
- [SharpWxDump](https://github.com/AdminTest0/SharpWxDump) - 原始C#版本

感谢所有为开源社区做出贡献的开发者们！

## 📄 许可证

本项目基于 [MIT License](LICENSE) 开源协议。

### 推荐项目：my-wx-4

<a href="https://github.com/baiyajin/my-wx-4">
  <img src="https://github.com/baiyajin/my-wx-4/raw/main/logo.png" alt="my-wx-4 Logo" width="40" height="40">
</a>

### [👉 查看 my-wx-4 项目 👈](https://github.com/baiyajin/my-wx-4)

⭐ 如果这个项目对你有帮助，请给个Star支持一下！


