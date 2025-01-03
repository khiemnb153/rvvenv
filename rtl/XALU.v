module XALU (
    input [31:0] opd1,
    input [31:0] opd2,
    input [3:0] sel,
    input [2:0] funct3,
    input [6:0] opcode,
    output reg [31:0] result,
    output zero,
    output reg JB
);
    always @(*) begin
        case(sel)
            4'b0000: result = opd1 & opd2; // and
            4'b0001: result = opd1 | opd2; // or
            4'b0010: result = opd1 + opd2; // add, lw, sw
            4'b0011: result = opd1 ^ opd2; // xor
            4'b0100: result = opd1 << opd2; // sll, slli
            4'b0101: result = opd1 >> opd2; // srl, srli
            4'b0110: result = opd1 - opd2; // sub, beq, bne
            4'b0111: result = (opd1 < opd2) ? 32'b1 : 32'b0; // sltu, bltu, bgeu
            4'b1000: result = ($signed(opd1) < $signed(opd2)) ? 32'b1 : 32'b0; // slt, blt, bge
            4'b1001: result = opd1 >>> opd2; // sra, srai
            4'b1010: result = opd2;
            default: result = 32'b0;
        endcase
    end
    assign zero = (result == 32'b0) ? 1'b1 : 1'b0;
    always@(*) begin
        case(opcode)
            7'b1101111: JB = 1'b1;
            7'b1100111: JB = 1'b1;
            7'b1100011: if(funct3 == 3'b000 && result == 32'b0) JB = 1'b1;
                        else if (funct3 == 3'b001 && result != 32'b0) JB = 1'b1;
                        else if (funct3 == 3'b100 && result == 32'b1) JB = 1'b1;
                        else if (funct3 == 3'b101 && result != 32'b1) JB = 1'b1;
                        else if (funct3 == 3'b110 && result == 32'b1) JB = 1'b1;
                        else if (funct3 == 3'b111 && result != 32'b1) JB = 1'b1;
                        else JB = 1'b0;
            default: JB = 1'b0;
        endcase
    end
endmodule