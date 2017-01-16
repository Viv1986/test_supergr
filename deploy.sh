#!/bin/bash
cd docker-rsyslog-master && docker build . -t rsyslog.master
docker run -d --name rsyslog.master rsyslog.master 

MASTER_IP=`docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' rsyslog.master`
sed -i s/tochange/$MASTER_IP/g ../docker-rsyslog-agent/hostslogs.conf
cd ../docker-rsyslog-agent && docker build . -t rsyslog.agent
docker run -d --name rsyslog.agent -v /var/log/nginx:/var/log/hosts rsyslog.agent

cd ../nginx-static-master && docker build . -t nginx.static
docker run -d --name nginx.static  -v /var/log/nginx:/var/log/hosts -p 80:80 nginx.static
