module XRegFile #(
    parameter XLEN = 32
) (
    input clk,
    input rst_n,
    input [4:0] readAddr1,
    input [4:0] readAddr2,
    input [4:0] writeAddr,
    input writeEnable,
    input [XLEN-1:0] writeData,
    output [XLEN-1:0] readData1,
    output [XLEN-1:0] readData2
);
    reg [XLEN-1:0] xregs [0:31];
    integer i;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            xregs[0] <= {XLEN{1'b0}};
            for(i = 1; i<32;i = i+1) begin
                xregs[i] <= {XLEN{1'b0}};
            end
        end else begin
            if (writeEnable && writeAddr != 4'd0) begin
                xregs[writeAddr] <= writeData;
//                xregs[writeAddr][7:0] <= writeData[31:24];
//                xregs[writeAddr][15:8] <= writeData[23:16];
//                xregs[writeAddr][23:16] <= writeData[15:8];
//                xregs[writeAddr][31:24] <= writeData[7:0];
            end
        end
    end
    
    assign readData1 = (readAddr1 != 4'd0) ? xregs[readAddr1] : {XLEN{1'b0}};
    assign readData2 = (readAddr2 != 4'd0) ? xregs[readAddr2] : {XLEN{1'b0}};
    
endmodule
