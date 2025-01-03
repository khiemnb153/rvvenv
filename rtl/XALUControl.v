module XALUControl (
    input [1:0] aluOp,
    input [3:0] funct, // {funct7[5], funct3}
    input [6:0] Opcode,
    output reg [3:0] aluSel
);
    always @(*) begin
        casex({aluOp, funct})
            6'b00x010: aluSel <= 4'b0010; // lw, sw
            6'b100000: aluSel <= 4'b0010; // add
            6'b101000: aluSel <= 4'b0110; // sub
            6'b100111: aluSel <= 4'b0000; // AND
            6'b100110: aluSel <= 4'b0001; // OR
            6'b100100: aluSel <= 4'b0011; // XOR
            6'b100001: aluSel <= 4'b0100; // SLL, SLLI
            6'b100101: aluSel <= 4'b0101; // SRL, SRLI
            6'b101101: aluSel <= 4'b1001; // SRA, SRAI
            6'b100011: aluSel <= 4'b0111; // SLTU
            6'b100010: aluSel <= 4'b1000; // SLT
            6'b01x000: aluSel <= 4'b0110; // BEQ
            6'b01x001: aluSel <= 4'b0110; // BNE
            6'b01x100: aluSel <= 4'b1000; // BLT
            6'b01x101: aluSel <= 4'b1000; // BGE
            6'b01x110: aluSel <= 4'b0111; // BLTU
            6'b01x111: aluSel <= 4'b0111; // BGEU
            6'b11xxxx: aluSel <= (Opcode == 7'b0110111) ? 4'b1010: 4'b0010; // jal, jalr, auipc, lui
            default: aluSel <= 4'b0010;
        endcase
    end
endmodule