module VImmExt(
    input [4:0] i,
    input mode, // 0: unsigned, 1: signed
    output [31:0] o
);
    assign o[4:0] = i;
    assign o[31:5] = (mode) ? {27{i[4]}} : 27'd0;
endmodule
