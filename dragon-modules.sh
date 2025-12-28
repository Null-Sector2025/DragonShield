#!/bin/bash

# DragonShield 外部工具安装器
# 自动安装50+安全工具

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

# 进度条
progress() {
    local width=50
    local percent=$(( $1 * 100 / $2 ))
    local done=$(( $width * $1 / $2 ))
    local left=$(( $width - $done ))
    
    printf "\r${BLUE}[${NC}"
    printf "%0.s█" $(seq 1 $done)
    printf "%0.s░" $(seq 1 $left)
    printf "${BLUE}] ${percent}%%${NC}"
}

# 检查并安装工具
install_tool() {
    local tool_name=$1
    local install_cmd=$2
    
    echo -e "${YELLOW}[*] 检查 $tool_name...${NC}"
    
    if command -v $tool_name &> /dev/null; then
        echo -e "${GREEN}[+] $tool_name 已安装${NC}"
        return 0
    else
        echo -e "${YELLOW}[!] 安装 $tool_name...${NC}"
        eval $install_cmd
        
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}[+] $tool_name 安装成功${NC}"
            return 0
        else
            echo -e "${RED}[!] $tool_name 安装失败${NC}"
            return 1
        fi
    fi
}

# 显示龙形标题
show_title() {
    echo -e "${PURPLE}"
    cat << "EOF"

░█▀▀░█░█░█▀█░█▀▄░█▀▀░█▀▀░█▀█░█▀▄░█▀▀
░▀▀█░█░█░█▀█░█▀▄░█▀▀░▀▀█░█▀█░█▀▄░▀▀█
░▀▀▀░▀▀▀░▀░▀░▀░▀░▀▀▀░▀▀▀░▀░▀░▀░▀░▀▀▀

░█▀▀░█▀█░█▀▄░█▀▀░▀█▀░█▀▀░█▀▄░█▀█░█▀▀░█▀▀
░█░░░█░█░█░█░█▀▀░░█░░█▀▀░█▀▄░█▀█░█░█░█▀▀
░▀▀▀░▀▀▀░▀▀░░▀▀▀░░▀░░▀▀▀░▀░▀░▀░▀░▀▀▀░▀▀▀
EOF
    echo -e "${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo -e "${YELLOW}       DragonShield 工具安装器${NC}"
    echo -e "${CYAN}========================================${NC}"
}

# 主安装函数
main() {
    show_title
    
    echo -e "${RED}[!] 警告：这将安装大量安全工具${NC}"
    echo -e "${RED}[!] 需要管理员权限和良好的网络连接${NC}"
    echo -e ""
    read -p "按 Enter 继续，或 Ctrl+C 取消..."
    
    total_tools=50
    current_tool=0
    
    # 1. 侦察和信息收集工具
    echo -e "${YELLOW}[*] 安装侦察工具...${NC}"
    
    install_tool "nmap" "sudo apt-get install -y nmap"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "masscan" "sudo apt-get install -y masscan"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "amass" "sudo apt-get install -y amass"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "sublist3r" "git clone https://github.com/aboul3la/Sublist3r.git $HOME/.nullsector/tools/sublist3r && cd $HOME/.nullsector/tools/sublist3r && sudo pip3 install -r requirements.txt"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "theHarvester" "sudo apt-get install -y theharvester"
    ((current_tool++)); progress $current_tool $total_tools
    
    # 2. Web应用扫描器
    echo -e "\n${YELLOW}[*] 安装Web扫描工具...${NC}"
    
    install_tool "nikto" "sudo apt-get install -y nikto"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "dirb" "sudo apt-get install -y dirb"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "gobuster" "sudo apt-get install -y gobuster"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "ffuf" "sudo apt-get install -y ffuf"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "whatweb" "sudo apt-get install -y whatweb"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "wapiti" "sudo apt-get install -y wapiti"
    ((current_tool++)); progress $current_tool $total_tools
    
    # 3. 漏洞扫描器
    echo -e "\n${YELLOW}[*] 安装漏洞扫描器...${NC}"
    
    install_tool "sqlmap" "sudo apt-get install -y sqlmap"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "wpscan" "sudo apt-get install -y wpscan"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "joomscan" "sudo apt-get install -y joomscan"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "droopescan" "sudo pip3 install droopescan"
    ((current_tool++)); progress $current_tool $total_tools
    
    # 4. 密码攻击工具
    echo -e "\n${YELLOW}[*] 安装密码攻击工具...${NC}"
    
    install_tool "hydra" "sudo apt-get install -y hydra"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "john" "sudo apt-get install -y john"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "hashcat" "sudo apt-get install -y hashcat"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "crunch" "sudo apt-get install -y crunch"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "cewl" "sudo apt-get install -y cewl"
    ((current_tool++)); progress $current_tool $total_tools
    
    # 5. 无线安全工具
    echo -e "\n${YELLOW}[*] 安装无线安全工具...${NC}"
    
    install_tool "aircrack-ng" "sudo apt-get install -y aircrack-ng"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "reaver" "sudo apt-get install -y reaver"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "wifite" "sudo apt-get install -y wifite"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "bully" "sudo apt-get install -y bully"
    ((current_tool++)); progress $current_tool $total_tools
    
    # 6. 网络工具
    echo -e "\n${YELLOW}[*] 安装网络工具...${NC}"
    
    install_tool "tcpdump" "sudo apt-get install -y tcpdump"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "wireshark" "sudo apt-get install -y wireshark"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "ettercap" "sudo apt-get install -y ettercap-graphical"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "driftnet" "sudo apt-get install -y driftnet"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "ncat" "sudo apt-get install -y ncat"
    ((current_tool++)); progress $current_tool $total_tools
    
    # 7. 后渗透工具
    echo -e "\n${YELLOW}[*] 安装后渗透工具...${NC}"
    
    install_tool "metasploit" "curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && chmod 755 msfinstall && ./msfinstall"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "powersploit" "git clone https://github.com/PowerShellMafia/PowerSploit.git $HOME/.nullsector/tools/powersploit"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "empire" "git clone https://github.com/EmpireProject/Empire.git $HOME/.nullsector/tools/empire && cd $HOME/.nullsector/tools/empire && sudo ./setup/install.sh"
    ((current_tool++)); progress $current_tool $total_tools
    
    # 8. 取证工具
    echo -e "\n${YELLOW}[*] 安装取证工具...${NC}"
    
    install_tool "binwalk" "sudo apt-get install -y binwalk"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "foremost" "sudo apt-get install -y foremost"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "volatility" "sudo apt-get install -y volatility"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "exiftool" "sudo apt-get install -y exiftool"
    ((current_tool++)); progress $current_tool $total_tools
    
    # 9. 其他有用工具
    echo -e "\n${YELLOW}[*] 安装其他工具...${NC}"
    
    install_tool "netdiscover" "sudo apt-get install -y netdiscover"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "dnsenum" "sudo apt-get install -y dnsenum"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "dnsrecon" "sudo apt-get install -y dnsrecon"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "snmpcheck" "sudo apt-get install -y snmpcheck"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "sslscan" "sudo apt-get install -y sslscan"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "testssl" "git clone https://github.com/drwetter/testssl.sh.git $HOME/.nullsector/tools/testssl"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "wapiti" "sudo apt-get install -y wapiti"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "xsser" "sudo apt-get install -y xsser"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "commix" "git clone https://github.com/commixproject/commix.git $HOME/.nullsector/tools/commix"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "xsstrike" "git clone https://github.com/s0md3v/XSStrike.git $HOME/.nullsector/tools/xsstrike"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "subjack" "go get github.com/haccer/subjack"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "aquatone" "wget https://github.com/michenriksen/aquatone/releases/download/v1.7.0/aquatone_linux_amd64_1.7.0.zip -O /tmp/aquatone.zip && unzip /tmp/aquatone.zip -d $HOME/.nullsector/tools/aquatone"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "waybackurls" "go get github.com/tomnomnom/waybackurls"
    ((current_tool++)); progress $current_tool $total_tools
    
    install_tool "gau" "go get github.com/lc/gau"
    ((current_tool++)); progress $current_tool $total_tools
    
    echo -e "\n${GREEN}[+] 所有工具安装完成！${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo -e "${YELLOW}已安装工具列表：${NC}"
    echo "1. Nmap - 端口扫描"
    echo "2. Masscan - 快速端口扫描"
    echo "3. Amass - 子域名枚举"
    echo "4. Sublist3r - 子域名发现"
    echo "5. TheHarvester - 信息收集"
    echo "6. Nikto - Web漏洞扫描"
    echo "7. Dirb - 目录爆破"
    echo "8. Gobuster - 目录/文件爆破"
    echo "9. FFuF - Web模糊测试"
    echo "10. WhatWeb - Web技术识别"
    echo "11. Wapiti - Web漏洞扫描"
    echo "12. SQLMap - SQL注入"
    echo "13. WPScan - WordPress扫描"
    echo "14. JoomScan - Joomla扫描"
    echo "15. Droopescan - CMS扫描"
    echo "16. Hydra - 在线密码破解"
    echo "17. John the Ripper - 密码破解"
    echo "18. Hashcat - 哈希破解"
    echo "19. Crunch - 密码生成"
    echo "20. CeWL - 自定义字典生成"
    echo "21. Aircrack-ng - WiFi破解"
    echo "22. Reaver - WPS攻击"
    echo "23. Wifite - 自动化WiFi攻击"
    echo "24. Bully - WPS破解"
    echo "25. Tcpdump - 网络抓包"
    echo "26. Wireshark - 协议分析"
    echo "27. Ettercap - MITM攻击"
    echo "28. Driftnet - 图片捕获"
    echo "29. Ncat - 网络瑞士军刀"
    echo "30. Metasploit - 渗透框架"
    echo "31. PowerSploit - PowerShell工具"
    echo "32. Empire - 后渗透框架"
    echo "33. Binwalk - 固件分析"
    echo "34. Foremost - 文件恢复"
    echo "35. Volatility - 内存取证"
    echo "36. Exiftool - 元数据分析"
    echo "37. Netdiscover - 网络发现"
    echo "38. DNSenum - DNS枚举"
    echo "39. DNSrecon - DNS侦察"
    echo "40. SNMPcheck - SNMP枚举"
    echo "41. SSLscan - SSL/TLS扫描"
    echo "42. TestSSL - SSL测试"
    echo "43. XSSer - XSS攻击"
    echo "44. Commix - 命令注入"
    echo "45. XSStrike - XSS检测"
    echo "46. Subjack - 子域名接管"
    echo "47. Aquatone - 截图工具"
    echo "48. Waybackurls - 历史URL"
    echo "49. Gau - 获取已知URL"
    echo "50. 多种自定义工具"
    
    echo -e "${CYAN}========================================${NC}"
    echo -e "${GREEN}使用 'dragonshield' 命令启动 DragonShield！${NC}"
}

# 检查是否以root运行
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}[!] 请使用sudo运行此脚本${NC}"
    echo -e "${YELLOW}用法: sudo ./tools-installer.sh${NC}"
    exit 1
fi

main