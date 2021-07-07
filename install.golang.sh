#!/bin/bash

ver=1.16.5

cd ~
wget https://golang.google.cn/dl/go$ver.linux-amd64.tar.gz
rm -rf /usr/local/go && tar -C /usr/local -xzf go$ver.linux-amd64.tar.gz
ln -s /usr/local/go/bin/go /usr/bin/go
