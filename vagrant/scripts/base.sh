#!/bin/bash

USERNAME=$1

cat <<END
Executing ${0}
================================================================================

    Installing Tools and EPEL REPO
      - epel-release
      - wget
      - ntp
      - jq
      - net-tools
      - bind-utils
      - moreutils
      - python-pip
      - java-1.8.0-openjdk 
      - java-1.8.0-openjdk-devel 
      - git 

================================================================================

END

yum install -y deltarpm
yum update  -y
yum install -y epel-release wget ntp jq net-tools bind-utils moreutils python-pip java-1.8.0-openjdk  java-1.8.0-openjdk-devel git 


cat <<END

================================================================================

    Disabling SELINUX

================================================================================

END

getenforce | grep Disabled || setenforce 0
echo "SELINUX=disabled" > /etc/sysconfig/selinux

#cat <<END
#
#================================================================================
#
#    Disabling SWAP
#
#================================================================================
#
#END
## Disable SWAP (As of release Kubernetes 1.8.0, kubelet will not work with enabled swap.)
#sed -i '/swap/d' /etc/fstab
#swapoff --all
#

cat <<END

===============================================================================

    Enable and Start NTPD

================================================================================

END
systemctl start ntpd
systemctl enable ntpd

# Installing Docker CE
# https://docs.docker.com/install/linux/docker-ce/centos/#install-docker-ce
cat <<END

================================================================================

    Installing Docker CE (https://docs.docker.com/install/linux/docker-ce/centos/#install-docker-ce):
       yum install -y yum-utils
       yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
       yum-config-manager --enable docker-ce-edge
       yum install -y docker-ce runc

================================================================================

END

yum install -y yum-utils
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum-config-manager --enable docker-ce-edge
yum install -y docker-ce runc

systemctl enable docker 

cat <<END

================================================================================

    Configuring Docker Daemon

================================================================================

END

mkdir -p /etc/docker

docker info | grep "Cgroup Driver: systemd"
if [ $? -ne 0 ]; then
    echo "Updating Docker settings"
    if [ -f /etc/docker/daemon.json ]; then
        cat /etc/docker/daemon.json | \
            jq '."exec-opts" |= .+ ["native.cgroupdriver=systemd"]' | \
            sponge /etc/docker/daemon.json
    else
        echo "{}" | \
        jq '."exec-opts" |= .+ ["native.cgroupdriver=systemd"]' > \
        /etc/docker/daemon.json
    fi
    echo "cat /etc/docker/daemon.json:"
    cat /etc/docker/daemon.json
    echo 
    systemctl restart docker || exit 1
fi

cat <<END

================================================================================

    Installing Docker Compose
    	sudo pip install --upgrade pip
    	sudo pip install docker-compose

================================================================================

END

sudo pip install --upgrade pip
sudo pip install docker-compose


cat <<END

================================================================================

    Enable passing bridged IPv4 traffic to iptables’ chains

================================================================================

END
cat <<EOF >  /etc/sysctl.d/docker.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sysctl --system

systemctl start docker

cat <<END

================================================================================

    Enable passing bridged IPv4 traffic to iptables’ chains

================================================================================

END
sudo usermod -aG docker ${USERNAME} || true

# Host Internal IP: 192.168.56. ...
IPADDR=$(hostname -I | sed 's/10.0.2.15//' | awk '{print $1}')

# yum install -y dnsmasq
# cat <<EOF > /etc/dnsmasq.d/10-kub-dns
# server=/svc.cluster.local/10.96.0.10#53
# listen-address=127.0.0.1
# bind-interfaces
# EOF

# systemctl start dnsmasq
# systemctl enable dnsmasq