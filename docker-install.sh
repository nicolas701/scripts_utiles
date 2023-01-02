#!/bin/bash

## Install Docker Engine on Ubuntu/Debian 
# https://docs.docker.com/engine/install/ubuntu/

## 1. Update the apt package index and install packages to allow apt to use a repository over HTTPS
echo "[INFO] Update the apt package index and install packages to allow apt to use a repository over HTTPS"
sudo apt update
sudo apt install ca-certificates curl gnupg lsb-release

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
sudo update

## 5. Install Docker Engine, containerd, and Docker Compose
echo "[INFO] Install Docker Engine, containerd, and Docker Compose"
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-compose

## 6. Add your user to the docker group
echo "[INFO] Add your user to the docker group"
sudo usermod -aG docker $USER
