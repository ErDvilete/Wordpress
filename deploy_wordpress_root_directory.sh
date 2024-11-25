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

#Creamos un archivo de configuración wp-config.php a partir del archivo de ejemplo wp-configsample.php.

cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

#En este paso tenemos que configurar las variables de configuración del archivo de configuración de WordPress. El contenido original del archivo wp-config.php será similar a este:

sed -i "s/database_name_here/$WORDPRESS_DB_NAME/" /var/www/html/wp-config.php
sed -i "s/username_here/$WORDPRESS_DB_USER/" /var/www/html/wp-config.php
sed -i "s/password_here/$WORDPRESS_DB_PASSWORD/" /var/www/html/wp-config.php
sed -i "s/localhost/$WORDPRESS_DB_HOST/" /var/www/html/wp-config.php

#Cambiamos el propietario y el grupo al directorio /var/www/html.

chown -R www-data:www-data /var/www/html/

#Preparamos la configuración para los enlaces permanentes de WordPress. En este paso tendremos que crear un archivo .htaccess en el directorio /var/www/html con un contenido similar a este.

# Create or update the .htaccess file for WordPress
touch /var/www/html/.htaccess 

# BEGIN WordPress
<IfModule mod_rewrite.c>
    RewriteEngine On
    RewriteBase /

    # Prevent direct access to the index.php file
    RewriteRule ^index\.php$ - [L]

    # If the requested file does not exist
    RewriteCond %{REQUEST_FILENAME} !-f
    # If the requested directory does not exist
    RewriteCond %{REQUEST_FILENAME} !-d

    # Redirect all other requests to index.php
    RewriteRule . /index.php [L]
</IfModule>
# END WordPress

#Habilitamos el módulo mod_rewrite de Apache.

a2enmod rewrite

#Después de habilitar el módulo deberá reiniciar el servicio de Apache.

sudo systemctl restart apache2