#! /usr/bin/env bash
COLOR=$1

echo "Clear cache..."
docker-compose -f ../docker-compose.yml exec tracker_$COLOR mv /app/var/cache /tmp/app
docker-compose -f ../docker-compose.yml exec tracker_$COLOR chown -R application:application /tmp/app
docker-compose -f ../docker-compose.yml exec tracker_$COLOR rm -rf /app/var/cache
docker-compose -f ../docker-compose.yml exec tracker_$COLOR ln -s /tmp/app /app/var/cache
docker-compose -f ../docker-compose.yml exec tracker_$COLOR sudo -u application php bin/console --env=prod cache:clear -vvv

echo "Migrate..."
docker-compose -f ../docker-compose.yml exec tracker_$COLOR sudo -u application php bin/console --env=prod doctrine:migrations:migrate --no-interaction
