module XController
(
    input [6:0] Opcode, Funct7,
    input [2:0] Funct3,
    output reg xOpd1Sel, xOpd2Sel, RegWrite,
    output reg [1:0] ALUOp, xWBSel, Branch,
    output reg [2:0] xImmType, MemRead, MemWrite
);
//  xWBSel
//  00: ALUResult
//  01: MemData
//  10: PC+4
    always@(*) begin
        if(Opcode == 7'b0000011) begin // load
            Branch = 2'b00;
            if (Funct3 == 3'b000)
                MemRead = 3'b001;       // lb
            else if (Funct3 == 3'b001)
                MemRead = 3'b011;       // lh
            else if (Funct3 == 3'b010)
                MemRead = 3'b111;       // lw
            else MemRead = 3'b000;
            MemWrite = 1'b0;
            xOpd1Sel = 1'b0;
            xOpd2Sel = 1'b1;
            RegWrite = 1'b1;
            xWBSel = 2'b01;
            ALUOp = 2'b00;
            xImmType = 3'b000;                        
        end 
        
        else if (Opcode == 7'b0100011) begin // store
            Branch = 2'b00;
            MemRead = 1'b0;
            if (Funct3 == 3'b000)
                MemWrite = 3'b001;      // sb
            else if (Funct3 == 3'b001)
                MemWrite = 3'b011;      // sh
            else if (Funct3 == 3'b010)
                MemWrite = 3'b111;      // sw
            else MemWrite = 3'b000;
            xOpd1Sel = 1'b0;
            xOpd2Sel = 1'b1;
            RegWrite = 1'b0;
            xWBSel = 2'bxx;
            ALUOp = 2'b00;
            xImmType = 3'b001;
        end
        
        else if (Opcode == 7'b0110011) begin // R-type
            Branch = 2'b00;
            MemRead = 1'b0;
            MemWrite = 1'b0;
            xOpd1Sel = 1'b0;
            xOpd2Sel = 1'b0;
            RegWrite = 1'b1;
            xWBSel = 2'b00;
            ALUOp = 2'b10;
            xImmType = 3'bxxx;
        end
        
        else if (Opcode == 7'b0110011) begin // I-type
            Branch = 2'b00;
            MemRead = 1'b0;
            MemWrite = 1'b0;
            xOpd1Sel = 1'b0;
            xOpd2Sel = 1'b1;
            RegWrite = 1'b1;
            xWBSel = 2'b00;
            ALUOp = 2'b10;
            xImmType = 3'b000;
        end
        
        else if (Opcode == 7'b0110011 && Funct3 == 3'b101 && Funct7 == 7'b0100000) begin // srai
            Branch = 2'b00;
            MemRead = 1'b0;
            MemWrite = 1'b0;
            xOpd1Sel = 1'b0;
            xOpd2Sel = 1'b1;
            RegWrite = 1'b1;
            xWBSel = 2'b00;
            ALUOp = 2'b10;
            xImmType = 3'b101;
        end
        
        else if (Opcode == 7'b1100011) begin // B-type
            Branch = 2'b01;
            MemRead = 1'b1;
            MemWrite = 1'b0;
            xOpd1Sel = 1'b1;
            xOpd2Sel = 1'b1;
            RegWrite = 1'b0;
            xWBSel = 2'b00;
            ALUOp = 2'b01;
            xImmType = 3'b000;
        end
        
        else if (Opcode == 7'b0110111) begin // lui
            Branch = 2'b00;
            MemRead = 1'bx;
            MemWrite = 1'b0;
            xOpd1Sel = 1'bx;
            xOpd2Sel = 1'b1;
            RegWrite = 1'b1;
            xWBSel = 2'b00;
            ALUOp = 2'b11;
            xImmType = 3'b011;
        end
        
        else if (Opcode == 7'b0010111) begin // auipc
            Branch = 2'b00;
            MemRead = 1'bx;
            MemWrite = 1'b0;
            xOpd1Sel = 1'b1;
            xOpd2Sel = 1'b1;
            RegWrite = 1'b1;
            xWBSel = 2'b00;
            ALUOp = 2'b11;
            xImmType = 3'b011;
        end
        
        else if(Opcode == 7'b1101111) begin // jal
            Branch = 2'b10;
            MemRead = 1'bx;
            MemWrite = 1'b0;
            xOpd1Sel = 1'b1;
            xOpd2Sel = 1'b1;
            RegWrite = 1'b1;
            xWBSel = 2'b10;
            ALUOp = 2'b11;
            xImmType = 3'b100;
        end
        
        else if(Opcode == 7'b1100111) begin // jalr
            Branch = 2'b10;
            MemRead = 1'bx;
            MemWrite = 1'b0;
            xOpd1Sel = 1'b0;
            xOpd2Sel = 1'b1;
            RegWrite = 1'b1;
            xWBSel = 2'b10;
            ALUOp = 2'b11;
            xImmType = 3'b000;
        end
    end
endmodule