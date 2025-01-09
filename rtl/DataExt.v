module DataExt(
    input [31:0] dataIn,
    input mode,
    input [2:0] readEnable,
    input [6:0] opcode,
    output [31:0] dataOut
);
    wire signBit;
    wire [7:0] temp0, temp1, temp2, temp3;
    assign signBit = (readEnable[1]) ? dataIn[15] : dataIn[7];
    
    assign dataOut[7:0]   = dataIn[7:0];
    assign dataOut[15:8]  = (~mode & ~readEnable[1] & (opcode == 7'b0000011 | opcode == 7'b0000111)) ? {8{signBit}} : dataIn[15:8];
    assign dataOut[23:16] = (~mode & ~readEnable[2] & (opcode == 7'b0000011 | opcode == 7'b0000111)) ? {8{signBit}} : dataIn[23:16];
    assign dataOut[31:24] = (~mode & ~readEnable[2] & (opcode == 7'b0000011 | opcode == 7'b0000111)) ? {8{signBit}} : dataIn[31:24];
endmodule
