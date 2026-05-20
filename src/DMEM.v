`timescale 1ns / 1ps

module DummyBypassDCACHE(
    input [31:0] Address,
    input [31:0] SValue,
    output [31:0] RValue,
    output Ready,
    input ReadMem,
    input WriteMem,
    input LBU,
    input ByteOp,
    input clk,
    output DFill,
    output [31:0] DFill_Address,
    input [31:0] Fill_Contents,
    output WriteBack,
    output [31:0] WB_Address,
    output [31:0] WB_Value    
    );
    assign Ready = 1'b1;
    assign WriteBack = WriteMem;
    assign DFill_Address = Address;
    assign WB_Address = Address;
    assign DFill = 1'b1;
    wire [31:0] signedByte;
    wire [31:0] unsignedByte;
    assign unsignedByte = {24'h000000,(((Fill_Contents >> (3-Address[1:0])*8) & 8'hFF))};
    assign signedByte = {{24{unsignedByte[7]}},unsignedByte[7:0]};
    assign RValue = ByteOp?(LBU?unsignedByte:signedByte):Fill_Contents;
    wire [31:0] WBByte;
    wire [31:0] mask;
    assign mask = ~(32'hFF000000  >> (8 * (Address[1:0])));
    assign WBByte = ((SValue<<24) >> (8 * Address[1:0])) | (Fill_Contents & mask);
    assign WB_Value = ByteOp?WBByte:SValue;
endmodule 

module DCACHE(
    input [31:0] Address, // incoming byte-address for a LW/LB/LBU/SW/SB ... or.... just whatever the last ALU output if not memop
    input [31:0] SValue, // The value to be stored to memory (all 32 bits for SW or 7:0 for SB) ... or ... whatever Reg[RT] if not S*
    output [31:0] RValue, // 0 if not a memop; 0 if S*; LW/LB/LBU
    output Ready, // hit and not filling
    input ReadMem, // are we doing an L*
    input WriteMem, // are we doing an S*
    input LBU, // are we doing LBU
    input ByteOp, // are we doing SB, LB, LBU?
    input clk, 
    output DFill, // we are missing and filling in the contents from memory
    output [31:0] DFill_Address, // where are we getting the new contents from?
    input [63:0] Fill_Contents, // data coming in from main memory when we are doing a DFill
    output WriteBack,           // are we writing back dirty data to main memory
    output [31:0] WB_Address,   // what sub-block is being written back to memory
    output [63:0] WB_Value      // the sub-block we are writing back to memory
    );

    // 2KB 2-way associative, LRU, block size 32 bytes
    // 2^11 bytes / 2 ways / 2^5 bytes = 2^5 sets
    // Block = 32 bytes ==> BO = 5 bits Address [4:0]
    // Set index lg2(#sets) ==> 5 bits Address [9:5]
    // Tag size = Address size - block bits - index bits = 32 - 5 -5 ==>Address[31:10]
  
    
    reg [1:0] FillIndex;
    reg Filling;
    
    reg [0:0] MRU[31:0]; // is Way 0 or is Way 1 the most recently used way for each set?
    
    //WAY 0
    reg [0:0] Valid0[31:0]; // Valid bits for each cache block
    reg [0:0] Dirty0[31:0]; // Dirty bits for each cache block
    reg [21:0] Tags0[31:0]; // Tag bits for each cache block
    reg [255:0] Frames0[31:0]; // Actual block contents for way 0
    
    //WAY 1
    reg [0:0] Valid1[31:0]; // Valid bits for each cache block
    reg [0:0] Dirty1[31:0]; // Dirty bits for each cache block
    reg [21:0] Tags1[31:0]; // Tag bits for each cache block
    reg [255:0] Frames1[31:0]; // Actual block contents for way 1


/*
Accessing the cache if reading or writings
Cache hit if:
hit-in-way 0 or hit-in-way 1 & .... actually accessing the cache
hit-in-way 0 <- Valid0 & Tag0[index] matches 
hit-in-way 1 <- Valid1 & Tag1[index] matches
(which hit)? return data from frames0: return data from frames1
read path(LW, LB, LBU):
getting the right word: downselect via MUX from 32-bytes -> 4 bytes
depending on LB/LBU info, return a subset of the bytes retrieved
update the MRU to point to way that we got the hit in
write path (SW, SB):
overwrite just the appropriate word (SW) or byte (SB) indicated via the block offset bits + the byteOp control
update the MRU to point to the way we got the hit in
set that block to dirty
...
What if there's a miss?
victim way[set index] is always ~MRU[set index]
for 4 64-bit blocks in the 32-byte cache block, 
  (if victim was dirty) send current victim bits to memory[victim's address]
  retrieve new fill bits from memory[fill address] .. and overwrite the relevant byte/word if miss was on a SW/SB
  update FSM
only update MRU when done filling, set to dirty if miss was an S*; set to clean if L*
*/


integer i;
initial
begin
// set metadata to invalid, initialize NMRU bits
for (i=0; i<32; i=i+1) 
begin
MRU[i]<=1'b0;
Valid0[i]<=1'b0;
Valid1[i]<=1'b0;
end
FillIndex<=2'b00;
Filling<=1'b0;
end  
endmodule
