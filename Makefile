dev: 
	docker compose --env-file .env \
	-f docker-compose.yml \
	-f docker-compose.yml up -d --build

down:
	docker compose down

migrate:
	docker compose exec app php artisan migrate
