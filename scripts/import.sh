#!/bin/bash

echo 'bulk insert oss from /scanoss/mined WITH (FILE_DEL=0, OVERWRITE=1)' | ldb
