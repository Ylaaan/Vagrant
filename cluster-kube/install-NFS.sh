#!/bin/bash

install_required_packages ()
{
sudo apt update
sudo apt -y install nfs-kernel-server
sudo apt -y install vim git curl wget
sudo apt update
sudo cat /proc/fs/nfsd/versions
}

configure_nfs ()
{
sudo mkdir -p /mnt/nfs4/shared
sudo chown nobody:nogroup /mnt/nfs4/shared
sudo chmod 777 /mnt/nfs4/shared

sudo tee /etc/exports<<EOF
/mnt/nfs4/shared 172.16.8.0/24(rw,sync,no_subtree_check)
EOF
sudo exportfs -a
sudo systemctl restart nfs-kernel-server
}

configure_hosts_file ()
{
sudo tee /etc/hosts<<EOF
172.16.8.10 master
172.16.8.11 node-01
172.16.8.12 node-02
172.16.8.13 node-03
172.16.8.20 NFS
EOF
}

disable_swap () 
{
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab
sudo swapoff -a
}


install_required_packages
configure_nfs
configure_hosts_file
disable_swap