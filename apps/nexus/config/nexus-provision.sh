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

echo "[TASK 6] apt upgrade"
sudo apt upgrade -y

# echo "[TASK 7] Install Java 8 Runtime Environment"
sudo apt install openjdk-8-jre-headless -y

# echo "[TASK 8] Add nexus user to nexus service"
sudo adduser --disabled-login --no-create-home --gecos "" nexus

# echo "[TASK 9] Download and unzip nexus image - 3.70.0"
sudo wget https://download.sonatype.com/nexus/3/nexus-3.70.1-02-java8-unix.tar.gz -P /opt
sudo tar -zxvf /opt/nexus-3.70.1-02-java8-unix.tar.gz -C /opt

# echo "[TASK 10] Change the folder to nexus"
sudo mv /opt/nexus-3.70.1-02 /opt/nexus

# echo "[TASK 11] Make it readable"
sudo chown -R nexus:nexus /opt/nexus
sudo chown -R nexus:nexus /opt/sonatype-work

# echo "[TASK 12] Chnage nexus user to run nexus service"
sudo cp ~/nexus/nexus.rc /opt/nexus/bin/nexus.rc

# echo "[TASK 13] Configure nexus"
sudo cp ~/nexus/nexus.service /etc/systemd/system/nexus.service
sudo cp ~/nexus/nexus.vmoptions /opt/nexus/bin/nexus.vmoptions
sudo cp ~/nexus/admin.password /opt/sonatype-work/nexus3/admin.password
# sudo cp ~/jasonlws-nexus/nexus.properties /opt/sonatype-work/nexus3/etc/nexus.properties

# echo "[TASK 14] Start the nexus service"
sudo systemctl daemon-reload
sudo systemctl start nexus
sudo systemctl enable nexus
