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
    parameter ELEN = 32
) (
    input [ELEN-1:0] i0,
    input [ELEN-1:0] i1,
    input [ELEN-1:0] i2,
    input [ELEN-1:0] i3,
    input [ELEN-1:0] i4,
    input [2:0] sel,
    output [ELEN-1:0] o
);
    wire [ELEN-1:0] i012, i34;

    Mux31 #(.ELEN(ELEN)) _Mux0(i0, i1, i2, sel[1:0], i012);
    Mux21 #(.ELEN(ELEN)) _Mux1(i3, i4, sel[1], i34);
    Mux21 #(.ELEN(ELEN)) _Mux2(i012, i34, sel[2], o);

endmodule