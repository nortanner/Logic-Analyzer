`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/17/2026 12:53:10 PM
// Design Name: 
// Module Name: sampler
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


module sampler(
    input clk,
    input [7:0] async_signals,
    output logic [7:0] sync_signals
    );
    
    reg [7:0] sync_stage1;
    
    always_ff @(posedge clk) begin
        sync_stage1 <= async_signals;
        sync_signals <= sync_stage1;
    end
    
endmodule
