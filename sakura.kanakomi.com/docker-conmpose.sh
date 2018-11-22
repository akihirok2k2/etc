#!/bin/bash

set -x

yum -y update || exit 1

# set up the repository
yum install -y epel-release
sed -i -e "s/enabled=1/enabled=0/g" /etc/yum.repos.d/epel.repo
sed -i -e "s/enabled=1/enabled=0/g" /etc/yum.repos.d/epel-testing.repo
yum install -y yum-utils device-mapper-persistent-data lvm2  || exit 1
yum install -y --enablerepo=epel jq

# install docker ce
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo || exit 1
yum makecache fast || exit 1
yum install -y "docker-ce" || exit 1

systemctl start docker
systemctl enable docker

# install Docker Compose
LATEST_URL=$(curl  --silent  https://api.github.com/repos/docker/compose/releases/latest | jq --raw-output '.assets[] | select(.browser_download_url | test("Linux-x86_64$"))|.browser_download_url')
curl -Ss -L $LATEST_URL > /usr/local/bin/docker-compose || exit 1
chmod +x /usr/local/bin/docker-compose

reboot

