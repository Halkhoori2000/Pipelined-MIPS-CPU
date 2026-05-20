module twoCycle_mult(
    input clk,
    input reset,
    input isSigned,
    input [31:0] MCAND_in,
    input [31:0] MPLIER_in,
    output [63:0] Product
    );
        
    wire [31:0] MCAND;
    wire [31:0] MPLIER;
    
    assign MCAND = (isSigned & MCAND_in[31])?(~MCAND_in +1):MCAND_in;
    assign MPLIER = (isSigned & MPLIER_in[31])?(~MPLIER_in +1):MPLIER_in;

    
    reg signFix;
    wire needsSignFix;
    assign needsSignFix = isSigned & (MCAND_in[31]^MPLIER_in[31]);
    
    wire [31:0] PP0;    
    wire [31:0] PP1;    
    wire [31:0] PP2;    
    wire [31:0] PP3;    
    wire [31:0] PP4;    
    wire [31:0] PP5;    
    wire [31:0] PP6;    
    wire [31:0] PP7;    
    wire [31:0] PP8;    
    wire [31:0] PP9;    
    wire [31:0] PP10;    
    wire [31:0] PP11;    
    wire [31:0] PP12;    
    wire [31:0] PP13;    
    wire [31:0] PP14;    
    wire [31:0] PP15;    
    wire [31:0] PP16;    
    wire [31:0] PP17;    
    wire [31:0] PP18;    
    wire [31:0] PP19;    
    wire [31:0] PP20;    
    wire [31:0] PP21;    
    wire [31:0] PP22;    
    wire [31:0] PP23;    
    wire [31:0] PP24;    
    wire [31:0] PP25;    
    wire [31:0] PP26;    
    wire [31:0] PP27;    
    wire [31:0] PP28;    
    wire [31:0] PP29;    
    wire [31:0] PP30;    
    wire [31:0] PP31;    

    assign PP0 = MCAND & {32{MPLIER[0]}};
    assign PP1 = MCAND & {32{MPLIER[1]}};
    assign PP2 = MCAND & {32{MPLIER[2]}};
    assign PP3 = MCAND & {32{MPLIER[3]}};
    assign PP4 = MCAND & {32{MPLIER[4]}};
    assign PP5 = MCAND & {32{MPLIER[5]}};
    assign PP6 = MCAND & {32{MPLIER[6]}};
    assign PP7 = MCAND & {32{MPLIER[7]}};
    assign PP8 = MCAND & {32{MPLIER[8]}};
    assign PP9 = MCAND & {32{MPLIER[9]}};
    assign PP10 = MCAND & {32{MPLIER[10]}};
    assign PP11 = MCAND & {32{MPLIER[11]}};
    assign PP12 = MCAND & {32{MPLIER[12]}};
    assign PP13 = MCAND & {32{MPLIER[13]}};
    assign PP14 = MCAND & {32{MPLIER[14]}};
    assign PP15 = MCAND & {32{MPLIER[15]}};
    assign PP16 = MCAND & {32{MPLIER[16]}};
    assign PP17 = MCAND & {32{MPLIER[17]}};
    assign PP18 = MCAND & {32{MPLIER[18]}};
    assign PP19 = MCAND & {32{MPLIER[19]}};
    assign PP20 = MCAND & {32{MPLIER[20]}};
    assign PP21 = MCAND & {32{MPLIER[21]}};
    assign PP22 = MCAND & {32{MPLIER[22]}};
    assign PP23 = MCAND & {32{MPLIER[23]}};
    assign PP24 = MCAND & {32{MPLIER[24]}};
    assign PP25 = MCAND & {32{MPLIER[25]}};
    assign PP26 = MCAND & {32{MPLIER[26]}};
    assign PP27 = MCAND & {32{MPLIER[27]}};
    assign PP28 = MCAND & {32{MPLIER[28]}};
    assign PP29 = MCAND & {32{MPLIER[29]}};
    assign PP30 = MCAND & {32{MPLIER[30]}};
    assign PP31 = MCAND & {32{MPLIER[31]}};

    wire [33:0] SUM0_1; assign SUM0_1 =     {1'b0,PP0} + {PP1, 1'b0};
    wire [33:0] SUM2_3; assign SUM2_3 =     {1'b0,PP2} + {PP3, 1'b0};
    wire [33:0] SUM4_5; assign SUM4_5 =     {1'b0,PP4} + {PP5, 1'b0};
    wire [33:0] SUM6_7; assign SUM6_7 =     {1'b0,PP6} + {PP7, 1'b0};
    wire [33:0] SUM8_9; assign SUM8_9 =     {1'b0,PP8} + {PP9, 1'b0};
    wire [33:0] SUM10_11; assign SUM10_11 = {1'b0,PP10} + {PP11, 1'b0};
    wire [33:0] SUM12_13; assign SUM12_13 = {1'b0,PP12} + {PP13, 1'b0};
    wire [33:0] SUM14_15; assign SUM14_15 = {1'b0,PP14} + {PP15, 1'b0};
    wire [33:0] SUM16_17; assign SUM16_17 = {1'b0,PP16} + {PP17, 1'b0};
    wire [33:0] SUM18_19; assign SUM18_19 = {1'b0,PP18} + {PP19, 1'b0};
    wire [33:0] SUM20_21; assign SUM20_21 = {1'b0,PP20} + {PP21, 1'b0};
    wire [33:0] SUM22_23; assign SUM22_23 = {1'b0,PP22} + {PP23, 1'b0};
    wire [33:0] SUM24_25; assign SUM24_25 = {1'b0,PP24} + {PP25, 1'b0};
    wire [33:0] SUM26_27; assign SUM26_27 = {1'b0,PP26} + {PP27, 1'b0};
    wire [33:0] SUM28_29; assign SUM28_29 = {1'b0,PP28} + {PP29, 1'b0};
    wire [33:0] SUM30_31; assign SUM30_31 = {1'b0,PP30} + {PP31, 1'b0};

    wire [36:0] SUM0_3; assign SUM0_3 =     {2'b0,SUM0_1} + {SUM2_3, 2'b0};
    wire [36:0] SUM4_7; assign SUM4_7 =     {2'b0,SUM4_5} + {SUM6_7, 2'b0};
    wire [36:0] SUM8_11; assign SUM8_11 =   {2'b0,SUM8_9} + {SUM10_11, 2'b0};
    wire [36:0] SUM12_15; assign SUM12_15 =  {2'b0,SUM12_13} + {SUM14_15, 2'b0};
    wire [36:0] SUM16_19; assign SUM16_19 =  {2'b0,SUM16_17} + {SUM18_19, 2'b0};
    wire [36:0] SUM20_23; assign SUM20_23 = {2'b0,SUM20_21} + {SUM22_23, 2'b0};
    wire [36:0] SUM24_27; assign SUM24_27 = {2'b0,SUM24_25} + {SUM26_27, 2'b0};
    wire [36:0] SUM28_31; assign SUM28_31 = {2'b0,SUM28_29} + {SUM30_31, 2'b0};

    wire [41:0] SUM0_7; assign SUM0_7 =     {4'b0,SUM0_3} + {SUM4_7, 4'b0};
    wire [41:0] SUM8_15; assign SUM8_15 =     {4'b0,SUM8_11} + {SUM12_15, 4'b0};
    wire [41:0] SUM16_23; assign SUM16_23 =   {4'b0,SUM16_19} + {SUM20_23, 4'b0};
    wire [41:0] SUM24_31; assign SUM24_31 =  {4'b0,SUM24_27} + {SUM28_31, 4'b0};
    
    reg [41:0] Q0;
    reg [41:0] Q1;
    reg [41:0] Q2;
    reg [41:0] Q3;

    wire [50:0] SUMlow; assign SUMlow =     {8'b0,Q0} + {Q1, 8'b0};
    wire [50:0] SUMhigh; assign SUMhigh =     {8'b0,Q2} + {Q3, 8'b0};

    wire [67:0] SUM; assign SUM =   {16'b0,SUMlow} + {SUMhigh, 16'b0};

    assign Product = (signFix)?~SUM[63:0]+1:SUM[63:0];
     
    
    always @(posedge clk)
        if (reset)
            begin
            signFix <= 0;
            Q0 <=0;
            Q1 <=0;
            Q2 <=0;
            Q3 <=0;
            end
         else
            begin
            signFix <= needsSignFix;
            Q0 <=SUM0_7;
            Q1 <=SUM8_15;
            Q2 <=SUM16_23;
            Q3 <=SUM24_31;
            end
endmodule
