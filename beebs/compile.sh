#!/bin/bash

FLAGS_TO_TEST="-static -march=rv64ima -mabi=lp64 -O2 $2 $3 $4 $5 $6"

cd support
make clean
make CFLAGS="${FLAGS_TO_TEST}"
cd ..

cd src/$1
make clean
make CFLAGS="${FLAGS_TO_TEST}"
cd ..