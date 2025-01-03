module FinalController (

    input [31:0] inst,
   // VController
    output reg [2:0] Opd2Sel,
    output reg [1:0] Opd1Sel, 
    output reg WBEn,
    output reg [3:0] VWEn,
    // XController
    output reg VX, xOpd1Sel, xOpd2Sel, RegWrite,
    output reg [1:0] ALUOp, xWBSel, Branch,
    output reg [2:0] xImmType, MemRead3, MemRead2, MemRead1, MemRead0, MemWrite3, MemWrite2, MemWrite1, MemWrite0
);
    wire [6:0] Opcode = inst[6:0];
    wire [2:0] Funct3 = inst[14:12];
    wire [2:0] VMewMop = inst[28:26];
    wire [6:0] Funct7 = inst[31:25];
    
    
    always @(*) begin
    
        // Vector Controller
        if(Opcode == 7'b1010111 && Funct3 == 3'b000) begin // OPIVV
            //V Signal
            Opd1Sel = 2'b0;
            Opd2Sel = 3'b0;
            VX = 1'b1;
            VWEn = 4'b1111;
            WBEn = 1'b0;
            // S Signal
            xOpd1Sel = 1'b0;
            xOpd2Sel = 1'b0;
            RegWrite = 1'b0;
            ALUOp = 2'b0;
            xWBSel = 2'b0;
            Branch = 2'b0;
            xImmType = 3'b0;
            MemRead3 = 3'b0;
            MemRead2 = 3'b0;
            MemRead1 = 3'b0;
            MemRead0 = 3'b0;
            MemWrite3 = 3'b0;
            MemWrite2 = 3'b0;
            MemWrite1 = 3'b0;
            MemWrite0 = 3'b0;
        end
            else if(Opcode == 7'b1010111 && Funct3 == 3'b100) begin // OPIVX
            //V Signal
            Opd1Sel = 2'b0;
            Opd2Sel = 3'b010;
            VX = 1'b1;
            VWEn = 4'b1111;
            WBEn = 1'b0;
            // S Signal
            xOpd1Sel = 1'b0;
            xOpd2Sel = 1'b0;
            RegWrite = 1'b0;
            ALUOp = 2'b0;
            xWBSel = 2'b0;
            Branch = 2'b0;
            xImmType = 3'b0;
            MemRead3 = 3'b0;
            MemRead2 = 3'b0;
            MemRead1 = 3'b0;
            MemRead0 = 3'b0;
            MemWrite3 = 3'b0;
            MemWrite2 = 3'b0;
            MemWrite1 = 3'b0;
            MemWrite0 = 3'b0;
        end
        else if(Opcode == 7'b1010111 && Funct3 == 3'b011) begin // OPIVI
            // V Signal
            Opd1Sel = 2'b0;
            Opd2Sel = 3'b100;
            VX = 1'b1;
            VWEn = 4'b1111;
            WBEn = 1'b0;
            // S Signal
            xOpd1Sel = 1'b0;
            xOpd2Sel = 1'b0;
            RegWrite = 1'b0;
            ALUOp = 2'b0;
            xWBSel = 2'b0;
            Branch = 2'b0;
            xImmType = 3'b0;
            MemRead3 = 3'b0;
            MemRead2 = 3'b0;
            MemRead1 = 3'b0;
            MemRead0 = 3'b0;
            MemWrite3 = 3'b0;
            MemWrite2 = 3'b0;
            MemWrite1 = 3'b0;
            MemWrite0 = 3'b0;
        end
        else if(Opcode == 7'b0000111 && VMewMop == 3'b000) begin // VLE
            // V Signal
            Opd1Sel = 2'b10;
            Opd2Sel = 3'b11x;
            VX = 1'b1;
            VWEn = 4'b1111;
            WBEn = 1'b1;
            // S Signal
            xOpd1Sel = 1'b0;
            xOpd2Sel = 1'b0;
            RegWrite = 1'b0;
            ALUOp = 2'b0;
            xWBSel = 2'b0;
            Branch = 2'b0;
            xImmType = 3'b0;
            MemWrite3 = 3'b0;
            MemWrite2 = 3'b0;
            MemWrite1 = 3'b0;
            MemWrite0 = 3'b0;
            if(Funct3 == 3'b110) begin // VLE32
                MemRead3 = 3'b111;
                MemRead2 = 3'b111;
                MemRead1 = 3'b111;
                MemRead0 = 3'b111;
            end
            else if(Funct3 == 3'b101) begin // VLE16
                MemRead3 = 3'b011;
                MemRead2 = 3'b011;
                MemRead1 = 3'b011;
                MemRead0 = 3'b011;
            end
            else if(Funct3 == 3'b000) begin // VLE8
                MemRead3 = 3'b001;
                MemRead2 = 3'b001;
                MemRead1 = 3'b001;
                MemRead0 = 3'b001;
            end
        end
        else if(Opcode == 7'b0000111 && VMewMop == 3'b010) begin // VLSE
            // V Signal
            Opd1Sel = 2'b10;
            Opd2Sel = 3'b11x;
            VX = 1'b1;
            VWEn = 4'b1111;
            WBEn = 1'b1;
            // S Signal
            xOpd1Sel = 1'b0;
            xOpd2Sel = 1'b0;
            RegWrite = 1'b0;
            ALUOp = 2'b0;
            xWBSel = 2'b0;
            Branch = 2'b0;
            xImmType = 3'b0;
            MemWrite3 = 3'b0;
            MemWrite2 = 3'b0;
            MemWrite1 = 3'b0;
            MemWrite0 = 3'b0;
            if(Funct3 == 3'b110) begin // VLSE32
                MemRead3 = 3'b111;
                MemRead2 = 3'b111;
                MemRead1 = 3'b111;
                MemRead0 = 3'b111;
            end
            else if(Funct3 == 3'b101) begin // VLSE16
                MemRead3 = 3'b011;
                MemRead2 = 3'b011;
                MemRead1 = 3'b011;
                MemRead0 = 3'b011;
            end
            else if(Funct3 == 3'b000) begin // VLSE8
                MemRead3 = 3'b001;
                MemRead2 = 3'b001;
                MemRead1 = 3'b001;
                MemRead0 = 3'b001;
            end
        end
        else if(Opcode == 7'b0000111 && VMewMop == 3'b001) begin // VLUXEI
            // V Signal
            Opd1Sel = 2'b10;
            Opd2Sel = 3'b001;
            VX = 1'b1;
            VWEn = 4'b1111;
            WBEn = 1'b1;
            // S Signal
            xOpd1Sel = 1'b0;
            xOpd2Sel = 1'b0;
            RegWrite = 1'b0;
            ALUOp = 2'b0;
            xWBSel = 2'b0;
            Branch = 2'b0;
            xImmType = 3'b0;
            MemWrite3 = 3'b0;
            MemWrite2 = 3'b0;
            MemWrite1 = 3'b0;
            MemWrite0 = 3'b0;
            if(Funct3 == 3'b110) begin // VLUXEI32
                MemRead3 = 3'b111;
                MemRead2 = 3'b111;
                MemRead1 = 3'b111;
                MemRead0 = 3'b111;
            end
            else if(Funct3 == 3'b101) begin // VLUXEI16
                MemRead3 = 3'b011;
                MemRead2 = 3'b011;
                MemRead1 = 3'b011;
                MemRead0 = 3'b011;
            end
            else if(Funct3 == 3'b000) begin // VLUXEI8
                MemRead3 = 3'b001;
                MemRead2 = 3'b001;
                MemRead1 = 3'b001;
                MemRead0 = 3'b001;
            end
        end
        else if(Opcode == 7'b0100111 && VMewMop == 3'b000) begin // VSE
            Opd1Sel = 2'b10;
            Opd2Sel = 3'b11x;
            VX = 1'b1;
            VWEn = 4'b0000;
            WBEn = 1'b0;
            // S Signal
            xOpd1Sel = 1'b0;
            xOpd2Sel = 1'b0;
            RegWrite = 1'b0;
            ALUOp = 2'b0;
            xWBSel = 2'b0;
            Branch = 2'b0;
            xImmType = 3'b0;
            MemRead3 = 3'b0;
            MemRead2 = 3'b0;
            MemRead1 = 3'b0;
            MemRead0 = 3'b0;
            if(Funct3 == 3'b110) begin // VSE32
                MemWrite3 = 3'b111;
                MemWrite2 = 3'b111;
                MemWrite1 = 3'b111;
                MemWrite0 = 3'b111;
            end
            else if(Funct3 == 3'b101) begin // VSE16
                MemWrite3 = 3'b011;
                MemWrite2 = 3'b011;
                MemWrite1 = 3'b011;
                MemWrite0 = 3'b011;
            end
            else if(Funct3 == 3'b000) begin // VSE8
                MemWrite3 = 3'b001;
                MemWrite2 = 3'b001;
                MemWrite1 = 3'b001;
                MemWrite0 = 3'b001;
            end
        end
        else if(Opcode == 7'b0100111 && VMewMop == 3'b010) begin // VSSE
            Opd1Sel = 2'b10;
            Opd2Sel = 3'b11x;
            VX = 1'b1;
            VWEn = 4'b0000;
            WBEn = 1'b0;
            // S Signal
            xOpd1Sel = 1'b0;
            xOpd2Sel = 1'b0;
            RegWrite = 1'b0;
            ALUOp = 2'b0;
            xWBSel = 2'b0;
            Branch = 2'b0;
            xImmType = 3'b0;
            MemRead3 = 3'b0;
            MemRead2 = 3'b0;
            MemRead1 = 3'b0;
            MemRead0 = 3'b0;
            if(Funct3 == 3'b110) begin // VSSE32
                MemWrite3 = 3'b111;
                MemWrite2 = 3'b111;
                MemWrite1 = 3'b111;
                MemWrite0 = 3'b111;
            end
            else if(Funct3 == 3'b101) begin // VSSE16
                MemWrite3 = 3'b011;
                MemWrite2 = 3'b011;
                MemWrite1 = 3'b011;
                MemWrite0 = 3'b011;
            end
            else if(Funct3 == 3'b000) begin // VSSE8
                MemWrite3 = 3'b001;
                MemWrite2 = 3'b001;
                MemWrite1 = 3'b001;
                MemWrite0 = 3'b001;
            end
        end
        else if(Opcode == 7'b0100111 && VMewMop == 3'b001) begin // VSUXEI
            Opd1Sel = 2'b10;
            Opd2Sel = 3'b001;
            VX = 1'b1;
            VWEn = 4'b0000;
            WBEn = 1'b0;
            // S Signal
            xOpd1Sel = 1'b0;
            xOpd2Sel = 1'b0;
            RegWrite = 1'b0;
            ALUOp = 2'b0;
            xWBSel = 2'b0;
            Branch = 2'b0;
            xImmType = 3'b0;
            MemRead3 = 3'b0;
            MemRead2 = 3'b0;
            MemRead1 = 3'b0;
            MemRead0 = 3'b0;
            if(Funct3 == 3'b110) begin // VSUXEI32
                MemWrite3 = 3'b111;
                MemWrite2 = 3'b111;
                MemWrite1 = 3'b111;
                MemWrite0 = 3'b111;
            end
            else if(Funct3 == 3'b101) begin // VSUXEI16
                MemWrite3 = 3'b011;
                MemWrite2 = 3'b011;
                MemWrite1 = 3'b011;
                MemWrite0 = 3'b011;
            end
            else if(Funct3 == 3'b000) begin // VSUXEI8
                MemWrite3 = 3'b001;
                MemWrite2 = 3'b001;
                MemWrite1 = 3'b001;
                MemWrite0 = 3'b001;
            end
        end
        
        // Scalar Controller
        else if (Opcode == 7'b0110011) begin // R-type
            // V Signal
            Opd1Sel = 2'b00;
            Opd2Sel = 3'b000;
            VX = 1'b0;
            VWEn = 4'b0000;
            WBEn = 1'b0;
            // S Signal
            MemRead3 = 3'b0;
            MemRead2 = 3'b0;
            MemRead1 = 3'b0;
            MemRead0 = 3'b0;
            MemWrite3 = 3'b0;
            MemWrite2 = 3'b0;
            MemWrite1 = 3'b0;
            MemWrite0 = 3'b0;
            Branch = 2'b00;
            xOpd1Sel = 1'b1;
            xOpd2Sel = 1'b0;
            RegWrite = 1'b1;
            xWBSel = 2'b00;
            ALUOp = 2'b10;
            xImmType = 3'bxxx;
        end
        else if (Opcode == 7'b0010011) begin // I-type
            // V Signal
            Opd1Sel = 2'b00;
            Opd2Sel = 3'b000;
            VX = 1'b0;
            VWEn = 4'b0000;
            WBEn = 1'b0;
            // S Signal
            MemRead3 = 3'b0;
            MemRead2 = 3'b0;
            MemRead1 = 3'b0;
            MemRead0 = 3'b0;
            MemWrite3 = 3'b0;
            MemWrite2 = 3'b0;
            MemWrite1 = 3'b0;
            MemWrite0 = 3'b0;
            Branch = 2'b00;
            xOpd1Sel = 1'b1;
            xOpd2Sel = 1'b1;
            RegWrite = 1'b1;
            xWBSel = 2'b00;
            ALUOp = 2'b10;
            xImmType = 3'b000;
        end
        else if (Opcode == 7'b1100011) begin // B-type
            // V Signal
            Opd1Sel = 2'b00;
            Opd2Sel = 3'b000;
            VX = 1'b0;
            VWEn = 4'b0000;
            WBEn = 1'b0;
            // S Signal
            MemRead3 = 3'b0;
            MemRead2 = 3'b0;
            MemRead1 = 3'b0;
            MemRead0 = 3'b111;
            MemWrite3 = 3'b0;
            MemWrite2 = 3'b0;
            MemWrite1 = 3'b0;
            MemWrite0 = 3'b0;
            Branch = 2'b01;
            xOpd1Sel = 1'b0;
            xOpd2Sel = 1'b1;
            RegWrite = 1'b0;
            xWBSel = 2'b00;
            ALUOp = 2'b01;
            xImmType = 3'b000;
        end
        if(Opcode == 7'b0000011) begin // load
            // V Signal
            Opd1Sel = 2'b00;
            Opd2Sel = 3'b000;
            VX = 1'b0;
            VWEn = 4'b0000;
            WBEn = 1'b0;
            // S Signal
            Branch = 2'b00;
            MemWrite3 = 3'b0;
            MemWrite2 = 3'b0;
            MemWrite1 = 3'b0;
            MemWrite0 = 3'b0;
            MemRead3 = 3'b0;
            MemRead2 = 3'b0;
            MemRead1 = 3'b0;
            if (Funct3 == 3'b000)
                MemRead0 = 3'b001;       // lb
            else if (Funct3 == 3'b001)
                MemRead0 = 3'b011;       // lh
            else if (Funct3 == 3'b010)
                MemRead0 = 3'b111;       // lw
            else MemRead0 = 3'b000;
            xOpd1Sel = 1'b1;
            xOpd2Sel = 1'b1;
            RegWrite = 1'b1;
            xWBSel = 2'b01;
            ALUOp = 2'b00;
            xImmType = 3'b000;                        
        end
        else if (Opcode == 7'b0100011) begin // store
             // V Signal
            Opd1Sel = 2'b00;
            Opd2Sel = 3'b000;
            VX = 1'b0;
            VWEn = 4'b0000;
            WBEn = 1'b0;
            // S Signal
            Branch = 2'b00;
            MemRead3 = 3'b0;
            MemRead2 = 3'b0;
            MemRead1 = 3'b0;
            MemRead0 = 1'b0;
            if (Funct3 == 3'b000)
                MemWrite0 = 3'b001;      // sb
            else if (Funct3 == 3'b001)
                MemWrite0 = 3'b011;      // sh
            else if (Funct3 == 3'b010)
                MemWrite0 = 3'b111;      // sw
            else MemWrite0 = 3'b000;
            xOpd1Sel = 1'b1;
            xOpd2Sel = 1'b1;
            RegWrite = 1'b0;
            xWBSel = 2'bxx;
            ALUOp = 2'b00;
            xImmType = 3'b001;
        end
        else if (Opcode == 7'b0110011 && Funct3 == 3'b101 && Funct7 == 7'b0100000) begin // srai
            // V Signal
            Opd1Sel = 2'b00;
            Opd2Sel = 3'b000;
            VX = 1'b0;
            VWEn = 4'b0000;
            WBEn = 1'b0;
            // S Signal
            MemRead3 = 3'b0;
            MemRead2 = 3'b0;
            MemRead1 = 3'b0;
            MemRead0 = 3'b0;
            MemWrite3 = 3'b0;
            MemWrite2 = 3'b0;
            MemWrite1 = 3'b0;
            MemWrite0 = 3'b0;
            Branch = 2'b00;
            xOpd1Sel = 1'b1;
            xOpd2Sel = 1'b1;
            RegWrite = 1'b1;
            xWBSel = 2'b00;
            ALUOp = 2'b10;
            xImmType = 3'b101;
        end
        else if (Opcode == 7'b0110111) begin // lui
             // V Signal
            Opd1Sel = 2'b00;
            Opd2Sel = 3'b000;
            VX = 1'b0;
            VWEn = 4'b0000;
            WBEn = 1'b0;
            // S Signal
            MemRead3 = 3'b0;
            MemRead2 = 3'b0;
            MemRead1 = 3'b0;
            MemRead0 = 3'b0;
            MemWrite3 = 3'b0;
            MemWrite2 = 3'b0;
            MemWrite1 = 3'b0;
            MemWrite0 = 3'b0;
            Branch = 2'b00;
            xOpd1Sel = 1'bx;
            xOpd2Sel = 1'b1;
            RegWrite = 1'b1;
            xWBSel = 2'b00;
            ALUOp = 2'b11;
            xImmType = 3'b011;
        end
        else if (Opcode == 7'b0010111) begin // auipc
            // V Signal
            Opd1Sel = 2'b00;
            Opd2Sel = 3'b000;
            VX = 1'b0;
            VWEn = 4'b0000;
            WBEn = 1'b0;
            // S Signal
            MemRead3 = 3'b0;
            MemRead2 = 3'b0;
            MemRead1 = 3'b0;
            MemRead0 = 3'b0;
            MemWrite3 = 3'b0;
            MemWrite2 = 3'b0;
            MemWrite1 = 3'b0;
            MemWrite0 = 3'b0;
            Branch = 2'b00;
            xOpd1Sel = 1'b0;
            xOpd2Sel = 1'b1;
            RegWrite = 1'b1;
            xWBSel = 2'b00;
            ALUOp = 2'b11;
            xImmType = 3'b011;
        end
        else if(Opcode == 7'b1101111) begin // jal
            // V Signal
            Opd1Sel = 2'b00;
            Opd2Sel = 3'b000;
            VX = 1'b0;
            VWEn = 4'b0000;
            WBEn = 1'b0;
            // S Signal
            MemRead3 = 3'b0;
            MemRead2 = 3'b0;
            MemRead1 = 3'b0;
            MemRead0 = 3'b0;
            MemWrite3 = 3'b0;
            MemWrite2 = 3'b0;
            MemWrite1 = 3'b0;
            MemWrite0 = 3'b0;
            Branch = 2'b10;
            xOpd1Sel = 1'b1;
            xOpd2Sel = 1'b0;
            RegWrite = 1'b1;
            xWBSel = 2'b10;
            ALUOp = 2'b11;
            xImmType = 3'b100;
        end
        else if(Opcode == 7'b1100111) begin // jalr
            // V Signal
            Opd1Sel = 2'b00;
            Opd2Sel = 3'b000;
            VX = 1'b0;
            VWEn = 4'b0000;
            WBEn = 1'b0;
            // S Signal
            MemRead3 = 3'b0;
            MemRead2 = 3'b0;
            MemRead1 = 3'b0;
            MemRead0 = 3'b0;
            MemWrite3 = 3'b0;
            MemWrite2 = 3'b0;
            MemWrite1 = 3'b0;
            MemWrite0 = 3'b0;
            Branch = 2'b10;
            xOpd1Sel = 1'b1;
            xOpd2Sel = 1'b1;
            RegWrite = 1'b1;
            xWBSel = 2'b10;
            ALUOp = 2'b11;
            xImmType = 3'b000;
        end
    end
endmodule