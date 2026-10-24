`timescale 1ns / 1ps

module rx(
    input wire clk,
    input wire rst,
    input wire rx_line,
    
    output reg [7:0] led
    );
    
    localparam IDLE = 2'd0;
    localparam START = 2'd1;
    localparam DATA = 2'd2;
    localparam STOP = 2'd3;
    
    wire baud_clk;
    reg [7:0] data_reg;
    reg [2:0] counter;
    reg [1:0] state;
    reg busy;
    
    baud_gen baud_tx(
        .clk(clk),
        .rst(rst),
        .enable(busy),
        .baud_clk(baud_clk)
    );
    
    always @(posedge clk) begin
        if (rst) begin
           state <= IDLE;
           data_reg <= 8'b0;
           counter <= 3'b0;
           busy <= 0;
           led <= 8'd0;
        end else begin
            case (state)
                IDLE: begin
                    if (rx_line == 0) begin
                        counter <= 3'b0;
                        state <= DATA;
                        busy <= 1;
                    end
                end
                
                DATA: begin
                    if (baud_clk) begin
                        if (counter == 3'd7) begin
                            state <= STOP;
                        end
                        data_reg[counter] <= rx_line;
                        counter <= counter + 1;
                    end
                end
                
                STOP: begin
                    if (baud_clk) begin
                        state <= IDLE;
                        busy <= 0;
                        led <= data_reg;
                    end
                end
                
                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end
    
endmodule
