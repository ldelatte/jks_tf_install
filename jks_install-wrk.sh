#!/bin/bash -v
set -x
{
## sudo yum update -y
sudo yum install -y java-1.8.0-openjdk.x86_64
## install des paquets git, maven, ...
sudo yum install -y git
} >/tmp/jks_install.log 2>&1
