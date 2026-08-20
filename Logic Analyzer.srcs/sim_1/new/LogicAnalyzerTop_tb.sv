`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/17/2026 08:34:04 PM
// Design Name: 
// Module Name: LogicAnalyzerTop_tb
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


module LogicAnalyzerTop_tb(

    );
    
    logic clk;
    logic btnC;
    logic [3:0] JA;
    logic [3:0] JB;
    logic RsRx;
    logic RsTx;
    logic [7:0] led;
    logic [6:0] seg;
    logic [3:0] an;
    
    // Instantiate the Device Under Test (DUT)
    LogicAnalyzerTop DUT (
        .clk(clk),
        .btnC(btnC),
        .JA(JA),
        .JB(JB),
        .RsRx(RsRx),
        .RsTx(RsTx),
        .led(led),
        .seg(seg),
        .an(an)
    );
    
    // 100 MHz Clock Generation
    always #5 clk = ~clk;
    
    // Task to send a byte over UART
    task send_uart_byte(input logic [7:0] data);
        integer i;
        begin
            RsRx = 0; #8680; // Start bit
            for (i = 0; i < 8; i = i + 1) begin
                RsRx = data[i]; #8680;
            end
            RsRx = 1; #8680; // Stop bit
        end
    endtask
    
    // Task to reset the system
    task reset_system();
        begin
            btnC = 1;
            #100;
            btnC = 0;
            #1000;
        end
    endtask
    
    initial begin
        // Initialize Inputs
        clk = 0; btnC = 1; JA = 4'h0; JB = 4'h0; RsRx = 1;
    
        // Test Case 1: Rising Edge on Channel 0
        reset_system();
        send_uart_byte(8'h00); // Mode 0, Channel 0
        #10000;
        JA[0] = 1'b1; 
        #20000;
        JA[0] = 1'b0;
    
        // Test Case 2: Falling Edge on Channel 1
        reset_system();
        send_uart_byte(8'h05); // Mode 1, Channel 1
        #10000;
        JA[1] = 1'b1;
        #20;
        JA[1] = 1'b0; // Falling edge
        #20000;
    
        // Test Case 3: Level High on Channel 2
        reset_system();
        send_uart_byte(8'h0A); // Mode 2, Channel 2
        #10000;
        JA[2] = 1'b1; // High level
        #20000;
        JA[2] = 1'b0;
    
        $finish;
    end
endmodule
