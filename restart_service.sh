# /bin/bash

if [ "$#" -ne 2 ]; then
  echo "Usage: $0 <IMAGE> <SERVICE>"
  exit 1
fi

IMAGE="$1"
SERVICE="$2"

if [ "$(docker ps -a --filter "name=$SERVICE" --format '{{.Names}}')" ]; then
  docker-compose stop $SERVICE
  docker-compose rm -f $SERVICE
fi

if [ "$(docker images -q "$IMAGE:latest")" ]; then
  docker rmi "$IMAGE:latest"
fi

docker-compose up --build -d $SERVICE