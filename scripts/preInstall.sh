#set env vars
set -o allexport; source .env; set +o allexport;

cat << EOT >> ./temp.env

TEMP_ADMIN_EMAIL=${ADMIN_EMAIL}
TEMP_ADMIN_PASSWORD=${ADMIN_PASSWORD}
EOT

sed -i "s~ADMIN_TO_CHANGE~admin~g" ./config/Install.php
sed -i "s~EMAIL_TO_CHANGE~$ADMIN_EMAIL~g" ./config/Install.php
sed -i "s~PASSWORD_TO_CHANGE~$ADMIN_PASSWORD~g" ./config/Install.php