module VALUControl(
    input [5:0] funct,
    input [6:0] opcode,
    output reg [4:0] valuSel
    );
    always @(*) begin
        casex({opcode,funct})
            13'b1010111000000: valuSel = 5'b00000; // vadd, lw, sw
            13'b1010111000010: valuSel = 5'b00001; // vsub
            13'b1010111000011: valuSel = 5'b00010; // vrsub
            13'b1010111001001: valuSel = 5'b00011; // vand
            13'b1010111001010: valuSel = 5'b00100; // vor
            13'b1010111001011: valuSel = 5'b00101; // vxor
            13'b1010111100101: valuSel = 5'b00110; // vsll
            13'b1010111101000: valuSel = 5'b00111; // vsrl
            13'b1010111101001: valuSel = 5'b01000; // vsra
            13'b1010111011000: valuSel = 5'b01001; // vmseq
            13'b1010111011001: valuSel = 5'b01010; // vmsne
            13'b1010111011010: valuSel = 5'b01011; // vmsltu
            13'b1010111011011: valuSel = 5'b01100; // vmslt
            13'b1010111011100: valuSel = 5'b01101; // vmsleu
            13'b1010111011101: valuSel = 5'b01110; // vmsle
            13'b1010111011110: valuSel = 5'b01111; // vmsgtu
            13'b1010111011111: valuSel = 5'b10000; // vmsgt
            13'b1010111000100: valuSel = 5'b10001; // minu
            13'b1010111000101: valuSel = 5'b10010; // min
            13'b1010111000110: valuSel = 5'b10011; // maxu
            13'b1010111000111: valuSel = 5'b10100; // max
            13'b1010111010111: valuSel = 5'b10101; // vmerge/vmv
            13'b0000111000000: valuSel = 5'b00000; // vle
            13'b0100111000000: valuSel = 5'b00000; // vse
            13'b0000111000010: valuSel = 5'b00000; // vlse
            13'b0100111000010: valuSel = 5'b00000; // vsse
            13'b0000111000001: valuSel = 5'b00000; // vluxei
            13'b0100111000001: valuSel = 5'b00000; // vsuxei
            default: valuSel = 5'b00000;
        endcase
    end
endmodule
