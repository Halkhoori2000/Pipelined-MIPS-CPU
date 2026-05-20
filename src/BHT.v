`timescale 1ns / 1ps

module BHT(
    input clk,
    input [31:0] PC,
    output Prediction,
    input DoUpdate,
    input [31:0] UpdatePC,
    input UpdateDirection
    );
    
    integer i;
    initial
    begin
    for (i=0; i<2048; i=i+1) HTable[i] <= 2'b10;
    end 


    // 2K entry array of 2-bit saturating counters      
    wire [10:0] FetchIndex;
    wire [10:0] UpdateIndex;
    
    reg [1:0] HTable [2047:0];

    assign FetchIndex = PC[12:2];
    assign UpdateIndex = UpdatePC[12:2];
    assign Prediction = HTable[FetchIndex][1];
 
    always @ (posedge clk) begin
        if (DoUpdate) begin
            if (!UpdateDirection) begin
                if (HTable[UpdateIndex] == 2'b00) begin
                    HTable[UpdateIndex] = 2'b00;
                end
                else begin
                    HTable[UpdateIndex] =  HTable[UpdateIndex] - 1;
                end
            end
            else begin
                if (HTable[UpdateIndex] == 2'b11) begin
                    HTable[UpdateIndex] = 2'b11;
                end
                else begin
                    HTable[UpdateIndex] = HTable[UpdateIndex] + 1;
                end
            end
        end
        else begin
            HTable[UpdateIndex] = HTable[UpdateIndex];
        end
    end
    
endmodule