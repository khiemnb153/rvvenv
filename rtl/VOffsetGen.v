module VOffsetGen(
    input [2:0] width,
    input [1:0] mop,
    input [31:0] stride,
    output [31:0] offset0,
    output [31:0] offset1,
    output [31:0] offset2,
    output [31:0] offset3
);
    wire [31:0] strideX4;
    reg [31:0] UnitStride;
    always@ (*) begin
        case(width)
            3'b110: UnitStride <= 32'd4;
            3'b101: UnitStride <= 32'd2;
            3'b000: UnitStride <= 32'd1;
            default: UnitStride <= 32'd0;
        endcase
    end
    // Khi mop[1] = 1 (mop = 2'b10) th? s? d?ng stride, n?u không stride m?c ð?nh là Unit-stride
    assign strideX4 = (mop[1]) ? stride : UnitStride;
    
    // offset0 luôn b?ng base address
    assign offset0 = 32'b0;

    // Các giá tr? offset cách nhau strideX4 ðõn v?
    assign offset1 = offset0 + strideX4;
    assign offset2 = offset1 + strideX4;
    assign offset3 = offset2 + strideX4;
    
endmodule