module VMux_LoadStore (
input inst25,
input [6:0] opcode,
input [3:0] control,
input [3:0] vm,
output [3:0] result
);
    assign result = ((opcode == 7'b0000111 || opcode == 7'b0100111) && inst25 == 1'b0) ? vm : control; 

endmodule