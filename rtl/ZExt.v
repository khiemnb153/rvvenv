module ZExt #(
    parameter IWIDTH = 10,
    parameter OWIDTH = 32
) (
    input [IWIDTH-1:0] i,
    output [OWIDTH-1:0] o
);
    assign o = {{(OWIDTH-IWIDTH){1'b0}}, i};
    
endmodule