#!/data/data/com.termux/files/usr/bin/bash

echo "=== OpenClaw Android 一键安装开始 ==="

# 更新系统
pkg update -y && pkg upgrade -y

# 安装依赖
pkg install -y git python rust cargo wget termux-services

# 创建工作目录
mkdir -p ~/openclaw
cd ~/openclaw

# 克隆 OpenClaw
if [ ! -d "openclaw" ]; then
    git clone https://github.com/openclaw/openclaw.git
fi

cd openclaw

# 安装 Python 依赖
pip install --upgrade pip
pip install -r requirements.txt

# 构建 Rust 组件
cargo build --release

# 创建启动脚本
cat > ~/openclaw/start.sh << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
cd ~/openclaw/openclaw
nohup python main.py > ~/openclaw/openclaw.log 2>&1 &
echo "OpenClaw 已在后台启动"
EOF

chmod +x ~/openclaw/start.sh

# 创建 Termux Boot 自动启动脚本
mkdir -p ~/.termux/boot

cat > ~/.termux/boot/openclaw_boot.sh << 'EOF'
#!/data/data/com.termux/files/usr/bin/bash
bash ~/openclaw/start.sh
EOF

chmod +x ~/.termux/boot/openclaw_boot.sh

echo "=== 安装完成！==="
echo "启动命令： bash ~/openclaw/start.sh"
echo "日志查看： tail -f ~/openclaw/openclaw.log"
echo "已配置开机自启（需安装 Termux:Boot）"
