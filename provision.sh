#!/bin/bash

# Ubuntu 16.04 LTS

# basics
apt update && apt -y upgrade
rm /etc/update-motd.d/10-help-text
rm /etc/update-motd.d/91-release-upgrade
cp /home/vagrant/vm_scripts/10-ip /etc/update-motd.d/10-ip
chmod +x /etc/update-motd.d/10-ip
cp /home/vagrant/vm_scripts/15-diskspace /etc/update-motd.d/15-diskspace
chmod +x /etc/update-motd.d/15-diskspace

# without swap your vm might be killed in a moment
fallocate -l 512M /swapfile && chmod 0600 /swapfile && mkswap /swapfile && swapon /swapfile && echo '/swapfile none swap sw 0 0'

# give the vagrant user a password: vagrant :)
echo "vagrant:vagrant" | chpasswd
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

# prune docker script
cp /home/vagrant/vm_scripts/dockerprune /sbin/dockerprune
chmod +x /sbin/dockerprune

# docker
apt remove -y docker docker-engine docker.io containerd runc
apt install -y wget apt-transport-https ca-certificates curl gnupg-agent software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt update
apt install -y docker-ce docker-ce-cli containerd.io
usermod -aG docker vagrant
systemctl enable docker
curl -L "https://github.com/docker/compose/releases/download/1.25.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose
curl -L https://raw.githubusercontent.com/docker/compose/1.24.1/contrib/completion/bash/docker-compose -o /etc/bash_completion.d/docker-compose
echo "* soft nofile 65535" >> /etc/security/limits.conf
echo "root soft nofile 65535" >> /etc/security/limits.conf
sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="cgroup_enable=memory swapaccount=1"/' /etc/default/grub
update-grub

# cleanup
rm -rf vm_scripts

# reboot tut gut
reboot
