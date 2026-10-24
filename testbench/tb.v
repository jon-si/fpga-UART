`timescale 1ns / 1ps

module tb();
    reg clk, rst, send;
    reg [7:0] data;
  
    
    wire [7:0] led;
    wire uart_tx, uart_rx;

    top UUT (
        .clk(clk),
        .rst(rst),
        .send(send),
        .data(data),
        .uart_rx(uart_rx),
        .led(led),
        .uart_tx(uart_tx)
    );
    
    always #5 clk = ~clk;
    assign uart_rx = uart_tx;
    
    initial begin
        $display("TESTBENCH START");
        clk = 0;
        rst = 1;
        #80;
        rst = 0;
        
        data = 8'b01010101;
        send = 1;
        #80
        send = 0;   
        
        #100
        data = 8'b11111111;
        send = 1;
        #80
        send = 0;
        #200
        
        if(led == 8'b01010101) $display("Success");
        else $error("Fail: %d", led);
        
        rst = 1;
        #100;    
        rst = 0;
        if(led == 8'b00000000) $display("Reset success");
        else $error("Fail");
        #100
        $finish;
   end
endmodule
