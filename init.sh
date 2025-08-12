#!/bin/bash

CODENAME=$(lsb_release -cs 2>/dev/null || grep -oP 'VERSION_CODENAME=\K\w+' /etc/os-release)
COMPONENTS="main contrib non-free non-free-firmware"

cat > /etc/apt/sources.list << EOF
deb https://http.krfoss.org/debian $CODENAME $COMPONENTS
deb-src https://http.krfoss.org/debian $CODENAME $COMPONENTS

deb https://http.krfoss.org/debian $CODENAME-updates $COMPONENTS
deb-src https://http.krfoss.org/debian $CODENAME-updates $COMPONENTS

# security updates
deb https://http.krfoss.org/debian-security $CODENAME-security $COMPONENTS
deb-src https://http.krfoss.org/debian-security $CODENAME-security $COMPONENTS

# $CODENAME-backports, previously on backports.debian.org
deb https://http.krfoss.org/debian $CODENAME-backports $COMPONENTS
deb-src https://http.krfoss.org/debian $CODENAME-backports $COMPONENTS
EOF

apt update -y
apt upgrade -y
