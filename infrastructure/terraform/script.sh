#!/bin/bash

# Actualizar el sistema y instalar Apache
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y apache2

# Instalar Docker y Docker Compose
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker ubuntu

sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verificar la instalación de Docker y Docker Compose
docker --version
docker-compose --version

# Configurar Apache para redirigir tráfico HTTP a HTTPS
sudo a2enmod ssl
sudo a2enmod headers

# Generar certificado autofirmado para SSL (puedes reemplazarlo con uno válido)
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt -subj "/CN=example.com"

# Configurar archivo de sitio virtual para HTTPS
sudo cat <<EOL > /etc/apache2/sites-available/default-ssl.conf
<IfModule mod_ssl.c>
  <VirtualHost _default_:443>
    ServerAdmin webmaster@localhost
    DocumentRoot /var/www/html

    ErrorLog \${APACHE_LOG_DIR}/error.log
    CustomLog \${APACHE_LOG_DIR}/access.log combined

    SSLEngine on
    SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt
    SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key

    <FilesMatch "\.(cgi|shtml|phtml|php)$">
        SSLOptions +StdEnvVars
    </FilesMatch>
    <Directory /usr/lib/cgi-bin>
        SSLOptions +StdEnvVars
    </Directory>

    BrowserMatch "MSIE [2-6]" \
        nokeepalive ssl-unclean-shutdown \
        downgrade-1.0 force-response-1.0
    BrowserMatch "MSIE [17-9]" ssl-unclean-shutdown

  </VirtualHost>
</IfModule>
EOL

# Activar el sitio SSL y reiniciar Apache
sudo a2ensite default-ssl.conf
sudo systemctl restart apache2

# Clonar el repositorio y ejecutar Docker Compose
cd /home/ubuntu/
git clone https://github.com/pggomez1989/todo-list-devops.git
cd todo-list-devops/app
sudo docker-compose up -d
