TOP_MODULE=top
#TB_SRC=src/sim/$(TOP_MODULE)_tb.sv
TB_SRC=src/sim/uart_txrx_tb.sv
TOP_SRC=src/rtl/top.sv src/rtl/uart_rx.sv src/rtl/uart_tx.sv
SIM_SRC=$(TOP_SRC) $(TB_SRC)
FPGA_PCF=src/syn/icestick.pcf



all:  build build/$(TOP_MODULE).bin

build:
	mkdir build

build/$(TOP_MODULE).bin: build/$(TOP_MODULE).asc  
	icepack $< $@

build/$(TOP_MODULE).asc:build/$(TOP_MODULE).json  
	nextpnr-ice40 --hx1k --json $^ --pcf $(FPGA_PCF) --asc $@


build/$(TOP_MODULE).json: $(TOP_SRC)
	yosys -p "synth_ice40 -top $(TOP_MODULE) -json $@" $^

sim:$(SIM_SRC)
	iverilog -g2012 -o build/$(TOP_MODULE)_tb.dsn $(SIM_SRC)
	vvp build/$(TOP_MODULE)_tb.dsn

simview: build/$(TOP_MODULE).vcd
	gtkwave build/$(TOP_MODULE)_tb.vcd

prog: build/$(TOP_MODULE).bin  
	iceprog build/$(TOP_MODULE).bin

clean:  
	rm build/*

.PHONY: prog clean
