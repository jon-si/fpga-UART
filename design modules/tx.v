`timescale 1ns / 1ps

module tx(
    input wire clk,
    input wire db_send,
    input wire rst,
    input wire [7:0] data,
    
    output reg tx_line
    );
    
    localparam IDLE = 2'd0;
    localparam START = 2'd1;
    localparam DATA = 2'd2;
    localparam STOP = 2'd3;
    
    reg [1:0] state;
    reg [7:0] data_reg;
    reg [2:0] bit_idx;
    wire baud_clk;
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
           bit_idx <= 3'b0;
           tx_line <= 8'b1; 
           busy = 0;
        end else begin
            case (state)
                IDLE: begin
                    tx_line <= 8'b1;
                    if (db_send) begin
                        data_reg <= data;
                        bit_idx <= 3'b0;
                        state <= START;
                        busy <= 1;
                    end
                end
                                
                START: begin
                    if (baud_clk) begin
                        tx_line <= 8'b0;
                        state <= DATA;
                    end
                end
                
                DATA: begin
                    if (baud_clk) begin
                        if (bit_idx == 3'd7) begin
                            state <= STOP;
                        end
                        tx_line <= data_reg[bit_idx];
                        bit_idx <= bit_idx + 1;
                    end
                end
                
                STOP: begin
                    if (baud_clk) begin
                        tx_line <= 8'b1;
                        state <= IDLE;
                        busy <= 0;
                    end
                end
                
                default: begin
                    state <= IDLE;
                    tx_line <= 8'b1;
                end
            endcase
        end
    end
endmodule
