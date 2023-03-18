# fpga_base

# https://github.com/antmicro/yosys-systemverilog

git clone https://github.com/antmicro/yosys-systemverilog.git

git submodule update --init --recursive

apt install -y gcc-9 g++-9 build-essential cmake tclsh ant default-jre swig google-perftools libgoogle-perftools-dev python3 python3-dev python3-pip uuid uuid-dev tcl-dev flex libfl-dev git pkg-config libreadline-dev bison libffi-dev wget
pip3 install orderedmultidict
./build_binaries.sh 
sudo ./install_plugin.sh 
