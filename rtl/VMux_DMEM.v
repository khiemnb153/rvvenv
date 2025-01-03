module VMux_DMEM (
input inst25,
input [6:0] opcode,
input [2:0] control,
input [2:0] vm,
output [2:0] result
);
    assign result = ((opcode == 7'b0000111 || opcode == 7'b0100111) && inst25 == 1'b0) ? vm : control; 

endmodule