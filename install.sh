#!/bin/bash
set -e
cd "$(dirname "$0")"

ENV=${1:-dev}

ENV_FILE=".env"
COMPOSE_FILE="docker-compose.yml"

echo " Instalando entorno $ENV"

# Crear proyecto si no existe
if [ ! -f src/artisan ]; then
  docker run --rm -v "$(pwd)/src":/app composer create-project laravel/laravel .
fi

# 1. Si no existe el .env en src, copiarlo del ejemplo
if [ ! -f src/.env ]; then
    cp src/.env.example src/.env
fi


# 2. Forzar la configuración limpia de Postgres
echo "Configurando .env para PostgreSQL..."

set -a
source .env
set +a

# Reemplazamos la conexión
sed -i 's/^DB_CONNECTION=.*/DB_CONNECTION=pgsql/' src/.env
# Reemplazamos o quitamos comentarios de las variables clave
sed -i 's/^# DB_HOST=.*/DB_HOST=db/' src/.env || sed -i 's/^DB_HOST=.*/DB_HOST=db/' src/.env
sed -i 's/^# DB_PORT=.*/DB_PORT=5432/' src/.env || sed -i 's/^DB_PORT=.*/DB_PORT=5432/' src/.env
sed -i 's/^# DB_DATABASE=.*/DB_DATABASE=$DB_DATABASE/' src/.env || sed -i 's/^DB_DATABASE=.*/DB_DATABASE=$DB_DATABASE/' src/.env
sed -i 's/^# DB_USERNAME=.*/DB_USERNAME=$DB_USERNAME/' src/.env || sed -i 's/^DB_USERNAME=.*/DB_USERNAME=$DB_USERNAME/' src/.env
sed -i 's/^# DB_PASSWORD=.*/DB_PASSWORD=$DB_PASSWORD/' src/.env || sed -i 's/^DB_PASSWORD=.*/DB_PASSWORD=$DB_PASSWORD/' src/.env

# 3. Limpiar caché de Laravel por si acaso
docker compose exec app php artisan config:clear || true

# Nota: Asegúrate de que los valores de arriba coincidan con los que 
# tienes en tu archivo .env principal que lee el docker-compose.

docker compose --env-file $ENV_FILE \
  -f docker-compose.yml \
  -f $COMPOSE_FILE \
  up -d --build

docker compose exec app chown -R www-data:www-data /var/www
docker compose exec app chmod -R 775 /var/www/storage /var/www/bootstrap/cache

sleep 5

docker compose exec app php artisan key:generate --force
docker compose exec app php artisan migrate --force

echo " Entorno $ENV listo"
echo " PostgreSQL:  http://localhost:5050/login"
echo " Laravel:     http://localhost:8000"
