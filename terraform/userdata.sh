#!/usr/bin/env bash

# ---- Update Yum ----

yum update -y


# ---- Install Salt ----

tee /etc/yum.repos.d/saltstack.repo <<-'EOF'
[saltstack-repo]
name=SaltStack repo for RHEL/CentOS 6
baseurl=https://repo.saltstack.com/yum/redhat/6/$basearch/latest
enabled=1
gpgcheck=1
gpgkey=https://repo.saltstack.com/yum/redhat/6/$basearch/latest/SALTSTACK-GPG-KEY.pub
EOF

yum install salt-master -y
yum install salt-minion -y
yum install salt-ssh -y
yum install salt-syndic -y
yum install salt-syndic -y


tee /etc/salt/minion <<-'EOF'
master: saltmaster.example.com
EOF

service salt-master start
salt-minion -d
sleep 10
salt-key -A -y

# ---- Install Docker Image ----

# -- Pull Docker Image from Docker hub

mkdir -p /docker

docker pull ${docker_image}

# -- Write html file

mkdir -p /var/www/

tee /var/www/index.html <<-'EOF'
<!DOCTYPE html>
<html>
<head>
<title>Automation for the People</title>
</head>
<body>
Automation for the People
</body>
</html>
EOF


# -- Write env data data

tee /var/www/_env.json <<-EOF
{
  "name" : "${name}",
  "env" : "${env}",
  "stack" : "${stack}",
  "created" : "$(date)",
  "ip" : "$(curl -s http://169.254.169.254/latest/meta-data/local-ipv4)",
  "az" : "$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)"
}
EOF


# -- Write service start/stop/restart script

tee /etc/init.d/automation-for-the-people <<-'EOF'
#!/bin/bash
#
# automation-for-the-people   Startup script for the Application
#
# chkconfig: - 85 15
# description: The Application  \
#
# processname: automation-for-the-people
#

start(){
        echo "Starting automation-for-the-people..."

        exists=$(docker ps -a -f name=automation-for-the-people -q)

        if [ -z "$exists" ]; then
          docker run --name automation-for-the-people \
            -p 80:80 \
            -v /var/www:/usr/share/nginx/html:ro -d nginx
        else
          docker start automation-for-the-people
        fi
}

stop(){
        echo "Stopping automation-for-the-people..."

        docker stop automation-for-the-people
}

restart(){
        stop
        sleep 60
        start
}

case "$1" in
  start)
        start
        ;;
  stop)
        stop
        ;;
  restart)
        restart
        ;;
  *)
        echo "Usage: automation-for-the-people {start|stop|restart}"
        exit 1
esac

exit 0
EOF


# -- Set script with runable permissions and start as a service

chmod 755 /etc/init.d/automation-for-the-people
chkconfig automation-for-the-people on
service automation-for-the-people start
