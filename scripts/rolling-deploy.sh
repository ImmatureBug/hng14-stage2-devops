#!/bin/bash
set -e

SERVICES=("api" "worker" "frontend")
TIMEOUT=60

for SERVICE in "${SERVICES[@]}"; do
  echo "Deploying $SERVICE..."

  docker compose up -d --no-deps --build --scale $SERVICE=2 $SERVICE

  ELAPSED=0
  until [ "$(docker inspect --format='{{.State.Health.Status}}' $(docker compose ps -q $SERVICE | tail -1))" = "healthy" ]; do
    if [ $ELAPSED -ge $TIMEOUT ]; then
      echo "Health check failed for $SERVICE — rolling back"
      docker compose up -d --no-deps --scale $SERVICE=1 $SERVICE
      exit 1
    fi
    sleep 5
    ELAPSED=$((ELAPSED + 5))
  done

  docker compose up -d --no-deps --scale $SERVICE=1 $SERVICE
  echo "$SERVICE deployed successfully"
done