`timescale 1ns / 1ps

module baud_gen(
    input wire clk,
    input wire rst,
    input wire enable,
    output reg baud_clk
    );
    
    localparam integer clk_freq = 100_000_000;
    localparam integer baud_rate = 9600;
//    localparam integer baud_rate = 50_000_000; //testing baud rate: 20 ns pulse
    
    localparam integer divisor = (clk_freq + baud_rate/2) / baud_rate;
    localparam integer counter_width = (divisor <= 1) ? 1 : $clog2(divisor); 
    
    reg [counter_width-1:0] counter;
    always @(posedge clk) begin
        if (rst) begin
           counter <= 0; 
           baud_clk <= 0; 
        end else if (!enable) begin
            counter <= 0;
            baud_clk <= 0;        
        end else begin
            if (counter == divisor - 1) begin
                counter <= 0;
                baud_clk <= 1;
            end else begin
                counter <= counter + 1'b1;
                baud_clk <= 0;
            end
        end        
    end
endmodule
