`timescale 1ns / 1ps

module HazardDetection(
    input [4:0] ID_RS,
    input [4:0] ID_RT,
    input ID_UseRT,
    input ID_memWrite,
    input [4:0] EX_Dest,
    input EX_regWrite,
    input EX_memToReg,
    input [4:0] MEM_Dest,
    input MEM_memToReg,
    input ID_isBranch,
    input ID_isJR,
    input EX_WriteHILO_ctrl,
    input ID_UseHILO_ctrl,
    output HazardDetected
    );
    
    reg RSHazardDetected;
    reg RTHazardDetected;
    reg HILOHazardDetected;
  
    assign HazardDetected = RSHazardDetected | RTHazardDetected | HILOHazardDetected;
    
    always @ (*)
    begin
    RSHazardDetected=1'b0;
    RTHazardDetected=1'b0;
    HILOHazardDetected=1'b0;
  
    RSHazardDetected = (ID_isBranch & (ID_RS != 5'b00000) & ((EX_regWrite & (EX_Dest==ID_RS)) | (MEM_memToReg & (MEM_Dest==ID_RS)))) |
                       ((ID_RS != 5'b00000) & EX_memToReg & (EX_Dest==ID_RS)) |
                       (ID_isJR & (ID_RS != 5'b00000) & ((EX_regWrite & (EX_Dest==ID_RS)) | (MEM_memToReg & (MEM_Dest==ID_RS))));
    
    RTHazardDetected = ((ID_RS != 5'b00000) & EX_memToReg & (EX_Dest==ID_RS)) | 
                       (ID_UseRT & (~ID_memWrite) & (ID_RT != 5'b00000) & EX_memToReg & (EX_Dest==ID_RT));
 
    HILOHazardDetected = HILOHazardDetected | (EX_WriteHILO_ctrl & ID_UseHILO_ctrl);
  
    end
endmodule
