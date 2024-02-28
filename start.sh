#!/bin/bash

# Download test kb
if [ ! -d "ldb" ]; then
    curl -LO https://github.com/scanoss/test-kb/releases/download/v0.1.0/ldb.tar.xz
    tar -vaxf ldb.tar.xz
    rm ldb.tar.xz
fi

docker run --rm -p 5443:5443 \
   -e SCANOSS_API_URL=http://localhost:5443/api \
   -v $(pwd)/ldb:/var/lib/ldb \
   -it scanoss
