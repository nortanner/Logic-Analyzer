`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/17/2026 01:38:15 PM
// Design Name: 
// Module Name: readout_fsm
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


module readout_fsm #(
    parameter DEPTH = 1024
)(
    input logic clk,
    input logic rst,
    input logic trigger_in,
    input logic uart_busy,
    output logic buffer_write_en,
    output logic buffer_read_en,
    output logic [$clog2(DEPTH)-1:0] buffer_read_addr,
    output logic uart_send
);

    typedef enum logic [1:0] {
        IDLE,
        READ,
        SEND,
        WAIT_UART
    } state_t;

    state_t state;
    logic [$clog2(DEPTH)-1:0] addr_count;

    always_ff @(posedge clk) begin
        if (rst) begin
            state <= IDLE;
            buffer_write_en <= 1'b1;
            buffer_read_en <= 1'b0;
            buffer_read_addr <= '0;
            uart_send <= 1'b0;
            addr_count <= '0;
        end else begin
            case (state)
                IDLE: begin
                    if (trigger_in) begin
                        buffer_write_en <= 1'b0; // Stop recording
                        state <= READ;
                    end
                end

                READ: begin
                    buffer_read_en <= 1'b1;
                    buffer_read_addr <= addr_count;
                    state <= SEND;
                end

                SEND: begin
                    buffer_read_en <= 1'b0;
                    uart_send <= 1'b1;       // Start UART transmission
                    state <= WAIT_UART;
                end

                WAIT_UART: begin
                    uart_send <= 1'b0;
                    if (!uart_busy) begin    // Wait for UART to finish
                        if (addr_count == DEPTH - 1) begin
                            state <= IDLE;   // Done with all samples
                            buffer_write_en <= 1'b1; // Resume recording
                            addr_count <= '0;
                        end else begin
                            addr_count <= addr_count + 1'b1;
                            state <= READ;   // Next sample
                        end
                    end
                end
            endcase
        end
    end

endmodule
