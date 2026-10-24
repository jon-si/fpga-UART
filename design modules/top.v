`timescale 1ns / 1ps

module top(
    input wire clk,
    input wire rst,
    input wire send,
    input wire [7:0] data,
    input wire uart_rx,
    
    output wire [7:0] led,
    output wire uart_tx
    );
    
    wire rst_db, send_db; 
    
    debouncer db_rst (
        .clk(clk),
        .btn(rst),
        .db_btn(rst_db)
    );
    
    debouncer db_send (
        .clk(clk),
        .btn(send),
        .db_btn(send_db)
    );
    
    tx transmit (
        .clk(clk),
        .db_send(send_db),
        .rst(rst_db), 
        .data(data),
        .tx_line(uart_tx)
    );
    
    rx recieve (
        .clk(clk),
        .rst(rst_db),
        .rx_line(uart_rx),
        .led(led)
    );
endmodule
