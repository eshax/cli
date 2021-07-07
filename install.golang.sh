#!/bin/bash

apt udpate
apt list --upgradable
apt upgrade -y

apt install cmake -y

ver=1.16.5

cd ~
wget https://golang.google.cn/dl/go$ver.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go$ver.linux-amd64.tar.gz
ln -s /usr/local/go/bin/go /usr/bin/go
go env -w GO111MODULE=on
go env -w GOPROXY=https://goproxy.cn,direct