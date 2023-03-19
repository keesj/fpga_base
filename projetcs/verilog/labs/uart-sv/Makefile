TOP_MODULE=top
TOP_SRC=src/top.sv src/uart_rx.sv src/uart_tx.sv src/global_reset.sv
FPGA_PCF=syn/icestick.pcf



all:  build build/$(TOP_MODULE).bin

build:
	mkdir build

build/$(TOP_MODULE).bin: build/$(TOP_MODULE).asc  
	icepack $< $@

build/$(TOP_MODULE).asc:build/$(TOP_MODULE).json  
	nextpnr-ice40 --hx1k --json $^ --pcf $(FPGA_PCF) --asc $@


build/$(TOP_MODULE).json: src/*.sv  
	yosys -p "synth_ice40 -top $(TOP_MODULE) -json $@" $^

build/$(TOP_MODULE).dsn:
	iverilog -g2012 -o build/$(TOP_MODULE)_tb.dsn sim/$(TOP_MODULE)_tb.sv $(TOP_SRC)

build/$(TOP_MODULE).vcd: build/$(TOP_MODULE).dsn
	vvp build/$(TOP_MODULE)_tb.dsn

sim: build/$(TOP_MODULE).vcd
	gtkwave build/$(TOP_MODULE)_tb.vcd

prog: build/$(TOP_MODULE).bin  
	iceprog build/$(TOP_MODULE).bin

clean:  
	rm build/*

.PHONY: prog clean
