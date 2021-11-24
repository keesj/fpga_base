#!/bin/sh

# find a nice name for the container
NAME=project-`basename \`realpath .\``

if grep docker /proc/self/cgroup 2>&1 1>/dev/null
then
        echo "EXIT: you are already runnig inside docker prove me wrong"
        exit 1
fi

docker build  \
    --build-arg USER_UID=$(id -u) \
    --build-arg USER_GID=$(id -g) \
    -t ${NAME} -f .devcontainer/Dockerfile  .
echo run docker rmi ${NAME} to force a rebuild
echo 
docker run -it -v $(pwd):/workspace/software ${NAME} /bin/bash 
