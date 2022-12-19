#!/bin/bash -e

master_node=172.16.8.10
pod_network_cidr=192.168.0.0/16

initialize_master_node ()
{
sudo systemctl enable kubelet
sudo kubeadm config images pull
sudo kubeadm init --apiserver-advertise-address=$master_node --pod-network-cidr=$pod_network_cidr --ignore-preflight-errors=NumCPU
}

create_join_command ()
{
kubeadm token create --print-join-command | tee /vagrant/join_command.sh
chmod +x /vagrant/join_command.sh
}

configure_kubectl () 
{
mkdir -p $HOME/.kube
sudo cp -f /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

##For vagrant user
mkdir -p /home/vagrant/.kube
sudo cp -f /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown 900:900 /home/vagrant/.kube/config
}

install_network_cni ()
{
kubectl apply -f /vagrant/kube-flannel.yml
}

configure_nfs ()
{
sudo apt update
sudo apt -y install nfs-common
sudo mkdir -p /mnt/shared
sudo mount 172.16.8.20:/mnt/nfs4/shared /mnt/shared
sudo tee /etc/hosts<<EOF
172.16.8.20:/mnt/nfs4/shared    /mnt/shared nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800    0   0
EOF
}

configure_helm ()
{
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm

sudo helm repo add bitnami https://charts.bitnami.com/bitnami
}

initialize_master_node
configure_kubectl
install_network_cni
create_join_command
configure_nfs
configure_helm