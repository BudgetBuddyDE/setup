# /bin/bash

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <production|development>  <SERVICE>"
  exit 1
fi

ENVIRONMENT="$1"
SERVICE="$2"

if [ ! -d "$ENVIRONMENT" ]; then
  echo "Error: Environment directory '$ENVIRONMENT' does not exist."
  exit 1
fi

cd "$ENVIRONMENT"

if [ "$(docker ps -a --filter "name=$SERVICE" --format '{{.Names}}')" ]; then
  docker-compose down $SERVICE
fi

docker-compose up --build -d $SERVICE