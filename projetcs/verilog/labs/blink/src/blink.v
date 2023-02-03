module blink(
    input clk,
    output  led
);

  reg [31:0]counter;
  initial counter = 32'd0;

  assign led = counter[21];

  always @(posedge clk) begin
        counter <= counter +1;
  end
endmodule