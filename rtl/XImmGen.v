module XImmGen (
    input [31:7] i,
    input [2:0] type,
    output reg [31:0] o
);
    always @(*) begin
        case (type)
            3'b000: o <= {{21{i[31]}}, i[30:20]}; // I-immediate
            3'b001: o <= {{21{i[31]}}, i[30:25], i[11:7]}; // S-immediate
            3'b010: o <= {{20{i[31]}}, i[7], i[30:25], i[11:8], 1'b0}; // B-immediate
            3'b011: o <= {i[31], i[30:12], 12'b0}; // U-immediate
            3'b100: o <= {{12{i[31]}}, i[19:12], i[20], i[30:21], 1'b0}; // J-immediate
            3'b101: o <= {27'd0, i[24:20]}; // SRAI
            default: o <= 32'b0;
        endcase
    end
    
endmodule