`default_nettype none

module dut (
  input wire clk,
  input wire [127:0] key,
  input wire [127:0] input_data,
  output reg[127:0] output_data
  );

  always @(posedge clk) begin
    output_data = key ^ input_data;
  end

endmodule

module tb;

  reg clk;

  reg [7:0] group;
  reg [127:0] mask;
  reg [127:0] key;
  reg [127:0] input_data;
  reg [127:0] expected_output;
  wire [127:0] actual_output;

  integer file;
  integer r;

  initial begin
    clk = 1'b0;
  end

  always   #5 clk = ~clk; //10ns 

  dut uut (
    .clk,
    .key(key),
    .input_data(input_data),
    .output_data(actual_output)
  );

  // Task to read a single line from the file
  task read_line;
    input integer file;
    output reg [7:0] group;
    output reg [127:0] mask;
    output reg [127:0] key;
    output reg [127:0] input_data;
    output reg [127:0] expected_output;
    begin
      r = $fscanf(file, "%x,%x,%x,%x,%x\n",group,mask, key, input_data, expected_output);
      $display(r);
    end
  endtask

  initial begin
    // Open the file
    file = $fopen("test_data.csv", "r");
    if (file == 0) begin
      $display("Failed to open file.");
      $finish;
    end

    // Skip the header line
    //r = $fgets(file);

    // Read and apply test vectors
    while (!$feof(file)) begin
      read_line(file,group,mask, key, input_data, expected_output);

      if (r == 0) begin
        $finish();
      end
      // Apply inputs
      //uut.key = key;
      //uut.input_data = input_data;
      #10;  // Allow some time for the DUT to process

      // Check the output
      if (actual_output !== expected_output) begin
        $display("Mismatch: key=%b input_data=%b expected_output=%b actual_output=%b", key, input_data, expected_output, actual_output);
      end else begin
        $display("Match: key=%b input_data=%b expected_output=%b actual_output=%b", key, input_data, expected_output, actual_output);
      end
    end

    // Close the file
    $fclose(file);
    $finish;
  end

endmodule

