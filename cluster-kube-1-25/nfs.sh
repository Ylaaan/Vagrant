# set dns
sudo resolvectl dns eth0 8.8.8.8

# set host file
sudo tee /etc/hosts<<EOF
172.16.8.10 master
172.16.8.11 node-01
172.16.8.12 node-02
172.16.8.13 node-03
172.16.8.20 nfs
EOF

# Install required package
sudo apt update
sudo apt -y install nfs-kernel-server
sudo apt -y install vim git curl wget
sudo apt update
sudo cat /proc/fs/nfsd/versions

# Configure NFS
sudo mkdir -p /mnt/nfs4/shared
sudo chown nobody:nogroup /mnt/nfs4/shared
sudo chmod 777 /mnt/nfs4/shared

sudo tee /etc/exports<<EOF
/mnt/nfs4/shared 172.16.1.0/24(rw,sync,no_subtree_check)
EOF
sudo exportfs -a
sudo systemctl restart nfs-kernel-server