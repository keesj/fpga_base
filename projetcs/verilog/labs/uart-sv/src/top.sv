
// 
// Module: impl_top
// 
// Notes:
// - Top level module to be used in an implementation.
// - To be used in conjunction with the constraints/defaults.xdc file.
// - Ports can be (un)commented depending on whether they are being used.
// - The constraints file contains a complete list of the available ports
//   including the chipkit/Arduino pins.
//

`default_nettype none
module top (
input               clk     , // Top level system clock input.
input   wire        uart_rxd, // UART Recieve pin.
output  wire        uart_txd, // UART transmit pin.
output  wire        led1,
output  wire        led2,
output  wire        led3,
output  wire        led4,
output  wire        led5
);

// Clock frequency in hertz.
parameter CLK_HZ = 12000000;
parameter BIT_RATE =   115200;
parameter PAYLOAD_BITS = 8;

wire resetn;
reg [3:0] rststate = 4'h0;
assign resetn = &rststate;
always @(posedge clk) rststate <= rststate + !resetn;


wire [PAYLOAD_BITS-1:0]  uart_rx_data;
wire        uart_rx_valid;
wire        uart_rx_break;

wire        uart_tx_busy;
logic [PAYLOAD_BITS-1:0]  uart_tx_data;
logic        uart_tx_en;

reg  [PAYLOAD_BITS-1:0]  led_reg;
assign      {led4,led3,led2,led1} = led_reg[3:0];

reg green;
assign led5 = green;

// ------------------------------------------------------------------------- 


always @(posedge clk) begin
    if(!resetn) begin
        led_reg <= 8'hFF;
    end else if(uart_rx_valid) begin
        led_reg <= uart_rx_data[7:0];
    end
end

parameter TX_BUFFER_BYTES = 32 ;
parameter TX_BUFFER = TX_BUFFER_BYTES * 8;

//HEX 
  //reg [7:0] hex[16:0] ="0123456789abcdef";
// TX FIFO
  /* Buffer to store X bytes, where X it a power of 2*/
  reg [TX_BUFFER-1:0] tx_buf;
  reg [8:0] tx_size;

    reg b ;
always @(posedge clk) begin
    uart_tx_en <= 1'b0;
    b <= 1'b0;
    if(!resetn) begin
        tx_size <= 8'h0;
    end else begin 
        if( !uart_tx_busy && !b && tx_size > 0) begin
	   uart_tx_en <= 1'b1;	
           b <= 1'b1; // delay
           uart_tx_data <= tx_buf[TX_BUFFER-1:TX_BUFFER-8];
           tx_buf <= tx_buf<<8;
	   tx_size <= tx_size -1;
        end
           if (tx_size ==0 && uart_rx_valid) begin
	        tx_size <= 8'd13;
                tx_buf[TX_BUFFER-1:TX_BUFFER -(8 * 13)] <= "Hello World\r\n";
           end
    end
end
// ------------------------------------------------------------------------- 


always @(posedge clk) begin
    if(!resetn) begin
        green <= 1;
    end else if(uart_rx_valid) begin
       	green = ~green;
    end
end
//
// UART RX
uart_rx #(
.BIT_RATE(BIT_RATE),
.PAYLOAD_BITS(PAYLOAD_BITS),
.CLK_HZ  (CLK_HZ  )
) i_uart_rx(
.clk          (clk          ), // Top level system clock input.
.resetn       (resetn         ), // Asynchronous active low reset.
.uart_rxd     (uart_rxd     ), // UART Recieve pin.
.uart_rx_en   (1'b1         ), // Recieve enable
.uart_rx_break(uart_rx_break), // Did we get a BREAK message?
.uart_rx_valid(uart_rx_valid), // Valid data recieved and available.
.uart_rx_data (uart_rx_data )  // The recieved data.
);

//
// UART Transmitter module.
//
uart_tx #(
.BIT_RATE(BIT_RATE),
.PAYLOAD_BITS(PAYLOAD_BITS),
.CLK_HZ  (CLK_HZ  )
) i_uart_tx(
.clk          (clk          ),
.resetn       (resetn       ),
.uart_txd     (uart_txd     ),
.uart_tx_en   (uart_tx_en   ),
.uart_tx_busy (uart_tx_busy ),
.uart_tx_data (uart_tx_data ) 
);


endmodule
