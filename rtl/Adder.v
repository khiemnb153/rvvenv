module Adder #(
    parameter PC_WIDTH = 10
) (
    input [PC_WIDTH-1:0] addn1,
    input [PC_WIDTH-1:0] addn2,
    output [PC_WIDTH-1:0] sum
);
    assign sum = addn1 + addn2;
    
endmodule