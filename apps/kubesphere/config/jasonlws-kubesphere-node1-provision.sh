#!/bin/bash

## !IMPORTANT ##
## This script is tested only in the generic/ubuntu2004 Vagrant box
## If you use a different version of Ubuntu or a different Ubuntu Vagrant box test this again

echo "[TASK 0] Setting TimeZone" 
timedatectl set-timezone America/Toronto

echo "[TASK 1] Disable and turn off SWAP"
sed -i '/swap/d' /etc/fstab
swapoff -a

echo "[TASK 2] Stop and Disable firewall"
systemctl disable --now ufw >/dev/null 2>&1

echo "[TASK 3] Enable ssh password authentication"
sed -i 's/^PasswordAuthentication .*/PasswordAuthentication yes/' /etc/ssh/sshd_config
echo 'PermitRootLogin yes' >> /etc/ssh/sshd_config
systemctl reload sshd

echo "[TASK 4] Set root password"
echo -e "P@ssw0rd\nP@ssw0rd" | passwd root >/dev/null 2>&1
echo "export TERM=xterm" >> /etc/bash.bashrc

echo "[TASK 5] apt update"
sudo apt update -y

echo "[TASK 6] apt install required libraries in Ubuntu"
sudo apt install nfs-common bat open-iscsi git socat conntrack ebtables ipset ipvsadm -y

echo "[TASK 7] set the inotify max_user_watches for all nodes"
sudo sysctl -w fs.inotify.max_user_watches=524288
