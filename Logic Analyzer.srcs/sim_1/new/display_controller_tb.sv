`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/17/2026 06:49:19 PM
// Design Name: 
// Module Name: display_controller_tb
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


module display_controller_tb();

    logic clk;
    logic rst;
    logic [1:0] trigger_mode;
    logic [2:0] trigger_channel;
    logic [6:0] seg;
    logic [3:0] an;

    display_controller DUT (
        .clk(clk),
        .rst(rst),
        .trigger_mode(trigger_mode),
        .trigger_channel(trigger_channel),
        .seg(seg),
        .an(an)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        rst = 1;
        trigger_mode = 2'b00;
        trigger_channel = 3'd0;

        #100;
        rst = 0;

        // Loop through all modes
        for (int i = 0; i < 4; i++) begin
            trigger_mode = i[1:0];
            trigger_channel = i[2:0]; // Just varying the channel as well
            #200000; // Wait long enough to see multiplexing (refresh counter)
        end

        #100;
        $finish;
    end

endmodule