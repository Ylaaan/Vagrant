# set dns
sudo resolvectl dns eth0 8.8.8.8

# set host file
sudo tee /etc/hosts<<EOF
192.168.1.200 master
192.168.1.201 node-01
192.168.1.202 node-02
192.168.1.203 node-03
192.168.1.210 nfs
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
/mnt/nfs4/shared 192.168.1.0/24(rw,sync,no_subtree_check)
EOF
sudo exportfs -a
sudo systemctl restart nfs-kernel-server