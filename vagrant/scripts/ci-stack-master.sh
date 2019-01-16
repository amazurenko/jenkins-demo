#!/bin/bash

cat <<END

================================================================================

    Configuring and enabling ci-stack.service

================================================================================

END


cat <<EOF >  /etc/systemd/system/ci-stack.service
[Unit]
Description=CI Stack
After=docker.service

[Service]
ExecStart=/bin/docker-compose --project-directory /vagrant/ci-stack/ -f /vagrant/ci-stack/docker-compose.jenkins.yml -f /vagrant/ci-stack/docker-compose.nexus.yml -f /vagrant/ci-stack/docker-compose.nginx.yml -f /vagrant/ci-stack/docker-compose.portainer.yml -f /vagrant/ci-stack/docker-compose.sonar.yml up -d
ExecStop=/bin/docker-compose --project-directory /vagrant/ci-stack/ -f /vagrant/ci-stack/docker-compose.jenkins.yml -f /vagrant/ci-stack/docker-compose.nexus.yml -f /vagrant/ci-stack/docker-compose.nginx.yml -f /vagrant/ci-stack/docker-compose.portainer.yml -f /vagrant/ci-stack/docker-compose.sonar.yml  stop
ExecReload=/bin/docker-compose --project-directory /vagrant/ci-stack/ -f /vagrant/ci-stack/docker-compose.jenkins.yml -f /vagrant/ci-stack/docker-compose.nexus.yml -f /vagrant/ci-stack/docker-compose.nginx.yml -f /vagrant/ci-stack/docker-compose.portainer.yml -f /vagrant/ci-stack/docker-compose.sonar.yml  restart
TimeoutStartSec=30m
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

systemctl enable ci-stack


cat <<END

================================================================================

    Starting ci-stack 

================================================================================

END
systemctl start ci-stack