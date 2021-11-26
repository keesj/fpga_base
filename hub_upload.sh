#!/bin/sh
#docker login
docker tag  project-fpga_base:latest keesj/base:fpga
docker push keesj/base:fpga
