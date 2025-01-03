module PC #(
    parameter PC_WIDTH = 10
) (
    input clk,
    input rst_n,
    input [PC_WIDTH-1:0] pcIn,
    output [PC_WIDTH-1:0] pcOut
);
    reg [PC_WIDTH-1:0] current;
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            current <= 0;
        else
            current <= pcIn;
    end
    
    assign pcOut = current;
    
endmodule
