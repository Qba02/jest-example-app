#!/bin/bash
echo "Stopping and removing previous containers..."

containersName="deploy-container|test-container|build-container"
containersTags=$(docker ps -aqf "name=${containersName}")
echo "$containersName"

if [ -n "$containersTags" ]; then
    docker stop $containersTags
    docker rm $containersTags
fi
