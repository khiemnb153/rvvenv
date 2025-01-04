/*
sel|o
---|--
 00|i0
 01|i1
 1x|i2
*/
module Mux31 #(
    parameter ELEN = 32
) (
    input [ELEN-1:0] i0,
    input [ELEN-1:0] i1,
    input [ELEN-1:0] i2,
    input [1:0] sel,
    output [ELEN-1:0] o
);
    wire [ELEN-1:0] i01;
    
    Mux21 #(.ELEN(ELEN)) _Mux0(i0, i1, sel[0], i01);
    Mux21 #(.ELEN(ELEN)) _Mux1(i01, i2, sel[1], o);
endmodule
