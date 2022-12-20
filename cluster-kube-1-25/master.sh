#!/bin/bash

sudo kubeadm init --pod-network-cidr 192.168.0.0/16 --apiserver-advertise-address 192.168.1.200 --ignore-preflight-errors=NumCPU
sudo KUBECONFIG=/etc/kubernetes/admin.conf kubectl apply -f https://github.com/weaveworks/weave/releases/download/v2.8.1/weave-daemonset-k8s.yaml
mkdir -p /home/vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
sudo chown vagrant:vagrant /home/vagrant/.kube/config
sudo KUBECONFIG=/etc/kubernetes/admin.conf kubectl apply -f /vagrant/manifest/nfs
sudo kubeadm token create --print-join-command | tee /vagrant/join_command.sh
kubectl completion bash | sudo tee /etc/bash_completion.d/kubectl > /dev/null
