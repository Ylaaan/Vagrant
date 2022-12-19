#!/bin/bash -e

get_join_command ()
{
sudo /vagrant/join_command.sh
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

get_join_command
configure_nfs