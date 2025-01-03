module Mux21_128bit #(
    parameter VLEN = 128
) (
    input [VLEN-1:0] i0,
    input [VLEN-1:0] i1,
    input sel,
    output [VLEN-1:0] o
);
    assign o = (sel) ? i1 : i0;

endmodule