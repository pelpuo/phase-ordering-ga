#!/bin/bash

FLAGS_TO_TEST="-march=rv64imac -mabi=lp64 -O0  -std=gnu99 "

cd support
make clean
make CFLAGS="${FLAGS_TO_TEST}"
cd ..

cd src/$1
make clean
make CFLAGS="${FLAGS_TO_TEST}"
cd ..