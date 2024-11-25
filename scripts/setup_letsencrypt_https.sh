#. En primer lugar, eliminamos los valores por defecto de las security keys que aparecen en el archivo de configuración.

sed -i "/AUTH_KEY/d" /var/www/html/wordpress/wp-config.php
sed -i "/SECURE_AUTH_KEY/d" /var/www/html/wordpress/wp-config.php
sed -i "/LOGGED_IN_KEY/d" /var/www/html/wordpress/wp-config.php
sed -i "/NONCE_KEY/d" /var/www/html/wordpress/wp-config.php
sed -i "/AUTH_SALT/d" /var/www/html/wordpress/wp-config.php
sed -i "/SECURE_AUTH_SALT/d" /var/www/html/wordpress/wp-config.php
sed -i "/LOGGED_IN_SALT/d" /var/www/html/wordpress/wp-config.php
sed -i "/NONCE_SALT/d" /var/www/html/wordpress/wp-config.php

#Hacemos una llamada a la API de wordpress para obtener las security keys y almacenamos el resultado en una variable de entorno.

SECURITY_KEYS=$(curl https://api.wordpress.org/secret-key/1.1/salt/)

# Las nuevas security keys que acabamos de generar pueden contener el carácter / y este carácter puede darnos problemas a la hora de utilizar el comando sed para añadirlas al archivo de configuración.

SECURITY_KEYS=$(echo $SECURITY_KEYS | tr / _)

# Añadimos las security keys al archivo de configuración

sed -i "/@-/a $SECURITY_KEYS" /var/www/html/wordpress/wp-config.php

# Cambiamos el propietario y el grupo al directorio /var/www/html.

chown -R www-data:www-data /var/www/html/

