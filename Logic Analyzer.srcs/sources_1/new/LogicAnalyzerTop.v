`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/15/2026 09:29:39 PM
// Design Name: 
// Module Name: LogicAnalyzerTop
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


module LogicAnalyzerTop(

    input logic clk,
    input logic btnC,           // Reset
    input logic [3:0] JA,       // Pmod inputs
    input logic [3:0] JB,
    input logic RsRx,           // UART Receive
    output logic RsTx,          // UART Transmit
    output logic [7:0] led,     // Status LEDs
    output logic [6:0] seg,     // 7-Segment Display
    output logic [3:0] an       // 7-Segment Anodes
    
    );
    
    // Internal Signals
    logic [7:0] async_signals;
    logic [7:0] sync_signals;
    logic trigger_out;
    logic uart_busy;
    logic buffer_write_en;
    logic buffer_read_en;
    logic [9:0] buffer_read_addr;
    logic [7:0] buffer_read_data;
    logic uart_send;
    
    // Dynamic Trigger Settings
    logic [1:0] trigger_mode;
    logic [2:0] trigger_channel;
    logic [7:0] rx_data;
    logic rx_ready;
    
    // Combine Pmod inputs
    assign async_signals = {JB, JA};
    assign led = sync_signals; // Mirror inputs to LEDs
    
    // UART Receiver
    uart_rx rx_inst (
        .clk(clk),
        .rst(btnC),
        .rx(RsRx),
        .data_out(rx_data),
        .data_ready(rx_ready)
    );
    
    // Update Trigger Settings on UART Command
    always_ff @(posedge clk) begin
        if (btnC) begin
            trigger_mode <= 2'b00;
            trigger_channel <= 3'd0;
        end else if (rx_ready) begin
            trigger_mode <= rx_data[1:0];
            trigger_channel <= rx_data[4:2];
        end
    end
    
    // 1. Sampler
    sampler sampler_inst (
        .clk(clk),
        .async_signals(async_signals),
        .sync_signals(sync_signals)
    );
    
    // 2. Circular Buffer
    circular_buffer #(
        .DEPTH(1024)
    ) buffer_inst (
        .clk(clk),
        .rst(btnC),
        .write_en(buffer_write_en),
        .write_data(sync_signals),
        .read_en(buffer_read_en),
        .read_addr(buffer_read_addr),
        .read_data(buffer_read_data)
    );
    
    // 3. Trigger Engine
    trigger_engine trigger_inst (
        .clk(clk),
        .rst(btnC),
        .data_in(sync_signals),
        .trigger_channel(trigger_channel),
        .trigger_mode(trigger_mode),
        .trigger_out(trigger_out)
    );
    
    // 4. Readout FSM
    readout_fsm #(
        .DEPTH(1024)
    ) fsm_inst (
        .clk(clk),
        .rst(btnC),
        .trigger_in(trigger_out),
        .uart_busy(uart_busy),
        .buffer_write_en(buffer_write_en),
        .buffer_read_en(buffer_read_en),
        .buffer_read_addr(buffer_read_addr),
        .uart_send(uart_send)
    );
    
    // 5. UART Transmitter
    uart_tx uart_inst (
        .clk(clk),
        .rst(btnC),
        .data_in(buffer_read_data),
        .send(uart_send),
        .tx(RsTx),
        .busy(uart_busy)
    );
    
    // 6. Display Controller
    display_controller display_inst (
        .clk(clk),
        .rst(btnC),
        .trigger_mode(trigger_mode),
        .trigger_channel(trigger_channel),
        .seg(seg),
        .an(an)
    );
    
endmodule
