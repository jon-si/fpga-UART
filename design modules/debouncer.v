`timescale 1ns / 1ps

module debouncer(
    input wire clk,
    input wire btn,
    
    output reg db_btn
    );
    
    reg[7:0] debounce_btn = 0;
    
    always @(posedge clk) begin
        debounce_btn <= {debounce_btn[6:0], btn};
        db_btn <= &debounce_btn;
    end
endmodule
