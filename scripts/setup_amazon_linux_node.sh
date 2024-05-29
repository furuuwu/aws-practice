#!/bin/bash

# remember that Amazon Linux uses yum as its package manager, not apt

# sheep time
sleep 30

# update
sudo yum update -y

# install node
sudo yum install -y gcc-c++ make
curl -sL https://rpm.nodesource.com/setup_14.x | sudo -E bash -
sudo yum install - y nodejs

# copy app
sudo yum install unzip -y
cd ~/ && unzip app.zip
cd ~/app && npm i --only=prod

# move service to the right place (a directory owned by the root user)
sudo mv /tmp/app.service /etc/systemd/system/app.service
sudo systemctl enable app.service
sudo systemctl start app.service