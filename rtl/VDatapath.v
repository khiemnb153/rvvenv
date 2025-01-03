module VDatapath
#(
    parameter VLEN = 128,
    parameter width = 32
)(
    input WBSel, clk, rst_n,
    input [2:0] Opd2Sel,
    input [1:0] Opd1Sel, 
    input [3:0] VWEn, 
    input [31:0] inst, rs2, rs1,
    input [127:0] XDMEM,
    output [31:0] VALUOut3, VALUOut2, VALUOut1, VALUOut0,
    output [VLEN-1:0] vs3_out,
    output vm3, vm2, vm1, vm0
);

    wire [31:0] offset3, offset2, offset1, offset0, ImmExtOut, op31, op21, op11, op01,
    op32, op22, op12, op02, ALUOut3, ALUOut2, ALUOut1, ALUOut0;
    wire [VLEN-1:0] vs1, vs2, vs3, v0, VALUResult, WBValue;
    wire [4:0] readAddr1, readAddr2, readAddr3, writeAddr, ALUOp;
    wire ImmExtMode, VwriteEnable;
    wire [3:0] VWen_out, Vec_vm;
    assign Vec_vm = {vm3, vm2, vm1, vm0};
    assign ImmExtMode = ((inst[31:26] == 6'b011100 || inst[31:26] == 6'b011110) && inst[14:12] == 3'b011) ? 1'b0 : 1'b1;
    VImmExt _VImmExt(inst[19:15], ImmExtMode, ImmExtOut);
    
    VOffsetGen _VOffsetGen(.width(inst[14:12]), .mop(inst[27:26]), .stride(rs2), .offset0(offset0),.offset1(offset1), .offset2(offset2), .offset3(offset3));//, inst[27:26], rs2, offset0, offset1, offset2, offset3);
    VMux_RegFile _VWen_sel (.inst25(inst[25]), .opcode(inst[6:0]), .control(VWEn), .vm(Vec_vm), .result(VWen_out));
    VRegFile #(.VLEN(VLEN)) _VRegFile(clk, rst_n, inst[19:15]/*readAddr1*/, inst[24:20]/*readAddr2*/,
    inst[11:7]/*readAddr3*/, inst[11:7]/*writeAddr*/, WBValue, VWen_out, 
    vs1, vs2, vs3, v0);
    
    VALUControl _VALUControl(inst[31:26], inst[6:0], ALUOp);
    
    or(vm3, v0[96], inst[25]);
    or(vm2, v0[64], inst[25]);
    or(vm1, v0[32], inst[25]);
    or(vm0, v0[0], inst[25]);
    
    Mux31 #(.WIDTH(width)) _ALU3Opd1(vs2[127:96], vs1[127:96], rs1, Opd1Sel, op31);
    Mux51 #(.WIDTH(width)) _ALU3Opd2(vs1[127:96], vs2[127:96], rs1, ImmExtOut, offset3, Opd2Sel, op32);
    VALU _VALU3(op31, op32, ALUOp, vm3, ALUOut3);
    
    Mux31 #(.WIDTH(width)) _ALU2Opd1(vs2[95:64], vs1[95:64], rs1, Opd1Sel, op21);
    Mux51 #(.WIDTH(width)) _ALU2Opd2(vs1[95:64], vs2[95:64], rs1, ImmExtOut, offset2, Opd2Sel, op22);
    VALU _VALU2(op21, op22, ALUOp, vm2, ALUOut2);
    
    Mux31 #(.WIDTH(width)) _ALU1Opd1(vs2[63:32], vs1[63:32], rs1, Opd1Sel, op11);
    Mux51 #(.WIDTH(width)) _ALU1Opd2(vs1[63:32], vs2[63:32], rs1, ImmExtOut, offset1, Opd2Sel, op12);
    VALU VALU1(op11, op12, ALUOp, vm1, ALUOut1);
    
    Mux31 #(.WIDTH(width)) _ALU0Opd1(vs2[31:0], vs1[31:0], rs1, Opd1Sel, op01);
    Mux51 #(.WIDTH(width)) _ALU0Opd2(vs1[31:0], vs2[31:0], rs1, ImmExtOut, offset0, Opd2Sel, op02);
    VALU VALU0(op01, op02, ALUOp, vm0, ALUOut0);
    
    
    assign VALUResult = {ALUOut3, ALUOut2, ALUOut1, ALUOut0};
    assign VALUOut3 = ALUOut3;
    assign VALUOut2 = ALUOut2;
    assign VALUOut1 = ALUOut1;
    assign VALUOut0 = ALUOut0;
    assign vs3_out = vs3;
    Mux21_128bit #(.VLEN(VLEN)) _WBSel(VALUResult, XDMEM, WBSel, WBValue);
endmodule