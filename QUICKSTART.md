# wx-dump-plus 快速开始指南

## 🎯 一键启动

### Windows 用户

1. **克隆项目**
   ```cmd
   git clone https://github.com/baiyajin/wx-dump-plus.git
   cd wx-dump-plus
   ```

2. **一键启动**
   ```cmd
   # 生产环境启动
   start.bat
   
   # 开发环境启动
   start-dev.bat
   ```

3. **访问服务**
   - 前端界面: http://localhost:5173
   - 后端API: http://localhost:5000

### Linux/Mac 用户

1. **克隆项目**
   ```bash
   git clone https://github.com/baiyajin/wx-dump-plus.git
   cd wx-dump-plus
   ```

2. **添加执行权限**
   ```bash
   chmod +x start.sh start-dev.sh
   ```

3. **一键启动**
   ```bash
   # 生产环境启动
   ./start.sh
   
   # 开发环境启动
   ./start-dev.sh
   ```

4. **访问服务**
   - 前端界面: http://localhost:5173
   - 后端API: http://localhost:5000

## 🛠️ 环境准备

### 必需工具

1. **Python 3.8+**
   ```bash
   # 检查Python版本
   python --version
   ```

2. **Node.js 16+**
   ```bash
   # 检查Node.js版本
   node --version
   ```

3. **安装uv (Python包管理器)**
   ```bash
   pip install uv
   ```

4. **安装pnpm (Node.js包管理器)**
   ```bash
   npm install -g pnpm
   ```

## 🚀 使用Makefile

如果你喜欢使用Make命令：

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

# 停止所有服务
make stop

# 清理临时文件
make clean
```

## 🔧 手动启动

如果一键启动脚本有问题，可以手动启动：

### 启动后端

```bash
cd py
uv sync --index-url https://mirrors.aliyun.com/pypi/simple
uv run main.py
```

### 启动前端

```bash
cd web
pnpm install
pnpm run dev
```

## ❓ 常见问题

### 1. uv 命令未找到
```bash
pip install uv
```

### 2. pnpm 命令未找到
```bash
npm install -g pnpm
```

### 3. 端口被占用
- 后端默认端口: 5000
- 前端默认端口: 5173
- 可以修改配置文件更改端口

### 4. 依赖安装失败
- 检查网络连接
- 尝试使用国内镜像源
- 清除缓存后重新安装

## 📞 获取帮助

- 查看详细文档: [README.md](README.md)
- 后端文档: [py/README.md](py/README.md)
- 前端文档: [web/README.md](web/README.md)
- 问题反馈: [Issues](https://github.com/baiyajin/wx-dump-plus/issues)
- QQ技术群: 860104909
