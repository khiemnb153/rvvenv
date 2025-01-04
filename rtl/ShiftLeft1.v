module ShiftLeft1 #(
    parameter PC_WIDTH = 10
) (
    input [PC_WIDTH-1:0] i,
    output [PC_WIDTH-1:0] o
);
    assign o = {i[PC_WIDTH-2:0], 1'b0};

endmodule