module IMEM #(
    parameter PC_WIDTH = 10
) (
    input [PC_WIDTH-1:0] pc,
    output [31:0] inst
);
    parameter MEM_SIZE = 2 ** (PC_WIDTH-2);
    reg [31:0] mem [0:MEM_SIZE-1];
    
    initial
        $readmemb("../tests/test_0/imem.mem", mem, 0);
    
    assign inst = mem[pc[PC_WIDTH-1:2]];       

endmodule
