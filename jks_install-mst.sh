#!/bin/bash -v
set -x
{
## sudo yum update -y
sudo yum install -y java-1.8.0-openjdk.x86_64
sudo curl http://pkg.jenkins-ci.org/redhat/jenkins.repo >/etc/yum.repos.d/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key
sudo yum install -y jenkins
sudo systemctl start jenkins
sleep 20
sudo systemctl status jenkins
curl localhost:8080
#
## sudo iptables -A PREROUTING -t nat -i eth0 -p tcp -- dport 80 -j REDIRECT --to-port 8080
## sudo iptables -t nat -I OUTPUT -p tcp -o lo --dport 80 -j REDIRECT --to-ports 8080
} >/tmp/jks_install.log 2>&1
