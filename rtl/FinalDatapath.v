module FinalDatapath #(
    parameter XLEN = 32,
    parameter DATA_ADDR_WIDTH = 10, // DMEM_SIZE = 2 ** 10 = 1024
    parameter PC_WIDTH = 10, // IMEM_SIZE = 2 ** 6 = 64 32b-inst, 64 word
    parameter VLEN = 128,
    parameter width = 32
)(
    input clk,
    input rst_n,
    
    input VX,
    input xRegWrite, // control signals
    input [2:0] xImmType,
    input [1:0] xALUOp,
    input xOpd1Sel,
    input xOpd2Sel,
//    input [2:0] memWrite, // control write on 4 independent byte
//    input [2:0] memRead,
    input [1:0] xWBSel, // write back
    input [1:0] branch,
    
//    input [VLEN-1:0] vs3,
    input [2:0] VWe0, VWe1, VWe2, VWe3,
    input [2:0] REn0, REn1, REn2, REn3,
    
    input VWBSel,
    input [3:0] VWEn,
    input [2:0] Opd2Sel,
    input [1:0] Opd1Sel,
    output [31:0] inst_out
//    output [31:0] rs1, rs2, inst_out,
//    output [VLEN-1:0] VWB
);
    wire [31:0] vm3, vm2, vm1, vm0, rs1, rs2, VALU3, VALU2, VALU1, VALU0;
    wire [127:0] VWB, vs3;
    XDatapath #(
    .VLEN(VLEN), 
    .XLEN(XLEN), 
    .DATA_ADDR_WIDTH(DATA_ADDR_WIDTH), 
    .PC_WIDTH(PC_WIDTH)
    ) _XDatapath(
        .clk(clk),
        .rst_n(rst_n),
        .VX(VX),
        .xRegWrite(xRegWrite),
        .xImmType(xImmType),
        .xALUOp(xALUOp), 
        .xOpd1Sel(xOpd1Sel), 
        .xOpd2Sel(xOpd2Sel),
        .vm3(vm3),
        .vm2(vm2),
        .vm1(vm1),
        .vm0(vm0),
        .xWBSel(xWBSel),
        .VALU3(VALU3), 
        .VALU2(VALU2), 
        .VALU1(VALU1), 
        .VALU0(VALU0), 
        .vs3(vs3),
        .VWe0(VWe0), 
        .VWe1(VWe1), 
        .VWe2(VWe2), 
        .VWe3(VWe3), 
        .REn0(REn0), 
        .REn1(REn1),
        .REn2(REn2),
        .REn3(REn3),
        .rs1(rs1),
        .rs2(rs2),
        .inst_out(inst_out),
        .VWB(VWB)
    );
    
    VDatapath #(.VLEN(VLEN), .width(width)
    ) _VDatapath (
        .clk(clk),
        .rst_n(rst_n),
        .VWEn(VWEn),
        .WBSel(VWBSel),
        .Opd2Sel(Opd2Sel),
        .Opd1Sel(Opd1Sel),
        .inst(inst_out),
        .rs2(rs2),
        .rs1(rs1),
        .XDMEM(VWB),
        .VALUOut3(VALU3),
        .VALUOut2(VALU2),
        .VALUOut1(VALU1),
        .VALUOut0(VALU0),
        .vs3_out(vs3),
        .vm3(vm3),
        .vm2(vm2),
        .vm1(vm1),
        .vm0(vm0)
    );
endmodule