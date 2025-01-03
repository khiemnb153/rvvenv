module Mux21 #(
    parameter WIDTH = 32
) (
    input [WIDTH-1:0] i0,
    input [WIDTH-1:0] i1,
    input sel,
    output [WIDTH-1:0] o
);
    assign o = (sel) ? i1 : i0;

endmodule