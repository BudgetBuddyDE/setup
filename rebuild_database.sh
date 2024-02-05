# /bin/bash

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <production|development>"
  exit 1
fi

ENVIRONMENT="$1"
SERVICE="postgres"

if [ ! -d "$ENVIRONMENT" ]; then
  echo "Error: Environment directory '$ENVIRONMENT' does not exist."
  exit 1
fi

cd "$ENVIRONMENT"

echo "restarting the service '$SERVICE' on '$ENVIRONMENT'"

if [ "$(docker ps -a --filter "name=$SERVICE" --format '{{.Names}}')" ]; then
  docker-compose stop $SERVICE
  docker-compose rm -f $SERVICE
fi

docker-compose up --build -d $SERVICE