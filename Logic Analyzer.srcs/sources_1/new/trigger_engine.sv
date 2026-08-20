`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/17/2026 01:23:48 PM
// Design Name: 
// Module Name: trigger_engine
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


module trigger_engine (
    input logic clk,
    input logic rst,
    input logic [7:0] data_in,
    input logic [2:0] trigger_channel, 
    input logic [1:0] trigger_mode,     // 00: Rising, 01: Falling, 10: High, 11: Low
    output logic trigger_out
);

    logic [7:0] data_prev;

    always_ff @(posedge clk) begin
        if (rst) begin
            data_prev <= '0;
            trigger_out <= 1'b0;
        end else begin
            data_prev <= data_in;
            
            case (trigger_mode)
                2'b00: begin // Rising Edge
                    if (!data_prev[trigger_channel] && data_in[trigger_channel])
                        trigger_out <= 1'b1;
                end
                2'b01: begin // Falling Edge
                    if (data_prev[trigger_channel] && !data_in[trigger_channel])
                        trigger_out <= 1'b1;
                end
                2'b10: begin // Level High
                    if (data_in[trigger_channel])
                        trigger_out <= 1'b1;
                end
                2'b11: begin // Level Low
                    if (!data_in[trigger_channel])
                        trigger_out <= 1'b1;
                end
            endcase
        end
    end

endmodule
