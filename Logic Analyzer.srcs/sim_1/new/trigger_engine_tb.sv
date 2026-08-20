`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/17/2026 03:39:21 PM
// Design Name: 
// Module Name: trigger_engine_tb
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




module trigger_engine_tb();

    logic clk;
    logic rst;
    logic [7:0] data_in;
    logic [2:0] trigger_channel;
    logic [1:0] trigger_mode;
    logic trigger_out;

    // Instantiate the Device Under Test (DUT)
    trigger_engine DUT (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .trigger_channel(trigger_channel),
        .trigger_mode(trigger_mode),
        .trigger_out(trigger_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        data_in = 8'h00;
        trigger_channel = 3'd0;
        trigger_mode = 2'b00;

        #100;
        rst = 0;
        
        for (int ch = 0; ch < 8; ch++) begin
            trigger_channel = ch[2:0];
            
            // Test Mode 00: Rising Edge
            trigger_mode = 2'b00;
            #20 data_in[ch] = 1'b1; 
            #20 data_in[ch] = 1'b0;
            #10 rst = 1; #10 rst = 0; // Reset for next test
            
            // Test Mode 01: Falling Edge
            trigger_mode = 2'b01;
            data_in[ch] = 1'b1;
            #20 data_in[ch] = 1'b0; 
            #10 rst = 1; #10 rst = 0;
            
            // Test Mode 10: Level High
            trigger_mode = 2'b10;
            data_in[ch] = 1'b1;     
            #20 data_in[ch] = 1'b0;
            #10 rst = 1; #10 rst = 0;
            
            // Test Mode 11: Level Low
            trigger_mode = 2'b11; 
            #20;
            #10 rst = 1; #10 rst = 0;
        end

        #100;
        $finish;
    end

endmodule
