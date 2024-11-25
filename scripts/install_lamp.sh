
#Descargamos la última versión de WordPress con el comando wget.

wget http://wordpress.org/latest.tar.gz -P /tmp

#Descomprimimos el archivo .tar.gz que acabamos de descargar con el comando tar.

tar -xzvf /tmp/latest.tar.gz -C /tmp

#El contenido se ha descomprimido en una carpeta que se llama wordpress. Ahora, movemos el contenido de /tpm/wordpress a /var/www/html.

mv -f /tmp/wordpress/* /var/www/html

# Creamos la base de datos y el usuario para WordPress.

mysql -u root <<< "DROP DATABASE IF EXISTS $WORDPRESS_DB_NAME"
mysql -u root <<< "CREATE DATABASE $WORDPRESS_DB_NAME"
mysql -u root <<< "DROP USER IF EXISTS $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL"
mysql -u root <<< "CREATE USER $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL IDENTIFIED BY '$WORDPRESS_DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $WORDPRESS_DB_NAME.* TO $WORDPRESS_DB_USER@$IP_CLIENTE_MYSQL"