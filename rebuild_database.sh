# /bin/bash

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <SERVICE>"
  exit 1
fi

SERVICE="$2"

if [ "$(docker ps -a --filter "name=$SERVICE" --format '{{.Names}}')" ]; then
  docker-compose down $SERVICE
fi

docker-compose up --build -d $SERVICE