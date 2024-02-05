# /bin/bash

if [ "$#" -ne 3 ]; then
  echo "Usage: $0 <production|development> <IMAGE> <SERVICE>"
  exit 1
fi

ENVIROMENT="$1"
IMAGE="$2"
SERVICE="$3"

if [ ! -d "$ENVIRONMENT" ]; then
  echo "Error: Environment directory '$ENVIRONMENT' does not exist."
  exit 1
fi

cd "$ENVIRONMENT"

if [ "$(docker ps -a --filter "name=$SERVICE" --format '{{.Names}}')" ]; then
  docker-compose stop $SERVICE
  docker-compose rm -f $SERVICE
fi

if [ "$(docker images -q "$IMAGE:latest")" ]; then
  docker rmi "$IMAGE:latest"
fi

docker-compose up --build -d $SERVICE