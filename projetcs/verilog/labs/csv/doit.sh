#!/bin/sh
set -e
set -x
python3 gen.py >test_data.csv
iverilog test.sv
./a.out
