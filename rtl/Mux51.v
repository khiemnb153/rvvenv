/*
sel|o
---|--
000|i0
001|i1
01x|i2
10x|i3
11x|i4
*/

module Mux51 #(
    parameter WIDTH = 32
) (
    input [WIDTH-1:0] i0,
    input [WIDTH-1:0] i1,
    input [WIDTH-1:0] i2,
    input [WIDTH-1:0] i3,
    input [WIDTH-1:0] i4,
    input [2:0] sel,
    output [WIDTH-1:0] o
);
    wire [WIDTH-1:0] i012, i34;

    Mux31 #(.WIDTH(WIDTH)) _Mux0(i0, i1, i2, sel[1:0], i012);
    Mux21 #(.WIDTH(WIDTH)) _Mux1(i3, i4, sel[1], i34);
    Mux21 #(.WIDTH(WIDTH)) _Mux2(i012, i34, sel[2], o);

endmodule