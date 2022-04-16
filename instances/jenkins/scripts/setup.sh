#!/bin/bash
sudo yum update –y
# sudo wget -O /etc/yum.repos.d/jenkins.repo \
#     https://pkg.jenkins.io/redhat-stable/jenkins.repo
# sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io.key
sudo yum upgrade
# sudo amazon-linux-extras install java-openjdk11 -y
# sudo yum install jenkins -y
# sudo systemctl enable jenkins
# sudo systemctl start jenkins
# sudo systemctl status jenkins

# sudo amazon-linux-extras install nginx1 -y

# mapping ports can do this in docker?
# sudo iptables -t nat -I PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8080
# sudo iptables -t nat -I PREROUTING -p tcp --dport 443 -j REDIRECT --to-ports 8443
# sudo su -
# sudo iptables-save > /etc/sysconfig/iptables

# need to add port 8443 for https jenkins before restarting

# dockerizing jenkins
# install docker (already installed)
sudo yum install docker -y
sudo systemctl start docker
# create docker-compose file
cat > docker-compose.yaml << EOF
version: "3.8"
services:
  jenkins:
    image: jenkins/jenkins:lts
    privileged: true
    user: root
    ports:
      - 80:8080
      - 443:8443
      - 50000:50000
    container_name: jenkins
    volumes:
      - /home/ec2-user/docker/jenkins:/var/jenkins_home
      - /var/run/docker.sock:/var/run/docker.sock

EOF

# install docker compose
sudo curl -L https://github.com/docker/compose/releases/download/1.28.4/docker-compose-`uname -s`-`uname -m` -o /usr/bin/docker-compose
sudo chmod +x /usr/bin/docker-compose

docker-compose up -d

# first time jenkins setup
# sudo docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword