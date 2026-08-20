`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/17/2026 01:19:31 PM
// Design Name: 
// Module Name: circular_buffer
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


module circular_buffer #(
    parameter DEPTH = 1024,
    parameter WIDTH = 8
)(
    input logic clk,
    input logic rst,
    input logic write_en,
    input logic [WIDTH-1:0] write_data,
    input logic read_en,
    input logic [$clog2(DEPTH)-1:0] read_addr,
    output logic [WIDTH-1:0] read_data
);

    // Memory array
    logic [WIDTH-1:0] mem [0:DEPTH-1];
    
    // Write pointer
    logic [$clog2(DEPTH)-1:0] write_ptr;
    
    // Write logic
    always_ff @(posedge clk) begin
        if (rst) begin
            write_ptr <= '0;
        end else if (write_en) begin
            mem[write_ptr] <= write_data;
            write_ptr <= write_ptr + 1'b1;
        end
    end
    
    // Read logic
    always_ff @(posedge clk) begin
        if (read_en) begin
            read_data <= mem[read_addr];
        end
    end

endmodule
