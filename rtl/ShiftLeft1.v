module ShiftLeft1 #(
    parameter WIDTH = 10
) (
    input [WIDTH-1:0] i,
    output [WIDTH-1:0] o
);
    assign o = {i[WIDTH-2:0], 1'b0};

endmodule