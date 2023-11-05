#set env vars
set -o allexport; source .env; set +o allexport;
set -o allexport; source temp.env; set +o allexport;

#wait until the server is ready
echo "Waiting for software to be ready ..."
sleep 30s;

echo "y" | docker-compose exec -T web sh -c 'wait-for-it db:3306 -t 180 && php artisan optimize:clear && php artisan key:generate && php artisan config:cache && php artisan migrate'
docker-compose down;
docker-compose up -d

echo "Restarting..."
sleep 250s

cookie_file="cookies.txt"
curlResponse=$(curl -s $APP_URL/install -c "$cookie_file")

attendize_session=$(awk -F'\t' '/attendize_session/ {print $7}' "$cookie_file")
XSRF_TOKEN=$(awk -F'\t' '/XSRF-TOKEN/ {print $7}' "$cookie_file")

# Use grep and awk to extract the value of _token
token_value=$(echo "$curlResponse" | grep -o '<input name="_token" type="hidden" value="[^"]*' | awk -F '"' '{print $6}')






curl $APP_URL/install \
  -H 'accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7' \
  -H 'accept-language: fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7,he;q=0.6' \
  -H 'cache-control: no-cache' \
  -H 'content-type: application/x-www-form-urlencoded' \
  -H 'cookie: XSRF-TOKEN='${XSRF_TOKEN}'; attendize_session='${attendize_session}'' \
  -H 'pragma: no-cache' \
  -H 'upgrade-insecure-requests: 1' \
  -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/118.0.0.0 Safari/537.36' \
  --data-raw '_token='${token_value}'&app_url='${APP_URL}'&database_type='${DB_CONNECTION}'&database_host='${DB_HOST}'&database_name='${DB_DATABASE}'&database_username='${DB_USERNAME}'&database_password='${DB_PASSWORD}'&mail_from_address='${MAIL_FROM_ADDRESS}'&mail_from_name='${MAIL_FROM_NAME}'&mail_driver='${MAIL_DRIVER}'&mail_port='${MAIL_PORT}'&mail_encryption=&mail_host='${MAIL_HOST}'&mail_username=&mail_password=&_token='${token_value}'' \
  --compressed

sleep 30s;
echo "Registering..."

docker-compose exec -T web php artisan attendize:install

sed -i "s~# - ./config/installed:/usr/share/nginx/html/installed~- ./config/installed:/usr/share/nginx/html/installed~g" ./docker-compose.yml

cat << EOT >> ./.env

ADMIN_EMAIL=${TEMP_ADMIN_EMAIL}
ADMIN_PASSWORD=${TEMP_ADMIN_PASSWORD}
EOT
  
  rm ./$cookie_file
  rm ./temp.env