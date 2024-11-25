
#Creamos un archivo de configuración wp-config.php a partir del archivo de ejemplo wp-configsample.php.

cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wpconfig.php -v

#En este paso tenemos que configurar las variables de configuración del archivo de configuración de WordPress. El contenido original del archivo wp-config.php será similar a este:

sed -i "s/database_name_here/$WORDPRESS_DB_NAME/" /var/www/html/wordpress/wpconfig.php
sed -i "s/username_here/$WORDPRESS_DB_USER/" /var/www/html/wordpress/wp-config.php
sed -i "s/password_here/$WORDPRESS_DB_PASSWORD/" /var/www/html/wordpress/wpconfig.php
sed -i "s/localhost/$WORDPRESS_DB_HOST/" /var/www/html/wordpress/wp-config.php

#Cuando realizamos la instalación de WordPress en su propio directorio, es necesario configurar estas dos variables de configuración:

sed -i "/DB_COLLATE/a define('WP_SITEURL', 'https://$CERTIFICATE_DOMAIN/wordpress');" /var/www/html/wordpress/wp-config.php
sed -i "/WP_SITEURL/a define('WP_HOME', 'https://$CERTIFICATE_DOMAIN');" /var/www/html/wordpress/wp-config.php

#Copiamos el archivo /var/www/html/wordpress/index.php a /var/www/html.

cp /var/www/html/wordpress/index.php /var/www/html/index.php -v

#El contenido original del archivo index.php será similar a este:
#require( dirname( __FILE__ ) . '/wp-blog-header.php' );
# Y tenemos que reemplazarlo por este otro:
# require( dirname( __FILE__ ) . '/wordpress/wp-blog-header.php' );

sed -i "s#wp-blog-header.php#wordpress/wp-blog-header.php#" /var/www/html/index.php

# Create or update the .htaccess file for WordPress

cp -v /htaccess/.htaccess /var/www/html

#Habilitamos el módulo mod_rewrite de Apache.

a2enmod rewrite

#Después de habilitar el módulo deberá reiniciar el servicio de Apache.

sudo systemctl restart apache2



