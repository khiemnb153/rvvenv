module Adder #(
    parameter WIDTH = 10
) (
    input [WIDTH-1:0] addn1,
    input [WIDTH-1:0] addn2,
    output [WIDTH-1:0] sum
);
    assign sum = addn1 + addn2;
    
endmodule