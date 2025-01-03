module VController (
    input [6:0] Opcode,
    input [2:0] Funct3, MewMop,
    output reg [3:0] VDWEn, VDREn, Opd2Sel,
    output reg [1:0] Opd1Sel, 
    output reg VX, VWEn, WBEn
);
    always @(*) begin 
        if(Opcode == 7'b1010111 && Funct3 == 3'b000) begin // OPIVV
            Opd1Sel = 2'b0;
            Opd2Sel = 3'b0;
            VX = 1'b0;
            VWEn = 1'b1;
            WBEn = 1'b0;
            VDWEn = 4'b0;
            VDREn = 4'b0;
        end
        else if(Opcode == 7'b1010111 && Funct3 == 3'b100) begin // OPIVX
            Opd1Sel = 2'b0;
            Opd2Sel = 3'b010;
            VX = 1'b0;
            VWEn = 1'b1;
            WBEn = 1'b0;
            VDWEn = 4'b0;
            VDREn = 4'b0;
        end
        else if(Opcode == 7'b1010111 && Funct3 == 3'b011) begin // OPIVI
            Opd1Sel = 2'b0;
            Opd2Sel = 3'b011;
            VX = 1'b0;
            VWEn = 1'b1;
            WBEn = 1'b0;
            VDWEn = 4'b0;
            VDREn = 4'b0;
        end
        else if(Opcode == 7'b0000111 && MewMop == 3'b000) begin // VLE
            Opd1Sel = 2'b10;
            Opd2Sel = 3'b100;
            VX = 1'b0;
            VWEn = 1'b1;
            WBEn = 1'b1;
            VDWEn = 4'b0;
            VDREn = 4'b1111;
        end
        else if(Opcode == 7'b0000111 && MewMop == 3'b010) begin // VLSE
            Opd1Sel = 2'b10;
            Opd2Sel = 3'b100;
            VX = 1'b0;
            VWEn = 1'b1;
            WBEn = 1'b1;
            VDWEn = 4'b0;
            VDREn = 4'b1111;
        end
        else if(Opcode == 7'b0000111 && MewMop == 3'b001) begin // VLUXEI
            Opd1Sel = 2'b10;
            Opd2Sel = 3'b001;
            VX = 1'b0;
            VWEn = 1'b1;
            WBEn = 1'b1;
            VDWEn = 4'b0;
            VDREn = 4'b1111;
        end
        else if(Opcode == 7'b0000111 && MewMop == 3'b001) begin // VSE
            Opd1Sel = 2'b10;
            Opd2Sel = 3'b100;
            VX = 1'b0;
            VWEn = 1'b0;
            WBEn = 1'b0;
            VDWEn = 4'b1111;
            VDREn = 4'b0;
        end
        else if(Opcode == 7'b0000111 && MewMop == 3'b001) begin // VSSE
            Opd1Sel = 2'b10;
            Opd2Sel = 3'b100;
            VX = 1'b0;
            VWEn = 1'b0;
            WBEn = 1'b0;
            VDWEn = 4'b1111;
            VDREn = 4'b0;
        end
        else if(Opcode == 7'b0000111 && MewMop == 3'b001) begin // VSUXEI
            Opd1Sel = 2'b10;
            Opd2Sel = 3'b001;
            VX = 1'b0;
            VWEn = 1'b0;
            WBEn = 1'b0;
            VDWEn = 4'b1111;
            VDREn = 4'b0;
        end
    end

endmodule
