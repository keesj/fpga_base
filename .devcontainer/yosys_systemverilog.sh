#!/bin/sh

# https://github.com/antmicro/yosys-systemverilog

set -e 
set -x

apt-get update
apt-get install -y gcc-9 g++-9 build-essential cmake tclsh ant default-jre swig google-perftools libgoogle-perftools-dev python3 python3-dev python3-pip uuid uuid-dev tcl-dev flex libfl-dev git pkg-config libreadline-dev bison libffi-dev wget
pip3 install orderedmultidict


set -e
git clone https://github.com/antmicro/yosys-systemverilog.git
cd yosys-systemverilog
git submodule update --init --recursive
./build_binaries.sh 
./install_plugin.sh 