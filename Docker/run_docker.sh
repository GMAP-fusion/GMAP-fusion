#!/bin/bash

docker run --rm -it -v `pwd`:`pwd` -v ${CTAT_GENOME_LIB}:/ctat_genome_lib  trinityctat/gmapfusion:latest $*

