module VMux_RegFile (
input inst25,
input [6:0] opcode,
input [3:0] control,
input [3:0] vm,
output [3:0] result
);
    assign result = (opcode == 7'b0000111 && inst25 == 1'b0) ? vm : control; 

endmodule