module DMEM #(
    parameter ADDR_WIDTH = 10,
    parameter DMEM_FILE = ""
) (
    input clk,
       
    input [2:0] writeEnable0,
    input [2:0] writeEnable1,
    input [2:0] writeEnable2,
    input [2:0] writeEnable3, 
    input [ADDR_WIDTH-1:0] addr0,
    input [ADDR_WIDTH-1:0] addr1,
    input [ADDR_WIDTH-1:0] addr2,
    input [ADDR_WIDTH-1:0] addr3,
    input [31:0] writeData0,
    input [31:0] writeData1,
    input [31:0] writeData2,
    input [31:0] writeData3,
    
    input [2:0] readEnable0,
    input [2:0] readEnable1,
    input [2:0] readEnable2,
    input [2:0] readEnable3,
    
    output [31:0] readData0,
    output [31:0] readData1,
    output [31:0] readData2,
    output [31:0] readData3
);
    parameter MEM_SIZE = 2 ** ADDR_WIDTH;
    reg [7:0] mem [MEM_SIZE-1:0];
    integer i;

    initial begin
        for(i = 0; i<MEM_SIZE ; i = i+1) begin
            mem[i] = 8'b0;
        end
        $readmemb(DMEM_FILE, mem, 0);
    end
    always @(posedge clk) begin

        if (writeEnable0[0]) mem[addr0+0] <= writeData0[7:0];
        if (writeEnable0[1]) mem[addr0+1] <= writeData0[15:8];
        if (writeEnable0[2]) mem[addr0+2] <= writeData0[23:16];
        if (writeEnable0[2]) mem[addr0+3] <= writeData0[31:24];
            
        if (writeEnable1[0]) mem[addr1+0] <= writeData1[7:0];
        if (writeEnable1[1]) mem[addr1+1] <= writeData1[15:8];
        if (writeEnable1[2]) mem[addr1+2] <= writeData1[23:16];
        if (writeEnable1[2]) mem[addr1+3] <= writeData1[31:24];
            
        if (writeEnable2[0]) mem[addr2+0] <= writeData2[7:0];
        if (writeEnable2[1]) mem[addr2+1] <= writeData2[15:8];
        if (writeEnable2[2]) mem[addr2+2] <= writeData2[23:16];
        if (writeEnable2[2]) mem[addr2+3] <= writeData2[31:24];
            
        if (writeEnable3[0]) mem[addr3+0] <= writeData3[7:0];
        if (writeEnable3[1]) mem[addr3+1] <= writeData3[15:8];
        if (writeEnable3[2]) mem[addr3+2] <= writeData3[23:16];
        if (writeEnable3[2]) mem[addr3+3] <= writeData3[31:24];
    end
    
    assign readData0[31:24]         = (readEnable0[2]) ? mem[addr0+3] : 8'd0;
    assign readData0[23:16]         = (readEnable0[2]) ? mem[addr0+2] : 8'd0;
    assign readData0[15:8]          = (readEnable0[1]) ? mem[addr0+1] : 8'd0;
    assign readData0[7:0]           = (readEnable0[0]) ? mem[addr0+0] : 8'd0;
    
    assign readData1[31:24]         = (readEnable1[2]) ? mem[addr1+3] : 8'd0;
    assign readData1[23:16]         = (readEnable1[2]) ? mem[addr1+2] : 8'd0;
    assign readData1[15:8]          = (readEnable1[1]) ? mem[addr1+1] : 8'd0;
    assign readData1[7:0]           = (readEnable1[0]) ? mem[addr1+0] : 8'd0;
    
    assign readData2[31:24]         = (readEnable2[2]) ? mem[addr2+3] : 8'd0;
    assign readData2[23:16]         = (readEnable2[2]) ? mem[addr2+2] : 8'd0;
    assign readData2[15:8]          = (readEnable2[1]) ? mem[addr2+1] : 8'd0;
    assign readData2[7:0]           = (readEnable2[0]) ? mem[addr2+0] : 8'd0;
    
    assign readData3[31:24]         = (readEnable3[2]) ? mem[addr3+3] : 8'd0;
    assign readData3[23:16]         = (readEnable3[2]) ? mem[addr3+2] : 8'd0;
    assign readData3[15:8]          = (readEnable3[1]) ? mem[addr3+1] : 8'd0;
    assign readData3[7:0]           = (readEnable3[0]) ? mem[addr3+0] : 8'd0;
    
endmodule
