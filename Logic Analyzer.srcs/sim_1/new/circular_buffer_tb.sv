`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/17/2026 04:02:44 PM
// Design Name: 
// Module Name: circular_buffer_tb
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


module circular_buffer_tb();

    logic clk;
    logic rst;
    logic write_en;
    logic [7:0] write_data;
    logic read_en;
    logic [9:0] read_addr;
    logic [7:0] read_data;

    // Instantiate the Device Under Test (DUT)
    circular_buffer #(
        .DEPTH(1024)
    ) DUT (
        .clk(clk),
        .rst(rst),
        .write_en(write_en),
        .write_data(write_data),
        .read_en(read_en),
        .read_addr(read_addr),
        .read_data(read_data)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;
        write_en = 0;
        write_data = 8'h00;
        read_en = 0;
        read_addr = 10'd0;

        #100;
        rst = 0;
        
        // Test Case 1: Write 16 values
        write_en = 1;
        for (int i = 0; i < 16; i++) begin
            write_data = i[7:0];
            #10;
        end
        write_en = 0;
        
        // Test Case 2: Read back the 16 values
        read_en = 1;
        for (int i = 0; i < 16; i++) begin
            read_addr = i[9:0];
            #10;
        end
        read_en = 0;

        #100;
        $finish;
    end

endmodule