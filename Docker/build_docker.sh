#!/bin/bash

set -ev

VERSION=`cat VERSION.txt`

docker build -t trinityctat/gmapfusion:${VERSION} .
docker build -t trinityctat/gmapfusion:latest .

