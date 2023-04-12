`timescale 1ns/100ps

module top_tb;

  parameter CLK_HZ = 4_000_000;
  logic clk = 1'b0;
  wire        uart_tx;
  wire        uart_rx_break;
  wire        uart_rx_valid;
  wire [7:0] uart_rx_data;

uart_rx #(.CLK_HZ(CLK_HZ)) rx0 (
.clk          ,
.resetn       ,
.uart_rxd(uart_tx) , // glue to top.v
.uart_rx_en(1'b1)   , // alway enable
.uart_rx_break,
.uart_rx_valid,
.uart_rx_data  
);

logic resetn;
//wire  uart_txd;
wire  uart_tx_busy;
logic  uart_tx_en;
logic [7:0]   uart_tx_data;
//
uart_tx  #(.CLK_HZ(CLK_HZ))  uart_tx1(
.clk  ,
.resetn ,
.uart_txd(uart_tx) ,
.uart_tx_busy,
.uart_tx_en ,
.uart_tx_data
);

  always #1 clk=~clk;

  logic [256:0] ascii  = "0123456789abcdef0123456789abcdef";

  initial begin
        uart_tx_en = 1'b0;
        resetn = 1'b0;
        @(posedge clk)
        @(posedge clk)
        resetn = 1'b1;
        @(posedge clk);

        wait(resetn);
        // send data...

        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
        @(posedge clk);
	// Send a single bit
        uart_tx_en  = 1'b1;
        uart_tx_data = ascii[7:0];
        @(posedge clk);
        uart_tx_en = 1'b0;


        #200000 $finish();
  end

  always @(posedge clk) begin
	  if (uart_rx_valid && ! uart_rx_break) begin
		$display("BIT %02x" , uart_rx_data);
	  end
  end
  
  always @(posedge clk) begin
	  if (uart_rx_valid &&  uart_rx_break) begin
		$display("BREAK %02x" , uart_rx_data);
	  end
  end

  initial begin
        //$monitor($time, "clk=%d, led=%b resetn=%d",clk,led0,resetn);
  end

  initial begin
    $dumpfile("build/top_tb.vcd");
    $dumpvars(4,top_tb);
  end
endmodule: top_tb
