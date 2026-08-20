`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/17/2026 03:15:55 PM
// Design Name: 
// Module Name: display_controller
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


module display_controller (
    input logic clk,
    input logic rst,
    input logic [1:0] trigger_mode,    // 00: Rise, 01: Fall, 10: High, 11: Low
    input logic [2:0] trigger_channel, // 0 to 7
    output logic [6:0] seg,            // Segments A-G
    output logic [3:0] an              // Anodes for the 4 digits
);

    // Refresh counter for multiplexing (approx. 1kHz)
    logic [16:0] refresh_counter;
    logic [1:0] active_digit;
    
    always_ff @(posedge clk) begin
        if (rst) refresh_counter <= '0;
        else refresh_counter <= refresh_counter + 1'b1;
    end
    
    assign active_digit = refresh_counter[16:15];
    
    // Anode selection (Active Low)
    always_comb begin
        an = 4'b1111; // Default all off
        case (active_digit)
            2'b00: an[0] = 1'b0; // Rightmost: Channel Number
            2'b01: an[1] = 1'b1; // Second from right: Blank
            2'b10: an[2] = 1'b0; // Second from left: Waveform Right
            2'b11: an[3] = 1'b0; // Leftmost: Waveform Left
        endcase
    end
    
    // Segment decoding (Active Low)
    always_comb begin
        seg = 7'b1111111; // Default off
        
        case (active_digit)
            2'b00: begin // Display Channel Number (0-7)
                case (trigger_channel)
                    3'd0: seg = 7'b1000000;
                    3'd1: seg = 7'b1111001;
                    3'd2: seg = 7'b0100100;
                    3'd3: seg = 7'b0110000;
                    3'd4: seg = 7'b0011001;
                    3'd5: seg = 7'b0010010;
                    3'd6: seg = 7'b0000010;
                    3'd7: seg = 7'b1111000;
                    default: seg = 7'b1111111;
                endcase
            end
            
            2'b10: begin // Waveform Right (Anode 2)
                case (trigger_mode)
                    2'b00: seg = 7'b1001110; // Rising: Left (E,F) + Top (A)
                    2'b01: seg = 7'b1000111; // Falling: Left (E,F) + Bottom (D)
                    2'b10: seg = 7'b1111110; // High: Top segment (A)
                    2'b11: seg = 7'b1110111; // Low: Bottom segment (D)
                endcase
            end
            
            2'b11: begin // Waveform Left (Anode 3)
                case (trigger_mode)
                    2'b00: seg = 7'b1110111; // Rising: Bottom segment (D)
                    2'b01: seg = 7'b1111110; // Falling: Top segment (A)
                    2'b10: seg = 7'b1111110; // High: Top segment (A)
                    2'b11: seg = 7'b1110111; // Low: Bottom segment (D)
                endcase
            end
            
            default: seg = 7'b1111111; // Blank digit
        endcase
    end

endmodule
