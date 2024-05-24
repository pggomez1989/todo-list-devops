#!/bin/bash
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y nginx

# Instalar Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Agregar tu usuario al grupo de Docker
sudo usermod -aG docker ubuntu

# Instalar Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verificar la instalación
docker --version
docker-compose --version

# Configurar Nginx
sudo cat <<EOL > /etc/nginx/sites-available/default
server {
    listen 80;
    server_name _;

    location / {
        return 301 https://\$host\$request_uri;
    }
}

server {
    listen 443 ssl;
    server_name _;

    ssl_certificate /etc/nginx/ssl/nginx.crt;
    ssl_certificate_key /etc/nginx/ssl/nginx.key;

    location / {
        proxy_pass http://localhost:3000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOL

sudo systemctl restart nginx

cd /home/ubuntu/  # Cambia esto si tu usuario es diferente
git clone https://github.com/pggomez1989/todo-list-devops.git  # Cambia esto a tu repositorio
cd todo-list-devops/app  # Cambia esto al nombre de tu directorio de la aplicación
sudo docker-compose up -d