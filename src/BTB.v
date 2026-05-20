module BTB(
input clk,
input [31:0] accessPC,
output [31:0] outInstBits,
output [31:0] targetPC,
output btbHit,
output btbType,
input update_ctrl,
input [31:0] updatePC,
input [31:0] updateInstBits,
input [31:0] updateTargetPC
);

reg [0:0] Valid [31:0];
reg [26:0] Tag [31:0];
reg [31:0] InstructionContent [31:0];
reg [31:0] InstructionAddress [31:0];
reg [0:0] IsJump [31:0];

wire [4:0] LookupIndex;
wire [26:0] IncomingTag;

wire [4:0] UpdateIndex;
wire [26:0] UpdateTag;

wire LookupValid;
wire [26:0] LookupTag;
wire [31:0] LookupContents;
wire [31:0] LookupAddress;
wire LookupIsJump;

assign LookupIndex = accessPC[6:2];
assign IncomingTag = accessPC[31:5];

assign UpdateIndex = updatePC[6:2];
assign UpdateTag = updatePC[31:5];

assign LookupValid = Valid [LookupIndex];
assign LookupTag = Tag [LookupIndex];
assign LookupContents = InstructionContent [LookupIndex];
assign LookupAddress = InstructionAddress [LookupIndex];
assign LookupIsJump = IsJump [LookupIndex];

assign btbHit = (LookupValid & (LookupTag == IncomingTag));
assign outInstBits = LookupContents;
assign targetPC = LookupAddress;
assign btbType = LookupIsJump;

always @ (posedge clk)
begin
if(update_ctrl)
begin
    Valid [UpdateIndex]<= 1'b1;
    Tag [UpdateIndex]<= UpdateTag;
    InstructionContent [UpdateIndex]<=updateInstBits;
    InstructionAddress [UpdateIndex]<=updateTargetPC;
    IsJump [UpdateIndex]<=(updateInstBits[31:26]==6'b000010) |(updateInstBits[31:26]==6'b000011);
end
end


integer i;
initial
begin
for (i=0; i<32; i=i+1) Valid[i]=1'b0;
end
endmodule