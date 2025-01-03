module VRegFile #(
    parameter VLEN = 128
) (
    input clk,
    input rst_n,
    input [4:0] readAddr1,
    input [4:0] readAddr2,
    input [4:0] readAddr3,
    input [4:0] writeAddr,
    input [VLEN-1:0] writeVector,
    input [3:0] writeEnable,
    output [VLEN-1:0] readVector1,
    output [VLEN-1:0] readVector2,
    output [VLEN-1:0] readVector3,
    output [VLEN-1:0] v0
);
    reg [VLEN-1:0] vregs [0:31];
    integer i;
   
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            for (i = 0; i < 32; i=i+1) begin
                vregs[i] <= {VLEN{1'b0}};
            end
        end else begin
            if (writeEnable[3]) begin
                vregs[writeAddr][VLEN-1:96] <= writeVector[VLEN-1:96];
            end
            if (writeEnable[2]) begin
                vregs[writeAddr][95:64] <= writeVector[95:64];
            end
            if (writeEnable[1]) begin
                vregs[writeAddr][63:32] <= writeVector[63:32];
            end
            if (writeEnable[0]) begin
                vregs[writeAddr][31:0] <= writeVector[31:0];
            end
        end
    end
    
    assign v0 = vregs[0];
    assign readVector1 = vregs[readAddr1];
    assign readVector2 = vregs[readAddr2];
    assign readVector3 = vregs[readAddr3];

endmodule
