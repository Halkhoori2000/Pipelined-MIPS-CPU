`timescale 1ns / 1ps

module DummyBypassICACHE(    
    input [31:0] Address,
    input clk,
    output [31:0] InstBits,
    output Ready,
    output IFill,
    output [31:0] IFill_Address,
    input [31:0] Fill_Contents
    );
    assign Ready = 1'b1;
    assign IFill_Address = Address;
    assign IFill = 1'b1;
    assign InstBits = Fill_Contents;
    
endmodule

module ICACHE(
    input [31:0] Address,
    input clk,
    output reg [31:0] InstBits,
    output Ready,
    output IFill,
    output [31:0] IFill_Address,
    input [63:0] Fill_Contents
    );
    
    // 2KB Direct mapped, block size 64 byte
    // 2^11 bytes / 2^ 6 bytes = 2^5 sets
    // Block = 64 bytes ==> BO = 6 bits Address [5:0]
    // Set index lg2(#sets) ==> 5 bits Address [10:6]
    // Tag size = Address size - block bits - index bits = 32 - 6 -5 ==>Address[31:11]
    
    reg [2:0] FillIndex;
    reg Filling;
    
    reg [31:0] InitiatedFillAddress;
    
    reg [0:0] Valid[31:0]; // Valid bits for each cache block
 
integer i;    
initial
begin
// set all cache blocks to invalid
for (i=0; i<32; i=i+1) Valid[i]=1'b0;
FillIndex = 3'b000;
Filling=1'b0;
InitiatedFillAddress=32'b0;
end    

endmodule
