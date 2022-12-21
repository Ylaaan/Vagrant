#!/bin/bash
# disable swap
sudo swapoff -a
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

# set dns
sudo resolvectl dns eth0 8.8.8.8

# restart containerd
sudo systemctl start containerd

# set host file
sudo tee /etc/hosts<<EOF
172.16.8.10 master
172.16.8.11 node-01
172.16.8.12 node-02
172.16.8.13 node-03
172.16.8.20 nfs
EOF

sudo apt-get update
sudo apt-get install -y nfs-common