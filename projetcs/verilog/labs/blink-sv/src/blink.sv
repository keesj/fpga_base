module blink(
    input  logic clk,
    output logic led
);

  logic [31:0]counter = 32'd0;

  assign led = counter[23];

  always @(posedge clk) begin
        counter <= counter +1;
  end
endmodule: blink