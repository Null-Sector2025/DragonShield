#!/bin/bash

# DragonShield Mobile - 手机版主程序
# 版本: 2.0.0-mobile
# 适用于 Termux 环境

# 配置路径
CONFIG_DIR="$HOME/.nullsector-mobile"
CONFIG_FILE="$CONFIG_DIR/config.conf"
TOOLS_DIR="$CONFIG_DIR/tools"
WORDLISTS_DIR="$CONFIG_DIR/wordlists"
LOG_DIR="$CONFIG_DIR/logs"

# 颜色定义
R='\033[1;31m'
G='\033[1;32m'
Y='\033[1;33m'
B='\033[1;34m'
P='\033[1;35m'
C='\033[1;36m'
W='\033[1;37m'
NC='\033[0m'

# 手机专用横幅
show_mobile_header() {
    clear
    echo -e "${P}"
    cat << "EOF"
 ═══════════════════════════════════════
   ██████╗ ██████╗  █████╗  ██████╗ ███╗   ██╗
  ██╔════╝ ██╔══██╗██╔══██╗██╔════╝ ████╗  ██║
  ██║  ███╗██████╔╝███████║██║  ███╗██╔██╗ ██║
  ██║   ██║██╔══██╗██╔══██║██║   ██║██║╚██╗██║
  ╚██████╔╝██║  ██║██║  ██║╚██████╔╝██║ ╚████║
   ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚═╝  ╚═══╝
  
   ███████╗██╗  ██╗██╗███████╗██╗     ██████╗ 
   ██╔════╝██║  ██║██║██╔════╝██║     ██╔══██╗
   ███████╗███████║██║█████╗  ██║     ██║  ██║
   ╚════██║██╔══██║██║██╔══╝  ██║     ██║  ██║
   ███████║██║  ██║██║███████╗███████╗██████╔╝
   ╚══════╝╚═╝  ╚═╝╚═╝╚══════╝╚══════╝╚═════╝ 
 ═══════════════════════════════════════
         Mobile Edition v2.0.0
EOF
    echo -e "${NC}"
    
    # 显示手机信息
    echo -e "${C}📱 设备信息:${NC}"
    echo -e "  ${Y}用户:${NC} $(whoami)"
    echo -e "  ${Y}设备:${NC} $(getprop ro.product.model 2>/dev/null || echo 'Android')"
    echo -e "  ${Y}系统:${NC} $(uname -o)"
    echo -e "  ${Y}时间:${NC} $(date '+%Y-%m-%d %H:%M:%S')"
    echo -e "${C}════════════════════════════════════════${NC}"
}

# 手机优化菜单
show_mobile_menu() {
    echo -e "\n${B}┌─────────────────────────────────────────┐${NC}"
    echo -e "${B}│     📱 移动安全套件 - 主菜单     │${NC}"
    echo -e "${B}├─────────────────────────────────────────┤${NC}"
    
    echo -e "${B}│  ${G}🔍 信息收集 (移动优化)${NC}${B}        │${NC}"
    echo "  1. 网络信息扫描       2. 端口快速扫描"
    echo "  3. DNS信息查询        4. WHOIS查询"
    echo "  5. 子域名探测         6. 网站技术识别"
    
    echo -e "${B}│  ${Y}🛡️  漏洞检测 (轻量级)${NC}${B}        │${NC}"
    echo "  7. Web漏洞扫描       8. SSL/TLS检测"
    echo "  9. 目录文件探测      10. 敏感信息发现"
    echo "  11. API安全测试      12. CORS配置检测"
    
    echo -e "${B}│  ${R}🔐 密码安全 (离线)${NC}${B}           │${NC}"
    echo "  13. 密码强度测试     14. 哈希值破解"
    echo "  15. 字典生成器       16. 密码分析"
    
    echo -e "${B}│  ${P}📡 网络工具 (手机专用)${NC}${B}       │${NC}"
    echo "  17. WiFi分析器      18. 蓝牙扫描"
    echo "  19. 数据包捕获      20. 网络诊断"
    echo "  21. 代理检测器      22. VPN状态检查"
    
    echo -e "${B}│  ${C}🛠️  实用工具${NC}${B}                 │${NC}"
    echo "  23. 编码/解码工具   24. 哈希计算器"
    echo "  25. 文件分析器      26. 元数据查看"
    echo "  27. QR码生成器      28. 文本处理器"
    
    echo -e "${B}│  ${W}⚙️  系统管理${NC}${B}                 │${NC}"
    echo "  29. 设备信息查看     30. 权限检查"
    echo "  31. 存储空间分析     32. 网络配置"
    echo "  33. 进程管理器       34. 日志查看器"
    
    echo -e "${B}├─────────────────────────────────────────┤${NC}"
    echo -e "${B}│  99. 退出      0. 显示帮助              │${NC}"
    echo -e "${B}└─────────────────────────────────────────┘${NC}"
}

# 工具1：移动网络扫描
mobile_network_scan() {
    echo -e "${C}[*] 移动网络扫描器${NC}"
    echo -e "${Y}选择扫描类型:${NC}"
    echo "1) 快速网络发现"
    echo "2) 端口扫描"
    echo "3) 服务识别"
    echo "4) 设备探测"
    
    read -p "选择: " scan_type
    
    case $scan_type in
        1)
            echo -e "${G}[+] 扫描本地网络...${NC}"
            nmap -sn 192.168.1.0/24
            ;;
        2)
            read -p "目标IP: " target
            echo -e "${G}[+] 扫描端口...${NC}"
            nmap -T4 -F $target
            ;;
        3)
            read -p "目标IP: " target
            echo -e "${G}[+] 识别服务...${NC}"
            nmap -sV $target
            ;;
        4)
            echo -e "${G}[+] 探测网络设备...${NC}"
            arp-scan -l
            ;;
    esac
}

# 工具7：移动Web漏洞扫描
mobile_web_scan() {
    echo -e "${C}[*] 移动Web漏洞扫描${NC}"
    read -p "输入URL: " url
    
    echo -e "${G}[+] 开始扫描...${NC}"
    
    # 1. 检查HTTP头安全
    echo -e "${Y}[*] 检查HTTP安全头...${NC}"
    curl -I $url | grep -i "security\|x-"
    
    # 2. 检查SSL/TLS
    echo -e "${Y}[*] 检查SSL/TLS配置...${NC}"
    echo | openssl s_client -connect $(echo $url | sed 's|^[^/]*://||' | sed 's|/.*||'):443 2>/dev/null | openssl x509 -noout -text | grep -A1 "Subject Alternative Name"
    
    # 3. 检查敏感文件
    echo -e "${Y}[*] 检查敏感文件...${NC}"
    sensitive_files=("robots.txt" "sitemap.xml" ".git/config" ".env" "phpinfo.php")
    for file in "${sensitive_files[@]}"; do
        curl -s -o /dev/null -w "%{http_code}" "$url/$file" | grep -q "200" && echo "[+] 发现: $url/$file"
    done
}

# 工具13：密码强度测试
password_strength_test() {
    echo -e "${C}[*] 密码强度测试${NC}"
    read -p "输入要测试的密码: " password
    
    echo -e "${G}[+] 分析密码强度...${NC}"
    
    # 长度检查
    length=${#password}
    if [ $length -ge 12 ]; then
        echo -e "${G}[✓] 长度优秀 ($length 字符)${NC}"
    elif [ $length -ge 8 ]; then
        echo -e "${Y}[!] 长度一般 ($length 字符)${NC}"
    else
        echo -e "${R}[✗] 长度不足 ($length 字符)${NC}"
    fi
    
    # 复杂度检查
    has_upper=$(echo $password | grep -q '[A-Z]' && echo 1 || echo 0)
    has_lower=$(echo $password | grep -q '[a-z]' && echo 1 || echo 0)
    has_digit=$(echo $password | grep -q '[0-9]' && echo 1 || echo 0)
    has_special=$(echo $password | grep -q '[^A-Za-z0-9]' && echo 1 || echo 0)
    
    complexity=$((has_upper + has_lower + has_digit + has_special))
    
    case $complexity in
        4) echo -e "${G}[✓] 复杂度: 优秀 (包含大小写、数字、特殊字符)${NC}" ;;
        3) echo -e "${Y}[!] 复杂度: 良好${NC}" ;;
        2) echo -e "${Y}[!] 复杂度: 一般${NC}" ;;
        1) echo -e "${R}[✗] 复杂度: 弱${NC}" ;;
    esac
    
    # 常见密码检查
    if grep -q "^$password$" "$WORDLISTS_DIR/passwords-small.txt" 2>/dev/null; then
        echo -e "${R}[✗] 警告: 密码在常见密码列表中${NC}"
    fi
    
    # 给出建议
    echo -e "${C}[*] 密码建议:${NC}"
    echo "1. 使用至少12个字符"
    echo "2. 混合大小写字母"
    echo "3. 包含数字和特殊字符"
    echo "4. 避免使用个人信息"
    echo "5. 不要重复使用密码"
}

# 工具17：WiFi分析器（手机专用）
wifi_analyzer() {
    echo -e "${C}[*] WiFi分析器${NC}"
    
    # 检查WiFi状态
    echo -e "${G}[+] 检查WiFi状态...${NC}"
    
    # 使用termux-wifi-info
    if command -v termux-wifi-connectioninfo &> /dev/null; then
        termux-wifi-connectioninfo
    else
        echo -e "${Y}[!] 安装Termux API获取更多功能${NC}"
        echo "运行: pkg install termux-api"
    fi
    
    # 扫描可用网络
    echo -e "${G}[+] 扫描附近WiFi...${NC}"
    if command -v termux-wifi-scaninfo &> /dev/null; then
        termux-wifi-scaninfo
    else
        echo "需要Termux API支持"
    fi
    
    # WiFi安全建议
    echo -e "${C}[*] WiFi安全建议:${NC}"
    echo "1. 使用WPA3加密（如果可用）"
    echo "2. 设置强密码（12位以上）"
    echo "3. 关闭WPS功能"
    echo "4. 隐藏SSID（可选）"
    echo "5. 定期更换密码"
    echo "6. 使用访客网络隔离设备"
}

# 工具23：编码/解码工具
encoding_tools() {
    echo -e "${C}[*] 编码/解码工具${NC}"
    
    while true; do
        echo -e "${Y}选择操作:${NC}"
        echo "1) Base64 编码"
        echo "2) Base64 解码"
        echo "3) URL 编码"
        echo "4) URL 解码"
        echo "5) Hex 编码"
        echo "6) Hex 解码"
        echo "7) 返回"
        
        read -p "选择: " choice
        
        case $choice in
            1)
                read -p "输入文本: " text
                echo -e "${G}Base64编码:${NC} $(echo -n "$text" | base64)"
                ;;
            2)
                read -p "输入Base64: " text
                echo -e "${G}Base64解码:${NC} $(echo -n "$text" | base64 -d 2>/dev/null || echo '解码失败')"
                ;;
            3)
                read -p "输入URL: " text
                echo -e "${G}URL编码:${NC} $(echo -n "$text" | python3 -c "import sys, urllib.parse; print(urllib.parse.quote(sys.stdin.read()))")"
                ;;
            4)
                read -p "输入编码URL: " text
                echo -e "${G}URL解码:${NC} $(echo -n "$text" | python3 -c "import sys, urllib.parse; print(urllib.parse.unquote(sys.stdin.read()))")"
                ;;
            7) break ;;
            *) echo "无效选择" ;;
        esac
        echo ""
    done
}

# 工具29：设备信息查看
device_info() {
    echo -e "${C}[*] 设备信息查看${NC}"
    
    echo -e "${G}[+] 系统信息:${NC}"
    uname -a
    echo ""
    
    echo -e "${G}[+] 存储信息:${NC}"
    df -h /data
    echo ""
    
    echo -e "${G}[+] 内存信息:${NC}"
    free -h
    echo ""
    
    echo -e "${G}[+] CPU信息:${NC}"
    cat /proc/cpuinfo | grep "model name" | head -1
    echo ""
    
    echo -e "${G}[+] 电池信息:${NC}"
    if command -v termux-battery-status &> /dev/null; then
        termux-battery-status
    else
        echo "安装Termux API获取电池信息: pkg install termux-api"
    fi
    echo ""
    
    echo -e "${G}[+] 网络信息:${NC}"
    ip addr show
    echo ""
}

# 帮助信息
show_mobile_help() {
    echo -e "${C}╔══════════════════════════════════════════════╗${NC}"
    echo -e "${C}║           DragonShield Mobile 帮助           ║${NC}"
    echo -e "${C}╠══════════════════════════════════════════════╣${NC}"
    echo -e "${C}║ 使用说明:                                    ║${NC}"
    echo -e "${C}║  启动: dragonshield 或 dsm                  ║${NC}"
    echo -e "${C}║  扫描: 选择对应数字进入工具                 ║${NC}"
    echo -e "${C}║  退出: 输入 99                             ║${NC}"
    echo -e "${C}║                                              ║${NC}"
    echo -e "${C}║ 特色功能:                                    ║${NC}"
    echo -e "${C}║  • 移动优化扫描                            ║${NC}"
    echo -e "${C}║  • 离线密码分析                            ║${NC}"
    echo -e "${C}║  • 设备安全检测                            ║${NC}"
    echo -e "${C}║  • 便携式工具集                            ║${NC}"
    echo -e "${C}║                                              ║${NC}"
    echo -e "${C}║ 注意事项:                                    ║${NC}"
    echo -e "${C}║  • 部分功能需要Termux API                  ║${NC}"
    echo -e "${C}║  • 尊重隐私，合法使用                      ║${NC}"
    echo -e "${C}║  • 定期更新工具                            ║${NC}"
    echo -e "${C}╚══════════════════════════════════════════════╝${NC}"
}

# 主函数
main() {
    # 加载配置
    if [ -f "$CONFIG_FILE" ]; then
        source $CONFIG_FILE
    fi
    
    # 显示欢迎界面
    show_mobile_header
    
    # 主循环
    while true; do
        show_mobile_menu
        
        read -p "📱 选择工具: " choice
        
        case $choice in
            # 信息收集
            1) mobile_network_scan ;;
            2) 
                read -p "目标IP: " target
                nmap -T4 -F $target 
                ;;
            3)
                read -p "域名: " domain
                dig ANY $domain
                ;;
            4)
                read -p "域名: " domain
                whois $domain
                ;;
            5)
                read -p "域名: " domain
                echo "探测子域名..."
                curl -s "https://crt.sh/?q=%.$domain&output=json" | jq -r '.[].name_value' 2>/dev/null | sort -u
                ;;
            6)
                read -p "URL: " url
                whatweb $url
                ;;
            
            # 漏洞检测
            7) mobile_web_scan ;;
            8)
                read -p "域名: " domain
                sslscan $domain:443
                ;;
            9)
                read -p "URL: " url
                echo "使用小字典扫描..."
                dirb $url "$WORDLISTS_DIR/directories.txt" -S
                ;;
            
            # 密码安全
            13) password_strength_test ;;
            14)
                read -p "哈希值: " hash
                echo "尝试破解..."
                hashcat --benchmark
                ;;
            15)
                echo "生成字典..."
                crunch 6 8 abcdefghijklmnopqrstuvwxyz -o $WORDLISTS_DIR/custom.txt
                ;;
            
            # 网络工具
            17) wifi_analyzer ;;
            20)
                echo "网络诊断..."
                ping -c 4 8.8.8.8
                traceroute google.com
                ;;
            
            # 实用工具
            23) encoding_tools ;;
            24)
                read -p "输入文本: " text
                echo "MD5: $(echo -n "$text" | md5sum)"
                echo "SHA1: $(echo -n "$text" | sha1sum)"
                echo "SHA256: $(echo -n "$text" | sha256sum)"
                ;;
            
            # 系统管理
            29) device_info ;;
            33)
                echo "运行进程:"
                ps aux
                ;;
            
            # 系统命令
            0) show_mobile_help ;;
            99)
                echo -e "${P}🐉 感谢使用 DragonShield Mobile！${NC}"
                exit 0
                ;;
            *)
                echo -e "${R}[!] 无效选择${NC}"
                ;;
        esac
        
        echo ""
        read -p "按Enter继续..."
        show_mobile_header
    done
}

# 启动程序
main "$@"