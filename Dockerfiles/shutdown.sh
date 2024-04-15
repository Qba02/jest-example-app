#!/bin/bash
echo "Stopping and removing previous containers and images..."

#containers
containersName="deploy-container|test-container|build-container"
containersTags=$(docker ps -aqf "name=${containersName}")
echo "$containersName"

if [ -n "$containersTags" ]; then
    docker stop $containersTags
    docker rm $containersTags
fi

#images
imagesTags=$(docker images -aqf reference="jestapp:v*")
if [ -n "$containersTags" ]; then
     docker rmi $(docker images -q jestapp:v*)
fi
