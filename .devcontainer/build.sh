#!/bin/sh
set -e
set -x
# http://www.clifford.at/icestorm/
sudo apt-get update
sudo  DEBIAN_FRONTEND=noninteractive apt-get -y install build-essential clang bison flex libreadline-dev \
                     gawk tcl-dev libffi-dev git mercurial graphviz   \
                     qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools python3-dev libboost-all-dev cmake libeigen3-dev libftdi-dev


rm -rf icestorm arachne-pnr nextpnr yosys

date
(
git clone https://github.com/YosysHQ/icestorm.git icestorm
cd icestorm
make -j$(nproc)
sudo make install
)

(
git clone https://github.com/cseed/arachne-pnr.git arachne-pnr
cd arachne-pnr
make -j$(nproc)
sudo make install
)

(
git clone --recursive https://github.com/YosysHQ/nextpnr nextpnr
cd nextpnr
cmake -DARCH=ice40 -DCMAKE_INSTALL_PREFIX=/usr/local .
make -j$(nproc)
sudo make install
)
 
(
git clone https://github.com/YosysHQ/yosys.git yosys
cd yosys
make -j$(nproc)
sudo make install
)

rm -rf icestorm arachne-pnr nextpnr yosys


