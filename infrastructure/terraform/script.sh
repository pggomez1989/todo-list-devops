#!/bin/bash

sudo apt-get remove docker docker-engine docker.io containerd runc -y

sudo apt-get update && sudo apt-get upgrade -y

sudo apt-get install ca-certificates curl gnupg lsb-release -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg && \echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update && sudo apt-get install docker-ce docker-ce-cli containerd.io -y

sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && sudo chmod +x /usr/local/bin/docker-compose

sudo docker --version && sudo docker-compose --version

echo "============== DOCKER INSTALADO CON EXITO ================"

# if [[ $(id -u) -ne 0  ]]; then
#    echo "debes ser root"
#      exit 1;
# fi

# if [[ -d rampUp-v1.0  ]]; then
#       echo "directorio existente"

# else
#      cd /home/ubuntu/
#      git clone https://github.com/ElielBloemer/rampUp-v1.0.git
# fi

# cd ./rampUp-v1.0/docker-compose/

# ip=$(curl -s ifconfig.me)

# if [[ ! $(grep -i "BACKEND_URL" .env | cut -d"=" -f2) =~ ^[0-9.:]+$ ]];then
#        echo "seteando ip"
#        sed -i -e "/BACKEND_URL/s/=/=${ip}:3000/g" .env
# else
#         echo "ip ya seteada"
# fi

# echo "------------------------------"
# echo " IP PUBLICA $ip "

# sudo docker-compose up -d
