#!/bin/bash

# DragonShield Mobile - Termux 安装脚本
# 版本: 2.0.0-mobile
# GitHub: https://github.com/Null-Sector2025/DragonShield

# 龙形艺术字
show_mobile_banner() {
    clear
    echo -e "\033[1;35m"
    cat << "EOF"

 ╔══════════════════════════════════════╗
 ║       🐉 DragonShield Mobile 🐉     ║
 ║       NullSector 移动安全套件       ║
 ╚══════════════════════════════════════╝
 
    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
    ░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░
    ░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░
    ░░▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓░░
    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
    
    龙行天下 · 指尖安全 · 移动守护
EOF
    echo -e "\033[0m"
}

# 检查Termux环境
check_termux() {
    echo -e "\033[1;36m[*] 检查Termux环境...\033[0m"
    
    if [ ! -d "/data/data/com.termux" ]; then
        echo -e "\033[1;31m[!] 错误：未检测到Termux环境\033[0m"
        echo -e "\033[1;33m请从F-Droid安装Termux应用\033[0m"
        exit 1
    fi
    
    echo -e "\033[1;32m[✓] Termux环境检测通过\033[0m"
}

# 安装基础依赖
install_dependencies() {
    echo -e "\033[1;36m[*] 更新Termux包管理器...\033[0m"
    pkg update -y && pkg upgrade -y
    
    echo -e "\033[1;36m[*] 安装基础工具...\033[0m"
    pkg install -y python python-pip git curl wget nmap \
        netcat-openbsd nano vim termux-api jq
    
    echo -e "\033[1;36m[*] 安装Python模块...\033[0m"
    pip install --upgrade pip
    pip install requests beautifulsoup4 colorama \
        dnspython ipaddress scapy-python3
    
    echo -e "\033[1;32m[✓] 依赖安装完成\033[0m"
}

# 安装移动专用工具
install_mobile_tools() {
    echo -e "\033[1;36m[*] 安装移动专用工具...\033[0m"
    
    # 1. 网络工具
    pkg install -y net-tools iproute2 tcpdump openssl
    
    # 2. 扫描工具
    pkg install -y dnsutils whois traceroute
    
    # 3. 开发工具
    pkg install -y nodejs-lts ruby perl golang
    
    # 4. 实用工具
    pkg install -y zip unzip tar p7zip
    
    echo -e "\033[1;32m[✓] 移动工具安装完成\033[0m"
}

# 配置Termux环境
configure_termux() {
    echo -e "\033[1;36m[*] 配置Termux环境...\033[0m"
    
    # 创建目录结构
    mkdir -p ~/.termux
    mkdir -p ~/.nullsector-mobile
    mkdir -p ~/.nullsector-mobile/tools
    mkdir -p ~/.nullsector-mobile/wordlists
    mkdir -p ~/.nullsector-mobile/logs
    
    # 配置Termux终端
    cat > ~/.termux/termux.properties << EOF
# DragonShield 终端配置
extra-keys = [['ESC','/','-','HOME','UP','END','PGUP'],['TAB','CTRL','ALT','LEFT','DOWN','RIGHT','PGDN']]
bell-character = ignore
use-black-ui = false
EOF
    
    # 请求存储权限
    termux-setup-storage
    
    echo -e "\033[1;32m[✓] 环境配置完成\033[0m"
}

# 下载移动专用字典
download_mobile_wordlists() {
    echo -e "\033[1;36m[*] 下载移动专用字典...\033[0m"
    
    WORDLISTS_DIR="$HOME/.nullsector-mobile/wordlists"
    
    # 小型化字典（适合手机）
    if [ ! -f "$WORDLISTS_DIR/passwords-small.txt" ]; then
        echo -e "\033[1;33m[+] 下载密码字典...\033[0m"
        curl -s "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Passwords/Common-Credentials/10k-most-common.txt" \
            -o "$WORDLISTS_DIR/passwords-small.txt"
    fi
    
    if [ ! -f "$WORDLISTS_DIR/usernames-small.txt" ]; then
        echo -e "\033[1;33m[+] 下载用户名字典...\033[0m"
        curl -s "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Usernames/top-usernames-shortlist.txt" \
            -o "$WORDLISTS_DIR/usernames-small.txt"
    fi
    
    # 生成手机常用密码
    cat > "$WORDLISTS_DIR/mobile-passwords.txt" << EOF
123456
password
12345678
1234
12345
qwerty
111111
000000
admin
password123
123123
654321
1234567
123456789
iloveyou
sunshine
princess
welcome
football
123
admin123
123qwe
dragon
monkey
letmein
login
passw0rd
master
hello
freedom
whatever
qazwsx
trustno1
EOF
    
    echo -e "\033[1;32m[✓] 字典下载完成\033[0m"
}

# 安装主程序
install_main_program() {
    echo -e "\033[1;36m[*] 安装DragonShield Mobile...\033[0m"
    
    # 复制主程序
    cp dragonshield-mobile.sh $HOME/dragonshield-mobile
    cp mobile-config.conf $HOME/.nullsector-mobile/config.conf
    
    # 设置权限
    chmod +x $HOME/dragonshield-mobile
    chmod +x dragonshield-mobile.sh
    
    # 创建启动别名
    echo 'alias dragonshield="~/dragonshield-mobile"' >> $HOME/.bashrc
    echo 'alias dsm="~/dragonshield-mobile"' >> $HOME/.bashrc
    
    echo -e "\033[1;32m[✓] 主程序安装完成\033[0m"
}

# 显示完成信息
show_completion() {
    clear
    echo -e "\033[1;35m"
    cat << "EOF"

 ╔══════════════════════════════════════╗
 ║        🎉 安装完成！ 🎉            ║
 ╚══════════════════════════════════════╝
 
    ╭─────────────────────────────╮
    │   🐉 移动龙盾已激活 🛡️      │
    ╰─────────────────────────────╯
    
    🔥 特色功能：
    ├─ 📱 移动优化扫描
    ├─ 🌐 便携式信息收集
    ├─ 🔍 轻量级漏洞检测
    ├─ 📊 离线分析工具
    └─ 🎯 手机专用模块
    
    🚀 启动命令：
    dragonshield  或  dsm
    
    📁 安装目录：
    ~/.nullsector-mobile/
    
    ⚠️  免责声明：
    仅用于授权的安全测试！
    遵守当地法律法规！
    
    © 2025 NullSector 移动安全部
EOF
    echo -e "\033[0m"
    
    # 重新加载配置
    source $HOME/.bashrc
    
    echo -e "\033[1;33m\n[*] 正在启动 DragonShield Mobile...\033[0m"
    sleep 2
    ~/dragonshield-mobile
}

# 主安装流程
main() {
    show_mobile_banner
    
    echo -e "\033[1;33m[*] DragonShield Mobile 安装开始\033[0m"
    echo -e "\033[1;33m[*] 需要稳定的网络连接\033[0m"
    
    # 检查Termux
    check_termux
    
    # 安装步骤
    install_dependencies
    install_mobile_tools
    configure_termux
    download_mobile_wordlists
    install_main_program
    
    # 完成
    show_completion
}

# 启动安装
main