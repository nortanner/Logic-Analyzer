`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/17/2026 06:49:19 PM
// Design Name: 
// Module Name: readout_fsm_tb
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


module readout_fsm_tb();

    logic clk;
    logic rst;
    logic trigger_in;
    logic uart_busy;
    logic buffer_write_en;
    logic buffer_read_en;
    logic [9:0] buffer_read_addr;
    logic uart_send;
    
    // Instantiate the Device Under Test (DUT)
    readout_fsm #(
        .DEPTH(1024)
    ) DUT (
        .clk(clk),
        .rst(rst),
        .trigger_in(trigger_in),
        .uart_busy(uart_busy),
        .buffer_write_en(buffer_write_en),
        .buffer_read_en(buffer_read_en),
        .buffer_read_addr(buffer_read_addr),
        .uart_send(uart_send)
    );
    
    // Clock generation
    always #5 clk = ~clk;
    
    // Simulate UART Busy behavior automatically
    always @(posedge clk) begin
        if (rst) begin
            uart_busy <= 1'b0;
        end else if (uart_send) begin
            uart_busy <= 1'b1; // Go busy when send is requested
        end else if (uart_busy) begin
            // Hold busy for a few clock cycles to simulate transmission
            // (Shortened from real 115200 baud speed for faster simulation)
            repeat(20) @(posedge clk); 
            uart_busy <= 1'b0;
        end
    end
    
    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;
        trigger_in = 0;
    
        #100;
        rst = 0;
    
        // Simulate a trigger
        #20;
        trigger_in = 1;
        #10;
        trigger_in = 0;
    
        // Let it run for a bit to see the addresses increment properly
        #5000;
        $finish;
    end

endmodule