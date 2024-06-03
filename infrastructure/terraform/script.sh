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

# sudo apt-get install -y nginx

# # Configurar Nginx con un certificado SSL autofirmado
# sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/ssl/nginx.key -out /etc/nginx/ssl/nginx.crt -subj "/CN=localhost"

# # Configurar Nginx
# sudo cat <<EOL > /etc/nginx/sites-available/default
# server {
#     listen 80;
#     server_name _;

#     location / {
#         return 301 https://\$host\$request_uri;
#     }
# }

# server {
#     listen 443 ssl;
#     server_name _;

#     ssl_certificate /etc/nginx/ssl/nginx.crt;
#     ssl_certificate_key /etc/nginx/ssl/nginx.key;

#     location / {
#         proxy_pass http://localhost:3000;
#         proxy_set_header Host \$host;
#         proxy_set_header X-Real-IP \$remote_addr;
#         proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
#         proxy_set_header X-Forwarded-Proto \$scheme;
#     }
# }
# EOL

# sudo systemctl restart nginx

# cd /home/ubuntu/  # Cambia esto si tu usuario es diferente
# git clone https://github.com/pggomez1989/todo-list-devops.git  # Cambia esto a tu repositorio
# cd todo-list-devops/app  # Cambia esto al nombre de tu directorio de la aplicación
# sudo docker-compose up -d