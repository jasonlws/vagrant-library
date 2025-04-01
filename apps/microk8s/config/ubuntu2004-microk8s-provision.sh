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

echo "[TASK 5] apt-get update"
sudo apt-get update -y

echo "[TASK 6] Install MicroK8s"
sudo snap install microk8s --classic

echo "[TASK 7] Add your user to the MicroK8s admin group"
sudo usermod -a -G microk8s $USER
sudo chown -f -R $USER ~/.kube
su - $USER

echo "[TASK 8] Turn on the services you want"
microk8s enable dashboard dns ingress

echo "[TASK 9] alias microk8s.kubectl to kubectl & k"
sudo snap alias microk8s.kubectl kubectl
sudo snap alias microk8s.kubectl k

echo "[TASK 10] kubectl autocomplete"
source <(kubectl completion bash)
echo "source <(kubectl completion bash)" >> ~/.bashrc

echo "[TASK 11] shorthand alias for kubectl that also works with completion"
complete -o default -F __start_kubectl k

echo "[TASK 12] Patch Dashboard from ClusterIP to NodePort"
kubectl -n kube-system patch svc kubernetes-dashboard --type='json' -p '[{"op":"replace","path":"/spec/type","value":"NodePort"}]'
kubectl -n kube-system patch svc kubernetes-dashboard --type='json' -p '[{"op":"replace","path":"/spec/ports/0/nodePort","value":31625}]'

echo "[TASK 13] Display Dashboard Token"
token=$(kubectl -n kube-system get secret | grep default-token | cut -d " " -f1)
kubectl -n kube-system describe secret $token | grep token: