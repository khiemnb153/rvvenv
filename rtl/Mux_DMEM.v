module Mux_DMEM #(
    parameter XLEN = 32
) (
    input [XLEN-1:0] i0,
    input [XLEN-1:0] i1,
    input sel,
    output [XLEN-1:0] o
);
    reg [2:0] t;
    always@(*) begin
        case(sel)
            1'b0: t = i0;
            1'b1: t = i1;
            1'bx: t = i1;
            default: t = i1;
        endcase
    end
    assign o = t;
endmodule