`timescale 10ns/1ns

module blink_tb;
  logic clk = 1'b0;
  wire led;

  blink blink0(
    .clk(clk),
    .led(led));

  always #1 clk=~clk;

  initial begin
        #10000
        #20 $finish();
  end

  initial begin
    $monitor($time, "clk=%d, led=%b",clk,led);
  end
  initial begin
    $dumpfile("build/blink_tb.vcd");
    $dumpvars(1,blink0);
  end
endmodule: blink_tb