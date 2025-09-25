# wx-dump-plus

[![Python](https://img.shields.io/badge/Python-3.8+-blue.svg)](https://www.python.org/)
[![Vue](https://img.shields.io/badge/Vue-3.x-green.svg)](https://vuejs.org/)
[![Element Plus](https://img.shields.io/badge/Element%20Plus-2.x-orange.svg)](https://element-plus.org/)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://github.com/xaoyaoo/PyWxDump/blob/master/LICENSE)

> 基于 [PyWxDump](https://github.com/xaoyaoo/PyWxDump) 和 [wxdump_web](https://github.com/xaoyaoo/wxdump_web) 的优化升级版本，集成了更多功能特性

## 📖 项目简介

wx-dump-plus 是对原版 PyWxDump 和 wxdump_web 的全面优化升级版本，在保持原有核心功能的基础上，增加了更多实用功能和改进。本项目旨在提供更好的用户体验和更强大的微信数据管理能力。

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

### 安装步骤

#### 1. 克隆项目

```bash
git clone https://github.com/baiyajin/wx-dump-plus.git
cd wx-dump-plus
```

#### 2. 安装后端依赖

```bash
cd py
pip install -r requirements.txt
```

#### 3. 安装前端依赖

```bash
cd ../web
npm install
# 或使用 pnpm
pnpm install
```

#### 4. 构建前端

```bash
npm run build
# 或
pnpm build
```

#### 5. 启动服务

```bash
# 启动后端API服务
cd py
python -m pywxdump.api.local_server

# 或使用命令行工具
wxdump ui
```

访问 http://127.0.0.1:5000 即可使用Web界面。

## 📖 使用说明

### 命令行使用

```bash
# 获取微信信息
wxdump info

# 解密微信数据库
wxdump decrypt -k <密钥> -i <数据库路径> -o <输出路径>

# 启动Web界面
wxdump ui

# 启动API服务
wxdump api
```

### Web界面使用

1. 打开微信电脑版并登录
2. 启动wx-dump-plus服务
3. 在浏览器中访问 http://127.0.0.1:5000
4. 按照界面提示进行操作

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

## 📞 联系方式

- 项目地址：https://github.com/baiyajin/wx-dump-plus
- 问题反馈：https://github.com/baiyajin/wx-dump-plus/issues

---

⭐ 如果这个项目对你有帮助，请给个Star支持一下！