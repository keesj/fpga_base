module blink(
    input clk,
    output reg led
);
  initial led =  1'b0;

  always @(posedge clk) begin
        led <= ~led;
  end
endmodule