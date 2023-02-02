#!/bin/bash

# App instaler script for Ubuntu x86 (64bit)

############################
# Typical applications install
############################
sudo apt install openssh-server vim git -y

############################
# Asbrú install
############################
# web: https://github.com/asbru-cm/asbru-cm/wiki
sudo apt-add-repository multiverse -y
sudo apt install -y curl
curl -1sLf 'https://dl.cloudsmith.io/public/asbru-cm/release/cfg/setup/bash.deb.sh' | sudo -E bash
sudo apt install asbru-cm -y


############################
# Visual Studio Code install
############################
# web: https://code.visualstudio.com/docs/setup/linux

## 1. Repository and key manually install
echo "[INFO] Repository and key manually install"
sudo apt install wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -D -o root -g root -m 644 packages.microsoft.gpg /etc/apt/keyrings/packages.microsoft.gpg
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/keyrings/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
rm -f packages.microsoft.gpg
## 2. Update the package cache and install the package
echo "[INFO] Update the package cache and install the package"
sudo apt install apt-transport-https
sudo apt update & sudo apt install code -y# or code-insiders

############################
# Terraform install
############################
# web: https://developer.hashicorp.com/terraform/downloads
wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
sudo apt update && sudo apt install terraform

############################
# AWS CLI install
############################
# web: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
sudo apt update & sudo apt install curl -y
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install -i /usr/local/aws-cli -b /usr/local/bin
echo [INFO] $(aws --version)
rm awscliv2.zip


############################
# Tailscale install
############################
# web: https://tailscale.com/kb/1031/install-linux/
curl -fsSL https://tailscale.com/install.sh | sh
sudo tailscale up --authkey tskey-auth-kGhcqR4CNTRL-r1aNYi5QpQ5zwm6uEz7aR5NfMZBB6GhL
echo [INFO] Tailscale status
tailscale status

############################
# Ansible install
############################
# web: https://docs.ansible.com/ansible/latest/installation_guide/installation_distros.html#installing-ansible-on-ubuntu
sudo apt update
sudo apt install software-properties-common -y
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install ansible -y
echo [INFO] $(ansible --version)

############################
# Docker install
############################
# web: https://docs.docker.com/engine/install/ubuntu/

## OS requirements
# To install Docker Engine, you need the 64-bit version of one of these Ubuntu versions:
#   Ubuntu Kinetic 22.10
#   Ubuntu Jammy 22.04 (LTS)
#   Ubuntu Focal 20.04 (LTS)
#   Ubuntu Bionic 18.04 (LTS)
# Docker Engine is compatible with x86_64 (or amd64), armhf, arm64, and s390x architectures.

## 1. Update the apt package index and install packages to allow apt to use a repository over HTTPS
echo "[INFO] Update the apt package index and install packages to allow apt to use a repository over HTTPS"
sudo apt update
sudo apt install ca-certificates curl gnupg lsb-release -y
## 2. Add Docker’s official GPG key
echo "[INFO] Add Docker’s official GPG key"
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
## 3. Use the following command to set up the repository
echo "[INFO] Set up the repository"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
## 4. Update the apt package index
echo "[INFO] Update the apt package index"
sudo apt update
## 5. Install Docker Engine, containerd, and Docker Compose
echo "[INFO] Install Docker Engine, containerd, and Docker Compose"
sudo apt install docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-compose -y
## 6. Add your user to the docker group
USER = nico
echo "[INFO] Add your user to the docker group"
sudo usermod -aG docker $USER
## 7. Check version
echo [INFO] $(docker --version)