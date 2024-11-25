
#Creamos un archivo de configuración wp-config.php a partir del archivo de ejemplo wp-configsample.php.

cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php -v

#En este paso tenemos que configurar las variables de configuración del archivo de configuración de WordPress. El contenido original del archivo wp-config.php será similar a este:

sed -i "s/database_name_here/$WORDPRESS_DB_NAME/" /var/www/html/wp-config.php
sed -i "s/username_here/$WORDPRESS_DB_USER/" /var/www/html/wp-config.php
sed -i "s/password_here/$WORDPRESS_DB_PASSWORD/" /var/www/html/wp-config.php
sed -i "s/localhost/$WORDPRESS_DB_HOST/" /var/www/html/wp-config.php

#Cambiamos el propietario y el grupo al directorio /var/www/html.

chown -R www-data:www-data /var/www/html/

#Preparamos la configuración para los enlaces permanentes de WordPress. En este paso tendremos que crear un archivo .htaccess en el directorio /var/www/html con un contenido similar a este.

# Create or update the .htaccess file for WordPress

cp -v /htaccess/.htaccess /var/www/html

#Habilitamos el módulo mod_rewrite de Apache.

a2enmod rewrite

#Después de habilitar el módulo deberá reiniciar el servicio de Apache.

sudo systemctl restart apache2