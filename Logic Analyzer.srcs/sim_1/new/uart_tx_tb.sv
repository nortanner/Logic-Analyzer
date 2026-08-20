`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/17/2026 06:14:04 PM
// Design Name: 
// Module Name: uart_tx_tb
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


module uart_tx_tb();

    logic clk;
    logic rst;
    logic [7:0] data_in;
    logic send;
    logic tx;
    logic busy;

    // Instantiate the Device Under Test (DUT)
    uart_tx #(
        .CLK_FREQ(100_000_000),
        .BAUD_RATE(115200)
    ) DUT (
        .clk(clk),
        .rst(rst),
        .data_in(data_in),
        .send(send),
        .tx(tx),
        .busy(busy)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        // Initialize Inputs
        clk = 0;
        rst = 1;
        data_in = 8'h00;
        send = 0;

        #100;
        rst = 0;
        
        // Send byte 0xA5 (10100101)
        #20;
        data_in = 8'hA5;
        send = 1;
        #10;
        send = 0;

        // Wait for transmission to complete
        wait(busy == 1'b1);
        wait(busy == 1'b0);

        #100;
        $finish;
    end

endmodule