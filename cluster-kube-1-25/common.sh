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
192.168.1.200 master
192.168.1.201 node-01
192.168.1.202 node-02
192.168.1.203 node-03
192.168.1.210 nfs
EOF

sudo apt-get update
sudo apt-get install -y nfs-common