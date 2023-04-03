`timescale 1ns/100ps

module top_tb;

  parameter CLK_HZ = 2_000_000;
  logic clk = 1'b0;
  wire        uart_rxd;
  wire        uart_txd;
  wire        led0;
  wire        led1;
  wire        led2;
  wire        led3;
  wire        led4;
  top #(.CLK_HZ(CLK_HZ)) top1(
    .clk,
    .uart_rxd,
    .uart_txd,
    .led1(led0),
    .led2(led1),
    .led3(led2),
    .led4(led3),
    .led5(led5)
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
.uart_txd(uart_rxd) ,
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
        uart_tx_en  = 1'b1;
        uart_tx_data = ascii[7:0];
        @(posedge clk);
        uart_tx_en = 1'b0;

        #200000 $finish();
  end

  initial begin
        $monitor($time, "clk=%d, led=%b resetn=%d",clk,led0,resetn);
  end

  initial begin
    $dumpfile("build/top_tb.vcd");
    $dumpvars(4,top_tb);
  end
endmodule: top_tb
