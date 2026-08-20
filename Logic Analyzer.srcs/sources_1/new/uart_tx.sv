`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/17/2026 01:33:38 PM
// Design Name: 
// Module Name: uart_tx
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module uart_tx #(
    parameter CLK_FREQ = 100_000_000,
    parameter BAUD_RATE = 115200
)(
    input logic clk,
    input logic rst,
    input logic [7:0] data_in,
    input logic send,
    output logic tx,
    output logic busy
);

    localparam BIT_TIME = CLK_FREQ / BAUD_RATE;

    logic [$clog2(BIT_TIME)-1:0] clk_count;
    logic [3:0] bit_index;
    logic [9:0] shift_reg; // 1 start bit + 8 data bits + 1 stop bit
    
    always_ff @(posedge clk) begin
        if (rst) begin
            tx <= 1'b1; // Idle high
            busy <= 1'b0;
            clk_count <= '0;
            bit_index <= '0;
            shift_reg <= '1;
        end else if (!busy && send) begin
            // Load the shift register: {Stop, Data, Start}
            shift_reg <= {1'b1, data_in, 1'b0};
            busy <= 1'b1;
            clk_count <= '0;
            bit_index <= '0;
        end else if (busy) begin
            tx <= shift_reg[0];
            
            if (clk_count == BIT_TIME - 1) begin
                clk_count <= '0;
                shift_reg <= {1'b1, shift_reg[9:1]}; // Shift right
                
                if (bit_index == 9) begin
                    busy <= 1'b0; // Transmission complete
                end else begin
                    bit_index <= bit_index + 1'b1;
                end
            end else begin
                clk_count <= clk_count + 1'b1;
            end
        end
    end

endmodule
