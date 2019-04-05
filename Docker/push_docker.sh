#!/bin/bash

set -ev

VERSION=`cat VERSION.txt`

docker push trinityctat/gmapfusion:${VERSION}
docker push trinityctat/gmapfusion:latest

