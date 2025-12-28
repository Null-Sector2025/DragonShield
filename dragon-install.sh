#!/bin/bash

# NullSector DragonShield 安装脚本
# 版本: 2.0.0
# 作者: NullSector 安全工作室

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# 全局变量
INSTALL_DIR="$HOME/.nullsector"
LOG_FILE="$INSTALL_DIR/install.log"
CONFIG_FILE="$INSTALL_DIR/nullsector.conf"
TOOLS_DIR="$INSTALL_DIR/tools"
WORDLISTS_DIR="$INSTALL_DIR/wordlists"
BACKUP_DIR="$INSTALL_DIR/backup"

# 艺术字显示函数
show_banner() {
    clear
    echo -e "${PURPLE}"
    cat << "EOF"
 ███▄    █  █    ██  ██▓     ██▓    ▓█████  ██▀███  
 ██ ▀█   █  ██  ▓██▒▓██▒    ▓██▒    ▓█   ▀ ▓██ ▒ ██▒
▓██  ▀█ ██▒▓██  ▒██░▒██░    ▒██░    ▒███   ▓██ ░▄█ ▒
▓██▒  ▐▌██▒▓▓█  ░██░▒██░    ▒██░    ▒▓█  ▄ ▒██▀▀█▄  
▒██░   ▓██░▒▒█████▓ ░██████▒░██████▒░▒████▒░██▓ ▒██▒
░ ▒░   ▒ ▒ ░▒▓▒ ▒ ▒ ░ ▒░▓  ░░ ▒░▓  ░░░ ▒░ ░░ ▒▓ ░▒▓░
░ ░░   ░ ▒░░░▒░ ░ ░ ░ ░ ▒  ░░ ░ ▒  ░ ░ ░  ░  ░▒ ░ ▒░
   ░   ░ ░  ░░░ ░ ░   ░ ░     ░ ░      ░     ░░   ░ 
         ░    ░         ░  ░    ░  ░   ░  ░   ░     
                                                       
 ██████ ██▀███  ██░ ██  ██████  ███▄    █ ██▓ ███▄ ▄███▓
▒██    ▒▓██ ▒ ██▓██░ ██▒██    ▒ ██ ▀█   █▓██▒▓██▒▀█▀ ██▒
░ ▓██▄  ▓██ ░▄█ ▒██▀▀██░ ▓██▄  ▓██  ▀█ ██▒██▒▓██    ▓██░
  ▒   ██▒██▀▀█▄ ░▓█ ░██  ▒   ██▓██▒  ▐▌██▒██░▒██    ▒██ 
▒██████▒░██▓ ▒██░▓█▒░██▒██████▒▒██░   ▓██░██░▒██▒   ░██▒
▒ ▒▓▒ ▒ ░ ▒▓ ░▒▓░ ▒ ░░▒░▒ ▒▓▒ ▒░░ ▒░   ▒ ▒░▓  ░ ▒░   ░  ░
░ ░▒  ░ ░ ░▒ ░ ▒░ ▒ ░▒░ ░ ░▒  ░ ░░ ░░   ░ ▒░ ▒ ░░  ░      ░
░  ░  ░   ░░   ░  ░  ░░ ░  ░  ░     ░   ░ ░  ▒ ░░      ░   
      ░    ░      ░  ░  ░      ░           ░  ░         ░   
                                                       
                 DragonShield v2.0
            NullSector 网络安全工作室
EOF
    echo -e "${NC}"
    echo -e "${CYAN}================================================================${NC}"
    echo -e "${YELLOW}            高级网络防护与渗透测试套件${NC}"
    echo -e "${CYAN}================================================================${NC}\n"
}

# 进度条函数
progress_bar() {
    local duration=$1
    local total=50
    local sleep_duration=$(echo "scale=3; $duration/$total" | bc)
    local progress=0
    
    printf "${GREEN}["
    while [ $progress -lt $total ]; do
        printf "█"
        progress=$((progress + 1))
        sleep $sleep_duration
    done
    printf "]${NC}\n"
}

# 检查系统类型
check_system() {
    echo -e "${BLUE}[*] 检测系统信息...${NC}"
    
    if [[ -f /etc/os-release ]]; then
        . /etc/os-release
        OS=$NAME
        VER=$VERSION_ID
    elif type lsb_release >/dev/null 2>&1; then
        OS=$(lsb_release -si)
        VER=$(lsb_release -sr)
    elif [[ -f /etc/redhat-release ]]; then
        OS=$(cat /etc/redhat-release | awk '{print $1}')
        VER=$(cat /etc/redhat-release | awk '{print $4}' | cut -d'.' -f1)
    else
        OS=$(uname -s)
        VER=$(uname -r)
    fi
    
    echo -e "${GREEN}[+] 系统: $OS $VER${NC}"
    
    # 检查包管理器
    if command -v apt-get &> /dev/null; then
        PKG_MANAGER="apt-get"
        INSTALL_CMD="sudo apt-get install -y"
    elif command -v yum &> /dev/null; then
        PKG_MANAGER="yum"
        INSTALL_CMD="sudo yum install -y"
    elif command -v pacman &> /dev/null; then
        PKG_MANAGER="pacman"
        INSTALL_CMD="sudo pacman -S --noconfirm"
    elif command -v dnf &> /dev/null; then
        PKG_MANAGER="dnf"
        INSTALL_CMD="sudo dnf install -y"
    else
        echo -e "${RED}[!] 不支持的包管理器${NC}"
        exit 1
    fi
    
    echo -e "${GREEN}[+] 包管理器: $PKG_MANAGER${NC}"
}

# 检查依赖
check_dependencies() {
    echo -e "${BLUE}[*] 检查依赖项...${NC}"
    
    local deps=("git" "curl" "wget" "python3" "pip3" "nmap" "netcat")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v $dep &> /dev/null; then
            missing+=($dep)
        fi
    done
    
    if [ ${#missing[@]} -eq 0 ]; then
        echo -e "${GREEN}[+] 所有依赖已安装${NC}"
        return 0
    else
        echo -e "${YELLOW}[!] 缺少依赖: ${missing[*]}${NC}"
        return 1
    fi
}

# 安装依赖
install_dependencies() {
    echo -e "${BLUE}[*] 安装依赖包...${NC}"
    progress_bar 5
    
    # 更新包列表
    if [ "$PKG_MANAGER" = "apt-get" ]; then
        sudo apt-get update
        sudo $INSTALL_CMD git curl wget python3 python3-pip nmap netcat-traditional \
            libpcap-dev libssl-dev zlib1g-dev libxml2-dev libxslt1-dev \
            build-essential ruby ruby-dev golang nodejs npm perl
    elif [ "$PKG_MANAGER" = "yum" ]; then
        sudo yum update -y
        sudo $INSTALL_CMD git curl wget python3 python3-pip nmap nc \
            libpcap-devel openssl-devel zlib-devel libxml2-devel \
            libxslt-devel gcc-c++ ruby ruby-devel golang nodejs npm perl
    fi
    
    # 安装Python模块
    echo -e "${BLUE}[*] 安装Python模块...${NC}"
    pip3 install --upgrade pip
    pip3 install requests beautifulsoup4 scapy paramiko cryptography \
        colorama dnspython ipaddress pyfiglet
    
    echo -e "${GREEN}[+] 依赖安装完成${NC}"
}

# 创建目录结构
create_directories() {
    echo -e "${BLUE}[*] 创建目录结构...${NC}"
    
    mkdir -p "$INSTALL_DIR"
    mkdir -p "$TOOLS_DIR"
    mkdir -p "$WORDLISTS_DIR"
    mkdir -p "$BACKUP_DIR"
    mkdir -p "$INSTALL_DIR/modules"
    mkdir -p "$INSTALL_DIR/logs"
    mkdir -p "$INSTALL_DIR/results"
    
    echo -e "${GREEN}[+] 目录创建完成${NC}"
}

# 下载工具和字典
download_tools() {
    echo -e "${BLUE}[*] 下载工具和资源...${NC}"
    
    # 创建下载进度显示函数
    download_with_progress() {
        local url=$1
        local output=$2
        echo -n "下载 $(basename $output)... "
        wget --progress=dot "$url" -O "$output" 2>&1 | \
            grep --line-buffered "%" | \
            sed -u -e "s,\.,,g" | \
            awk '{printf("\b\b\b\b%4s", $2)}'
        echo -ne "\b\b\b\b"
        echo " 完成"
    }
    
    # 下载常用字典
    echo -e "${CYAN}[+] 下载字典文件...${NC}"
    progress_bar 3
    
    # 常见用户名字典
    if [ ! -f "$WORDLISTS_DIR/usernames.txt" ]; then
        curl -s "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Usernames/top-usernames-shortlist.txt" \
            -o "$WORDLISTS_DIR/usernames.txt"
    fi
    
    # 常见密码字典
    if [ ! -f "$WORDLISTS_DIR/passwords.txt" ]; then
        curl -s "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Passwords/Common-Credentials/10-million-password-list-top-1000000.txt" \
            -o "$WORDLISTS_DIR/passwords.txt"
    fi
    
    # 子域名字典
    if [ ! -f "$WORDLISTS_DIR/subdomains.txt" ]; then
        curl -s "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/DNS/subdomains-top1million-110000.txt" \
            -o "$WORDLISTS_DIR/subdomains.txt"
    fi
    
    # 目录爆破字典
    if [ ! -f "$WORDLISTS_DIR/directories.txt" ]; then
        curl -s "https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/common.txt" \
            -o "$WORDLISTS_DIR/directories.txt"
    fi
    
    echo -e "${GREEN}[+] 字典下载完成${NC}"
}

# 创建配置文件
create_config() {
    echo -e "${BLUE}[*] 创建配置文件...${NC}"
    
    cat > "$CONFIG_FILE" << EOF
# NullSector DragonShield 配置文件
# 版本: 2.0.0

[Paths]
install_dir=$INSTALL_DIR
tools_dir=$TOOLS_DIR
wordlists_dir=$WORDLISTS_DIR
backup_dir=$BACKUP_DIR
log_dir=$INSTALL_DIR/logs
results_dir=$INSTALL_DIR/results

[Settings]
auto_update=true
enable_logging=true
max_log_size=10MB
color_scheme=dragon
enable_sound=false
proxy_enabled=false
proxy_host=
proxy_port=

[Tools]
nmap_path=$(which nmap)
python3_path=$(which python3)
git_path=$(which git)
curl_path=$(which curl)

[Wordlists]
usernames=$WORDLISTS_DIR/usernames.txt
passwords=$WORDLISTS_DIR/passwords.txt
subdomains=$WORDLISTS_DIR/subdomains.txt
directories=$WORDLISTS_DIR/directories.txt
EOF
    
    echo -e "${GREEN}[+] 配置文件创建完成${NC}"
}

# 安装主程序
install_main_program() {
    echo -e "${BLUE}[*] 安装主程序...${NC}"
    progress_bar 2
    
    # 创建启动脚本
    cat > "/usr/local/bin/dragonshield" << EOF
#!/bin/bash
$INSTALL_DIR/dragonshield.sh "\$@"
EOF
    
    chmod +x "/usr/local/bin/dragonshield"
    chmod +x "$INSTALL_DIR/dragonshield.sh"
    
    echo -e "${GREEN}[+] 主程序安装完成${NC}"
}

# 显示安装完成信息
show_completion() {
    echo -e "${CYAN}\n"
    cat << "EOF"
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣀⣀⣀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⠾⠛⠉⠉⠉⠉⠉⠉⠛⠷⣦⣀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⢀⣴⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠻⣦⡀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⣰⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣦⠀⠀⠀⠀
⠀⠀⠀⠀⢀⣾⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣧⡀⠀⠀
⠀⠀⠀⢀⣾⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣧⡀⠀
⠀⠀⢀⣾⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣧⡀
⠀⢀⣾⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⣧
⢀⣾⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢻
⣾⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸
⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼
⣿⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣿
⠸⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⠇
⠀⠹⣧⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⠃⠀
⠀⠀⠘⢷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⡾⠃⠀⠀
⠀⠀⠀⠀⠙⠻⣶⣤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣶⠟⠋⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠉⠙⠛⠻⠷⠶⠶⠶⠶⠶⠶⠟⠛⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀

          龙盾已激活！准备作战！
EOF
    echo -e "${NC}"
    
    echo -e "${GREEN}=======================================================${NC}"
    echo -e "${YELLOW}        NullSector DragonShield 安装完成！${NC}"
    echo -e "${GREEN}=======================================================${NC}"
    echo -e ""
    echo -e "${CYAN}[信息] 安装目录: ${BOLD}$INSTALL_DIR${NC}"
    echo -e "${CYAN}[信息] 配置文件: ${BOLD}$CONFIG_FILE${NC}"
    echo -e "${CYAN}[信息] 工具目录: ${BOLD}$TOOLS_DIR${NC}"
    echo -e "${CYAN}[信息] 字典目录: ${BOLD}$WORDLISTS_DIR${NC}"
    echo -e ""
    echo -e "${YELLOW}[用法] 启动程序: ${BOLD}dragonshield${NC}"
    echo -e "${YELLOW}[用法] 查看帮助: ${BOLD}dragonshield --help${NC}"
    echo -e ""
    echo -e "${PURPLE}警告: 本工具仅用于授权的安全测试！${NC}"
    echo -e "${PURPLE}      未经授权的使用是非法的！${NC}"
    echo -e ""
    echo -e "${BLUE}NullSector 安全工作室 - 守护网络安全${NC}"
}

# 主安装流程
main() {
    show_banner
    
    # 检查root权限
    if [ "$EUID" -eq 0 ]; then 
        echo -e "${RED}[!] 警告：不建议使用root权限运行安装脚本${NC}"
        read -p "是否继续? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            exit 1
        fi
    fi
    
    echo -e "${YELLOW}[!] 本安装将需要大约5-10分钟，取决于网络速度${NC}"
    echo -e "${YELLOW}[!] 需要sudo权限来安装系统包${NC}\n"
    
    read -p "按 Enter 键继续安装..." 
    
    # 记录安装开始时间
    START_TIME=$(date +%s)
    
    # 执行安装步骤
    check_system
    create_directories
    check_dependencies
    if [ $? -ne 0 ]; then
        install_dependencies
    fi
    download_tools
    create_config
    install_main_program
    
    # 计算安装时间
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))
    
    echo -e "${GREEN}[+] 安装完成！耗时: ${DURATION} 秒${NC}"
    
    show_completion
    
    # 创建卸载脚本
    cat > "$INSTALL_DIR/uninstall.sh" << EOF
#!/bin/bash
echo "卸载 DragonShield..."
sudo rm -f /usr/local/bin/dragonshield
echo "是否删除所有数据? ($INSTALL_DIR) [y/N]: "
read -r response
if [[ \$response =~ ^[Yy]$ ]]; then
    rm -rf "$INSTALL_DIR"
    echo "所有数据已删除"
else
    echo "数据保留在 $INSTALL_DIR"
fi
EOF
    
    chmod +x "$INSTALL_DIR/uninstall.sh"
}

# 执行主函数
main