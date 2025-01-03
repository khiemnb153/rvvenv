module VALU(
    input [31:0] opd1,
    input [31:0] opd2,
    input [4:0] op,
    input vm,
    output reg [31:0] result
);
    reg vm4alu;
    always @(*) begin
        if(op == 5'b10101) begin
            if (vm == 0) result = opd1; // vmerge
            else result = opd2;
        end else if (vm == 0 && op != 5'b10101) result = 32'b0;
        else begin
            case(op)
                5'b00000: result = opd1 + opd2; // vadd, load, store
                5'b00001: result = opd1 - opd2; // vsub
                5'b00010: result = opd2 - opd1; // vrsub
                5'b00011: result = opd1 & opd2; // vand
                5'b00100: result = opd1 | opd2; // vor
                5'b00101: result = opd1 ^ opd2; // vxor
                5'b00110: result = opd1 << opd2; // vsll
                5'b00111: result = opd1 >> opd2; // vsrl
                5'b01000: result = opd1 >>> opd2; // vsra 
                5'b01001: result = (opd1 == opd2) ? 32'b1 : 32'b0; // vmseq
                5'b01010: result = (opd1 != opd2) ? 32'b1 : 32'b0; // vmsne
                5'b01011: result = (opd1 < opd2) ? 32'b1 : 32'b0; // vmsltu
                5'b01100: result = ($signed(opd1) < $signed(opd2)) ? 32'b1 : 32'b0; // vmslt
                5'b01101: result = (opd1 <= opd2) ? 32'b1 : 32'b0; // vmsleu
                5'b01110: result = ($signed(opd1) <= $signed(opd2)) ? 32'b1 : 32'b0; // vmsle 
                5'b01111: result = (opd1 > opd2) ? 32'b1 : 32'b0; // vmsgtu
                5'b10000: result = ($signed(opd1) > $signed(opd2)) ? 32'b1 : 32'b0; // vmsgt
                5'b10001: result = (opd1 <= opd2) ? opd1 : opd2; // minu
                5'b10010: result = ($signed(opd1) <= $signed(opd2)) ? opd1 : opd2; // min
                5'b10011: result = (opd1 >= opd2) ? opd1 : opd2; // maxu
                5'b10100: result = ($signed(opd1) >= $signed(opd2)) ? opd1 : opd2; // max
                5'b10101: result = opd2; // vmv
                default: result = 32'b0;
            endcase
        end
    end
endmodule
