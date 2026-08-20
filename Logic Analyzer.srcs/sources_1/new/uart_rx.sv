`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/18/2026 10:41:17 AM
// Design Name: 
// Module Name: uart_rx
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


module uart_rx #(
    parameter CLK_FREQ = 100_000_000,
    parameter BAUD_RATE = 115200
)(
    input logic clk,
    input logic rst,
    input logic rx,
    output logic [7:0] data_out,
    output logic data_ready
);


    localparam BIT_TIME = CLK_FREQ / BAUD_RATE;
    
    logic [$clog2(BIT_TIME)-1:0] clk_count;
    logic [2:0] bit_index;
    logic [7:0] shift_reg;
    
    typedef enum logic [1:0] {
        IDLE,
        START_BIT,
        DATA_BITS,
        STOP_BIT
    } state_t;
    
    state_t state;
    
    always_ff @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            clk_count <= '0;
            bit_index <= '0;
            data_ready <= 1'b0;
            data_out <= '0;
            shift_reg <= '0;
        end else begin
            data_ready <= 1'b0; // Default pulse low
            
            case (state)
                IDLE: begin
                    if (rx == 1'b0) begin // Start bit detected
                        state <= START_BIT;
                        clk_count <= '0;
                    end
                end
                
                START_BIT: begin
                    if (clk_count == (BIT_TIME / 2) - 1) begin
                        if (rx == 1'b0) begin // Confirm start bit
                            state <= DATA_BITS;
                            clk_count <= '0;
                            bit_index <= '0;
                        end else begin
                            state <= IDLE; // False start
                        end
                    end else begin
                        clk_count <= clk_count + 1'b1;
                    end
                end
                
                DATA_BITS: begin
                    if (clk_count == BIT_TIME - 1) begin
                        clk_count <= '0;
                        shift_reg <= {rx, shift_reg[7:1]}; // Shift right
                        
                        if (bit_index == 7) begin
                            state <= STOP_BIT;
                        end else begin
                            bit_index <= bit_index + 1'b1;
                        end
                    end else begin
                        clk_count <= clk_count + 1'b1;
                    end
                end
                
                STOP_BIT: begin
                    if (clk_count == BIT_TIME - 1) begin
                        data_out <= shift_reg;
                        data_ready <= 1'b1;
                        state <= IDLE;
                    end else begin
                        clk_count <= clk_count + 1'b1;
                    end
                end
            endcase
        end
    end
endmodule
