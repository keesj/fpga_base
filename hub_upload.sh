#!/bin/sh
#docker login
docker tag  fpga_base:latest keesj/base:fpga
docker push keesj/base:fpga
