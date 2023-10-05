#!/bin/bash

## Install Docker Engine on Ubuntu/Debian 
# https://docs.docker.com/engine/install/ubuntu/

## OS requirements
# To install Docker Engine, you need the 64-bit version of one of these Ubuntu versions:
#   Ubuntu Kinetic 22.10
#   Ubuntu Jammy 22.04 (LTS)
#   Ubuntu Focal 20.04 (LTS)
#   Ubuntu Bionic 18.04 (LTS)
# Docker Engine is compatible with x86_64 (or amd64), armhf, arm64, and s390x architectures.

## 1. Update the apt package index and install packages to allow apt to use a repository over HTTPS
echo "[INFO] Update the apt package index and install packages to allow apt to use a repository over HTTPS"
sudo apt update -y
sudo apt install ca-certificates curl gnupg lsb-release -y

## 2. Add Docker’s official GPG key
echo "[INFO] Add Docker’s official GPG key"
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --yes --dearmor -o /etc/apt/keyrings/docker.gpg

## 3. Use the following command to set up the repository
echo "[INFO] Set up the repository"
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

## 4. Update the apt package index
echo "[INFO] Update the apt package index"
sudo apt update -y

## 5. Install Docker Engine, containerd, and Docker Compose
echo "[INFO] Install Docker Engine, containerd, and Docker Compose"
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-compose -y

## 6. Add your user to the docker group
echo "[INFO] Add your user to the docker group"
sudo usermod -aG docker $USER
