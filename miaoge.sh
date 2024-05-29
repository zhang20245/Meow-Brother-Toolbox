#!/bin/bash
echo "喵哥一键修改+密码登录" echo 
"如有任何问题，请联系:@jyibhuixshi 
获取支持"
# 获取用户选择
while true; do read -p 
    "请选择密码生成方式 (1: 随机密码, 
    2: 自定义密码): " choice case 
    $choice in
        1) new_password=$(openssl rand 
            -base64 12 | cut -c1-16) # 
            16位随机密码 echo "新密码 
            (已自动保存): 
            $new_password" break
            ;;
        2) while true; do read -s -p 
                "请输入新密码 
                (至少8位): " 
                new_password echo if 
                [[ ${#new_password} 
                -ge 8 ]]; then
                    read -s -p 
                    "请再次输入新密码: 
                    " confirm_password 
                    echo if [ 
                    "$new_password" = 
                    "$confirm_password" 
                    ]; then
                        break else 
                        echo 
                        "密码不匹配，请重新输入"
                    fi else echo 
                    "密码长度不足8位，请重新输入"
                fi done break
            ;;
        *) echo "无效选择，请重新输入"
            ;;
    esac done
# 修改root密码
echo "root:$new_password" | chpasswd
# 修改SSH配置文件 (如果不存在则创建)
if ! grep -q "^PermitRootLogin" 
/etc/ssh/sshd_config; then
    echo "PermitRootLogin yes" >> 
    /etc/ssh/sshd_config
else sed -i 's/#PermitRootLogin 
    prohibit-password/PermitRootLogin 
    yes/' /etc/ssh/sshd_config
fi if ! grep -q 
"^PasswordAuthentication" 
/etc/ssh/sshd_config; then
    echo "PasswordAuthentication yes" 
    >> /etc/ssh/sshd_config
else sed -i 's/PasswordAuthentication 
    no/PasswordAuthentication yes/' 
    /etc/ssh/sshd_config
fi
# 重启SSH服务
if service ssh status | grep -q 
"running"; then
    service ssh restart else service 
    ssh start # 
    如果SSH服务未运行，则启动
fi echo 
"密码已成功修改，SSH配置已更新。"

