`timescale 1ns / 1ps

module TestWrapper(
    );
    
    reg clk;                // square wave, 50% duty cycle, period = 2ns
    reg reset;
    pipelinedCPU #(.FlushAfter(100000)) CeciNestPasUnePipeline(.clk(clk),.reset(reset));
    

initial
begin
    clk = 0;
    reset = 1'b1;
    #2
    reset = 1'b0;
    #250000 $finish;
end

always
begin
    #1 clk = ~clk; 
end
endmodule
