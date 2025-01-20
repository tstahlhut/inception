/** The name of the database for WordPress */
define('DB_NAME', getenv("WORDPRESS_DB_NAME"));  // Database name

/** MySQL database username */
define('DB_USER', getenv('WORDPRESS_DB_USER'));  // Database username

/** MySQL database password */
define('DB_PASSWORD', getenv('WORDPRESS_DB_PASSWORD'));  // Database password

/** MySQL hostname */
define('DB_HOST', getenv('WORDPRESS_DB_HOST'));  // MariaDB container name and port
