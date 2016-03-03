#!/bin/sh
if [ $# != 1 ]; then
   echo "Usage: $0 DOCKER_IMAGE"
   exit 1
fi

cat <<EOF | docker build -t $1 -
FROM $1
ONBUILD ENV http_proxy $http_proxy
ONBUILD ENV https_proxy $https_proxy
ONBUILD ENV no_proxy $no_proxy
EOF

