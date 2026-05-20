`timescale 1ns / 1ps


module MainMemory(
    input clk,
    input [31:0] IMEM_Read_Address,
    output [63:0] IMEM_Read_Data,
    input IMEM_Read_ctrl,
    input [31:0] DMEM_Read_Address,
    output [63:0] DMEM_Read_Data,
    input DMEM_Read_ctrl,
    input [31:0] DMEM_Write_Address,
    input [63:0] DMEM_Write_Data,
    input DMEM_Write_ctrl
    );

    reg [7:0] MEMCONTENTS [65535:0];

    wire [15:0] IADDR16;
    assign IADDR16={IMEM_Read_Address[15:3],3'b000};
    wire [15:0] DADDR16_r;
    assign DADDR16_r={DMEM_Read_Address[15:3],3'b000};
    wire [15:0] DADDR16_w;
    assign DADDR16_w={DMEM_Write_Address[15:3],3'b000};
   
    wire [63:0] D_zv;
    assign D_zv = 64'h0;
    wire [63:0] I_zv;
    assign I_zv = 64'h0;

    assign IMEM_Read_Data = (IMEM_Read_ctrl)?
    {MEMCONTENTS[IADDR16|3'b000],
    MEMCONTENTS[IADDR16|3'b001],
    MEMCONTENTS[IADDR16|3'b010],
    MEMCONTENTS[IADDR16|3'b011],
    MEMCONTENTS[IADDR16|3'b100],
    MEMCONTENTS[IADDR16|3'b101],
    MEMCONTENTS[IADDR16|3'b110],
    MEMCONTENTS[IADDR16|3'b111]}
    :I_zv;
    assign DMEM_Read_Data = (DMEM_Read_ctrl)?
    {MEMCONTENTS[DADDR16_r|3'b000],
    MEMCONTENTS[DADDR16_r|3'b001],
    MEMCONTENTS[DADDR16_r|3'b010],
    MEMCONTENTS[DADDR16_r|3'b011],
    MEMCONTENTS[DADDR16_r|3'b100],
    MEMCONTENTS[DADDR16_r|3'b101],
    MEMCONTENTS[DADDR16_r|3'b110],
    MEMCONTENTS[DADDR16_r|3'b111]}
    :D_zv;
    
    always@(posedge clk)
    begin
    if (DMEM_Write_ctrl)
        begin
        MEMCONTENTS[DADDR16_w|3'b000] <= DMEM_Write_Data[63:56];
        MEMCONTENTS[DADDR16_w|3'b001] <= DMEM_Write_Data[55:48];
        MEMCONTENTS[DADDR16_w|3'b010] <= DMEM_Write_Data[47:40];
        MEMCONTENTS[DADDR16_w|3'b011] <= DMEM_Write_Data[39:32];
        MEMCONTENTS[DADDR16_w|3'b100] <= DMEM_Write_Data[31:24];
        MEMCONTENTS[DADDR16_w|3'b101] <= DMEM_Write_Data[23:16];
        MEMCONTENTS[DADDR16_w|3'b110] <= DMEM_Write_Data[15:8];
        MEMCONTENTS[DADDR16_w|3'b111] <= DMEM_Write_Data[7:0];
        end
    end

initial
begin
    $readmemh("mem.mem",MEMCONTENTS);
end  
endmodule

module JohnnyMnemonic(
    input clk,
    input [31:0] IMEM_Read_Address,
    output [31:0] IMEM_Read_Data,
    input IMEM_Read_ctrl,
    input [31:0] DMEM_Read_Address,
    output [31:0] DMEM_Read_Data,
    input DMEM_Read_ctrl,
    input [31:0] DMEM_Write_Address,
    input [31:0] DMEM_Write_Data,
    input DMEM_Write_ctrl
    );

    reg [7:0] MEMCONTENTS [65535:0];

    wire [15:0] IADDR16;
    assign IADDR16={IMEM_Read_Address[15:2],2'b00};
    wire [15:0] DADDR16_r;
    assign DADDR16_r={DMEM_Read_Address[15:2],2'b00};
    wire [15:0] DADDR16_w;
    assign DADDR16_w={DMEM_Write_Address[15:2],2'b00};
   
    wire [31:0] D_zv;
    assign D_zv = 32'h0;
    wire [31:0] I_zv;
    assign I_zv = 32'h0;

    assign IMEM_Read_Data = (IMEM_Read_ctrl)?
    {MEMCONTENTS[IADDR16|2'b00],
    MEMCONTENTS[IADDR16|2'b01],
    MEMCONTENTS[IADDR16|2'b10],
    MEMCONTENTS[IADDR16|2'b11]}
    :I_zv;
    assign DMEM_Read_Data = (DMEM_Read_ctrl)?
    {MEMCONTENTS[DADDR16_r|2'b00],
    MEMCONTENTS[DADDR16_r|2'b01],
    MEMCONTENTS[DADDR16_r|2'b10],
    MEMCONTENTS[DADDR16_r|2'b11]}
    :D_zv;
    
    always@(posedge clk)
    begin
    if (DMEM_Write_ctrl)
        begin
        MEMCONTENTS[DADDR16_w|2'b00] <= DMEM_Write_Data[31:24];
        MEMCONTENTS[DADDR16_w|2'b01] <= DMEM_Write_Data[23:16];
        MEMCONTENTS[DADDR16_w|2'b10] <= DMEM_Write_Data[15:8];
        MEMCONTENTS[DADDR16_w|2'b11] <= DMEM_Write_Data[7:0];
        end
    end

initial
begin
    $readmemh("mem.mem",MEMCONTENTS);
end  
endmodule

