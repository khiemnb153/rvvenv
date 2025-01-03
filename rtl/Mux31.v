/*
sel|o
---|--
 00|i0
 01|i1
 1x|i2
*/
module Mux31 #(
    parameter WIDTH = 32
) (
    input [WIDTH-1:0] i0,
    input [WIDTH-1:0] i1,
    input [WIDTH-1:0] i2,
    input [1:0] sel,
    output [WIDTH-1:0] o
);
    wire [WIDTH-1:0] i01;
    
    Mux21 #(.WIDTH(WIDTH)) _Mux0(i0, i1, sel[0], i01);
    Mux21 #(.WIDTH(WIDTH)) _Mux1(i01, i2, sel[1], o);
endmodule
