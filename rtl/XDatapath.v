module XDatapath #(
    parameter VLEN = 128,
    parameter XLEN = 32,
    parameter DATA_ADDR_WIDTH = 10, // DMEM_SIZE = 2 ** 10 = 1024
    parameter PC_WIDTH = 10 // IMEM_SIZE = 2 ** 6 = 64 32b-inst, 64 word
) (
    input clk,
    input rst_n,
    
    input VX,
    input xRegWrite, // control signals
    input [2:0] xImmType,
    input [1:0] xALUOp,
    input xOpd1Sel,
    input xOpd2Sel,
    input vm3, vm2, vm1, vm0,
//    input [2:0] memWrite, // control write on 4 independent byte
//    input [2:0] memRead,
    input [1:0] xWBSel, // write back
    input [1:0] branch,
    input [XLEN-1:0] VALU3, VALU2, VALU1, VALU0,
    input [VLEN-1:0] vs3,
    input [2:0] VWe0, VWe1, VWe2, VWe3,
    input [2:0] REn0, REn1, REn2, REn3,
    
     // to controller
    output [31:0] rs1, rs2, inst_out,
    output [VLEN-1:0] VWB
);
    wire [PC_WIDTH-1:0] pcPlus4;
    wire [PC_WIDTH-1:0] pcBranch;
    wire [PC_WIDTH-1:0] nextPC;
    wire [PC_WIDTH-1:0] pc;
    wire [1:0] pcSel;
    wire [31:0] inst;

    wire [31:0] WBData0, WBData1, WBData2, WBData3, WBDataOut;
    wire [31:0] VWEn0, VWEn1, VWEn2, VWEn3;
    wire [31:0] rs1Data;
    wire [31:0] rs2Data;
    wire [31:0] xImm;
    wire [3:0] xALUSel;
    wire [31:0] xOpd1;
    wire [31:0] xOpd2;
    wire [31:0] xALUResult;
    wire xALUResultIsZero;
    wire [1:0] JB;
    wire [127:0] memData;
    wire [31:0] WDataMux;
    wire [31:0] AddrMux;
    wire [6:0] opcode;
    assign opcode = inst[6:0];

    and (pcSel[0], branch[0], JB);
    and (pcSel[1], branch[1], JB);

    wire [PC_WIDTH-1:0] pcOffsetByByte;
    
    ShiftLeft1 #(
        .WIDTH(PC_WIDTH)
    ) _PCShifter(
        .i(xImm[PC_WIDTH-1:0]),
        .o(pcOffsetByByte)
    );

    Adder #(
        .WIDTH(PC_WIDTH)
    ) _PCAdder(
        .addn1(pc),
        .addn2('d4),
        .sum(pcPlus4)
    );

    Adder #(
        .WIDTH(PC_WIDTH)
    ) _PCBranchAddr(
        .addn1(pc),
        .addn2(pcOffsetByByte),
        .sum(pcBranch)        
    );

// *********CHECK
    Mux31 #(
        .WIDTH(PC_WIDTH)
    ) _NextPCSel(
        .i0(pcPlus4),
        .i1(pcBranch),
        .i2(xALUResult),
        .sel(pcSel),
        .o(nextPC)
    );

    PC #(
        .PC_WIDTH(PC_WIDTH)
    ) _PC(
        .clk(clk),
        .rst_n(rst_n),
        .pcIn(nextPC),
        .pcOut(pc)
    );

    IMEM #(
        .PC_WIDTH(PC_WIDTH)
    ) _IMEM(
        .pc(pc),
        .inst(inst)
    );

    XRegFile #(
        .XLEN(XLEN)
    ) _XRegFile(
        .clk(clk),
        .rst_n(rst_n),
        .readAddr1(inst[19:15]),
        .readAddr2(inst[24:20]),
        .writeAddr(inst[11:7]),
        .writeEnable(xRegWrite),
        .writeData(WBDataOut),
        .readData1(rs1Data),
        .readData2(rs2Data)
    );

    XImmGen _XImmGen(
        .i(inst[31:7]),
        .type(xImmType),
        .o(xImm)
    );

    XALUControl _XALUControl (
        .aluOp(xALUOp),
        .funct({inst[30], inst[14:12]}),
        .Opcode(opcode),
        .aluSel(xALUSel)
    );

    wire [31:0] extPC;
    ZExt #(
        .IWIDTH(PC_WIDTH),
        .OWIDTH(XLEN)
    ) _PCExt(
        .i(pc),
        .o(extPC)
    );

    Mux21 _XOpd2Sel(
        .i0(extPC),
        .i1(rs1Data),
        .sel(xOpd1Sel),
        .o(xOpd1)
    );

    Mux21 _XOpd1Sel(
        .i0(rs2Data),
        .i1(xImm),
        .sel(xOpd2Sel),
        .o(xOpd2)
    );

    XALU _XALU(
        .opd1(xOpd1),
        .opd2(xOpd2),
        .sel(xALUSel),
        .funct3(inst[14:12]),
        .opcode(opcode),
        .result(xALUResult),
        .zero(xALUResultIsZero),
        .JB(JB)
    );

    Mux21 _WDataSel(
        .i0(rs2Data),
        .i1(vs3[31:0]),
        .sel(VX),
        .o(WDataMux)
    );
    
    Mux21 _AddrSel(
        .i0(xALUResult),
        .i1(VALU0),
        .sel(VX),
        .o(AddrMux)
    );
    
    Mux_DMEM _VWe0(
        .i0(32'b0), 
        .i1(VWe0),
        .sel(vm0),
        .o(VWEn0));
    
    Mux_DMEM _VWe1(
        .i0(32'b0), 
        .i1(VWe1),
        .sel(vm1),
        .o(VWEn1));
        
    Mux_DMEM _VWe2(
        .i0(32'b0), 
        .i1(VWe2),
        .sel(vm2),
        .o(VWEn2));
    
     Mux_DMEM _VWe3(
        .i0(32'b0), 
        .i1(VWe3),
        .sel(vm3),
        .o(VWEn3));
    
    
    DMEM #(
        .ADDR_WIDTH(DATA_ADDR_WIDTH)
    ) _DMEM(
        .clk(clk),
        
        //***//
        .writeEnable0(VWEn0),
        .writeEnable1(VWEn1),
        .writeEnable2(VWEn2),
        .writeEnable3(VWEn3),
        
        .addr0(AddrMux),
        .addr1(VALU1),
        .addr2(VALU2),
        .addr3(VALU3),
        
        .writeData0(WDataMux), // ***//
        .writeData1(vs3[63:32]),
        .writeData2(vs3[95:64]),
        .writeData3(vs3[127:96]),
        
        //***//
        .readEnable0(REn0),
        .readEnable1(REn1),
        .readEnable2(REn2),
        .readEnable3(REn3),
        
        .readData0(memData[31:0]),
        .readData1(memData[63:32]),
        .readData2(memData[95:64]),
        .readData3(memData[127:96])
    );

    
    DataExt _DataExt0(
        .dataIn(memData[31:0]),
        .mode(inst[14]),
        .readEnable(REn0),
        .opcode(opcode),
        .dataOut(WBData0)
    );
    
    DataExt _DataExt1(
        .dataIn(memData[63:32]),
        .mode(inst[14]),
        .readEnable(REn1),
        .opcode(opcode),
        .dataOut(WBData1)
    );
    
    DataExt _DataExt2(
        .dataIn(memData[95:64]),
        .mode(inst[14]),
        .readEnable(REn2),
        .opcode(opcode),
        .dataOut(WBData2)
    );
    
    DataExt _DataExt3(
        .dataIn(memData[127:96]),
        .mode(inst[14]),
        .readEnable(REn3),
        .opcode(opcode),
        .dataOut(WBData3)
    );
    
    wire [31:0] extPcPlus4;
    
    ZExt #(
        .IWIDTH(PC_WIDTH),
        .OWIDTH(XLEN)
    ) _PC4Ext(
        .i(pcPlus4),
        .o(extPcPlus4)
    );
    
    Mux31 _WBSel(
        .i0(xALUResult),
        .i1(WBData0),
        .i2(extPcPlus4),
        .sel(xWBSel),
        .o(WBDataOut)
    );
    assign rs1 = rs1Data;
    assign rs2 = rs2Data;
    assign inst_out = inst;
    assign VWB = {WBData3, WBData2, WBData1, WBData0};
endmodule