#!/bin/bash

set -ev

VERSION=`cat VERSION.txt`

cachebustdate=$(date +%s)

docker build -t trinityctat/gmapfusion:${VERSION} --build-arg CACHEBUST=${cachebustdate} .
docker build -t trinityctat/gmapfusion:latest --build-arg CACHEBUST=${cachebustdate} .

