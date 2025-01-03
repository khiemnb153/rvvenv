module RISC_V_Vector #(
    parameter XLEN = 32,
    parameter DATA_ADDR_WIDTH = 10, // DMEM_SIZE = 2 ** 10 = 1024
    parameter PC_WIDTH = 10, // IMEM_SIZE = 2 ** 6 = 64 32b-inst, 64 word
    parameter VLEN = 128,
    parameter width = 32
)

(
    input clk,
    input rst_n
);
    wire VX, xRegWrite, xOpd1Sel, xOpd2Sel, VWBSel;
    wire [3:0] VWEn;
    wire [2:0] xImmType, VWe0, VWe1, VWe2, VWe3, REn0, REn1, REn2, REn3, Opd2Sel;
    wire [1:0] xALUOp, xWBSel, branch, Opd1Sel;
    wire [31:0] inst_out;
    FinalDatapath #(
            .XLEN(XLEN),
            .DATA_ADDR_WIDTH(DATA_ADDR_WIDTH),
            .PC_WIDTH(PC_WIDTH),
            .VLEN(VLEN),
            .width(width)
        ) FDatapath (
        .clk(clk),
        .rst_n(rst_n),
        .VX(VX),
        .xRegWrite(xRegWrite),
        .xImmType(xImmType),
        .xALUOp(xALUOp),
        .xOpd1Sel(xOpd1Sel),
        .xOpd2Sel(xOpd2Sel),
        .xWBSel(xWBSel),
        .branch(branch),
        .VWe0(VWe0),
        .VWe1(VWe1),
        .VWe2(VWe2),
        .VWe3(VWe3),
        .REn0(REn0),
        .REn1(REn1),
        .REn2(REn2),
        .REn3(REn3),
        .VWEn(VWEn),
        .VWBSel(VWBSel),
        .Opd2Sel(Opd2Sel),
        .Opd1Sel(Opd1Sel),
        .inst_out(inst_out)
    );
    FinalController FController(
        .inst(inst_out),
        .Opd2Sel(Opd2Sel),
        .Opd1Sel(Opd1Sel),
        .VX(VX),
        .VWEn(VWEn),
        .WBEn(VWBSel),
        .xOpd1Sel(xOpd1Sel),
        .xOpd2Sel(xOpd2Sel),
        .RegWrite(xRegWrite),
        .ALUOp(xALUOp),
        .xWBSel(xWBSel),
        .Branch(branch),
        .xImmType(xImmType),
        .MemRead3(REn3),
        .MemRead2(REn2),
        .MemRead1(REn1),
        .MemRead0(REn0),
        .MemWrite3(VWe3),
        .MemWrite2(VWe2),
        .MemWrite1(VWe1),
        .MemWrite0(VWe0)
    );
endmodule