#!/bin/bash

# update apt
echo "Updating..."
sudo ap-get update &&

# install dependencies
echo "Installing shit idk..."
# no idea what most these do, i just copy-pasted from somewhere
sudo apt-get install -y \

curl \

# for docker - let apt use packages over HTTPS
apt-transport-https \
software-properties-common \

# idk
ca-certificates \
gnupg-agent &&

# install docker
echo "Installing docker" &&
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &&
sudo add-apt-repository "deb [arch-amd64] https://dowload.docker.com/linux/ubuntu $(lsb_release -cs) stable" &&
sudo apt-get update -y &&
sudo apt-get install docker-ce docker-cel-cli container.io -y &&
# sudo usermod -aG docker ubuntu # add ubuntu to the docker group
sudo usermod -aG docker ec2-user