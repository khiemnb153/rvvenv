module Mux21 #(
    parameter ELEN = 32
) (
    input [ELEN-1:0] i0,
    input [ELEN-1:0] i1,
    input sel,
    output [ELEN-1:0] o
);
    assign o = (sel) ? i1 : i0;

endmodule