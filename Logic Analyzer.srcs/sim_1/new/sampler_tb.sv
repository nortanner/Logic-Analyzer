`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/17/2026 06:49:19 PM
// Design Name: 
// Module Name: sampler_tb
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


module sampler_tb();

    logic clk;
    logic [7:0] async_signals;
    logic [7:0] sync_signals;

    sampler DUT (
        .clk(clk),
        .async_signals(async_signals),
        .sync_signals(sync_signals)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        async_signals = 8'h00;

        #100;
        
        // Apply asynchronous signal
        #3 async_signals = 8'hFF; 
        
        #50;
        
        // Change it again
        #7 async_signals = 8'hAA;

        #100;
        $finish;
    end

endmodule
