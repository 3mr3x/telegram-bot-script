#!/bin/bash

API_TOKEN="XXXXXXX"
CHAT_ID="XXXXXXX"

# Sunucunun Gerçek IP Adresi
public_ip=$(curl -s ifconfig.me)

while true
do
    # RAM Kullanımı
    ram_usage=$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')

    # CPU Kullanımı
    cpu_usage=$(top -bn1 | grep load | awk '{printf "%.2f%%", $(NF-2)}')

    # Aktif Servislerin Listesi
    active_services=$(systemctl list-units --type=service --state=running --no-pager | awk 'NR>1 {print $1}')

    # Mesajları Oluştur
    mssg="Merhaba, ben $public_ip IP'ye sahip sunucuyum."
    curl -s -o /dev/null -X POST "https://api.telegram.org/bot$API_TOKEN/sendMessage" -d chat_id="$CHAT_ID" -d text="$mssg"

    mssg2="$public_ip sunucusu. RAM kullanım oranı $ram_usage DE-Contabo"
    curl -s -o /dev/null -X POST "https://api.telegram.org/bot$API_TOKEN/sendMessage" -d chat_id="$CHAT_ID" -d text="$mssg2"

    mssg3="$public_ip sunucusu. CPU kullanım oranı $cpu_usage DE-Contabo"
    curl -s -o /dev/null -X POST "https://api.telegram.org/bot$API_TOKEN/sendMessage" -d chat_id="$CHAT_ID" -d text="$mssg3"

    # Aktif Servisler
    if [ -n "$active_services" ]; then
        service_mssg="Merhaba, ben $public_ip sunucusu. Aktif servisler:\n$active_services\nSorun yok."
    else
        service_mssg="Merhaba, ben $public_ip sunucusu. Aktif servis bulunamadı."
    fi
    curl -s -o /dev/null -X POST "https://api.telegram.org/bot$API_TOKEN/sendMessage" -d chat_id="$CHAT_ID" -d text="$service_mssg"

    # Kullanıcılar
    who_output=$(who)
    who_mssg="Merhaba, ben $public_ip sunucusu. Aktif kullanıcılar:\n$who_output"
    curl -s -o /dev/null -X POST "https://api.telegram.org/bot$API_TOKEN/sendMessage" -d chat_id="$CHAT_ID" -d text="$who_mssg"

    sleep 3600
done
