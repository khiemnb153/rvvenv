`timescale 1ns/1ps
module tb_RISC_V_TEST();
    parameter XLEN = 32;
    parameter DATA_ADDR_WIDTH = 10; // DMEM_SIZE = 2 ** 10 = 1024
    parameter PC_WIDTH = 10; // IMEM_SIZE = 2 ** 6 = 64 32b-inst, 64 word
    parameter VLEN = 128;
    parameter ELEN = 32;
    parameter NUM_REGS = 32; // number of vector registers
    parameter IMEM_FILE = "";
    parameter DMEM_FILE = "";
    parameter VREG_LOG = "";
    parameter XREG_LOG = "";
    parameter DMEM_LOG = "";
    parameter PC_LOG = "";

    reg clk;
    reg rst_n;

    RISC_V_Vector #(
        .XLEN(XLEN),
        .DATA_ADDR_WIDTH(DATA_ADDR_WIDTH),
        .PC_WIDTH(PC_WIDTH),
        .VLEN(VLEN),
        .ELEN(ELEN),
        .DMEM_FILE(DMEM_FILE),
        .IMEM_FILE(IMEM_FILE)
    ) DUT(
        .clk(clk),
        .rst_n(rst_n)
    );

    reg [127:0] prev_vregs [0:NUM_REGS-1]; // Luu trang thai truoc cua vregs
    reg [31:0] prev_xregs [1:NUM_REGS-1];
    reg [7:0] prev_dmem [0:2**DATA_ADDR_WIDTH];
    reg initialized; // initialize flag
    reg [31:0] last_time; // time
    reg [31:0] clk_period; // clock period
    integer vreg_logfile; // File descriptor cho VRegFile
    integer xreg_logfile; // File descriptor cho XRegFile
    integer dmem_logfile;
    integer pc_logfile;
    integer i;

    always begin
        #5 clk = ~clk;
    end

    initial begin
        clk = 0;
        rst_n = 0;
        initialized = 0; // Chua khoi tao
        vreg_logfile = $fopen(VREG_LOG, "w"); // Mo file cho VRegFile
        xreg_logfile = $fopen(XREG_LOG, "w"); // Mo file cho XRegFile
        dmem_logfile = $fopen(DMEM_LOG, "w");
        pc_logfile = $fopen(PC_LOG, "w");
        #10
        initialized = 1; // Bat dau theo doi thay doi tu chu ki dau tien
        rst_n = 1; // Giai phong reset
    end
    
    initial begin
        #20 wait(DUT.inst_out == 32'b0);
        $fclose(vreg_logfile); // Dong file VRegFile
        $fclose(xreg_logfile); // Dong file XRegFile
        $fclose(dmem_logfile);
        $fclose(pc_logfile);
        $stop();
    end

    always @(posedge clk) begin
    if ($time > 0) begin // Bo qua chu ki dau tien
        clk_period = $time - last_time; // tinh chu ki
    end
    last_time = $time; // cap nhat thoi gian hien tai de tinh chu ki
end
    
// VRegFile
    always @(posedge clk) begin
        if (initialized) begin
            // Kiem tra thay doi cua vregs
            for (i = 0; i < NUM_REGS; i = i + 1) begin
                if (DUT.FDatapath._VDatapath._VRegFile.vregs[i] !== prev_vregs[i]) begin
                    $fwrite(vreg_logfile, "Time=%0d VRF[%0d]=0x%32h\n", 
                             $time - clk_period, i, DUT.FDatapath._VDatapath._VRegFile.vregs[i]);
                    prev_vregs[i] <= DUT.FDatapath._VDatapath._VRegFile.vregs[i]; // C?p nh?t tr?ng th�i m?i
                end
            end
        end else begin
            //Khoi tao gia tri ban dau cho prev_rvegs
            for (i = 0; i < NUM_REGS; i = i + 1) begin
                prev_vregs[i] <= DUT.FDatapath._VDatapath._VRegFile.vregs[i];
            end
        end
    end

//XregFile    
    always @(posedge clk) begin
        if(initialized) begin
            for (i = 1; i < NUM_REGS; i = i + 1) begin
                if (DUT.FDatapath._XDatapath._XRegFile.xregs[i] !== prev_xregs[i]) begin
                    $fwrite(xreg_logfile, "Time=%0d XRF[%0d]=0x%8h\n", 
                             $time - clk_period, i, DUT.FDatapath._XDatapath._XRegFile.xregs[i]);
                    prev_xregs[i] <= DUT.FDatapath._XDatapath._XRegFile.xregs[i]; // C?p nh?t tr?ng th�i m?i
                end
            end
        end else begin
            for (i = 1; i < NUM_REGS; i = i + 1) begin
                prev_xregs[i] <= DUT.FDatapath._XDatapath._XRegFile.xregs[i];
            end
        end
    end
    
//DMEM
    always @(posedge clk) begin
        if(initialized) begin
            for (i = 0; i < 2**DATA_ADDR_WIDTH; i = i + 1) begin
                if (DUT.FDatapath._XDatapath._DMEM.mem[i] !== prev_dmem[i]) begin
                    $fwrite(dmem_logfile, "Time=%0d DMEM[%0d]=0x%2h\n", 
                             $time - clk_period, i, DUT.FDatapath._XDatapath._DMEM.mem[i]);
                    prev_dmem[i] <= DUT.FDatapath._XDatapath._DMEM.mem[i]; // C?p nh?t tr?ng th�i m?i
                end
            end
        end else begin
            for (i = 0; i < 2**DATA_ADDR_WIDTH; i = i + 1) begin
                prev_dmem[i] <= DUT.FDatapath._XDatapath._DMEM.mem[i];
            end
        end
    end

// PC
    always @(posedge clk) begin
        if(initialized) begin
            if(DUT.FDatapath._XDatapath._IMEM.inst !== 32'hxxxxxxxx) begin
                $fwrite(pc_logfile, "Time=%0d PC=0x%3h\n", 
                                $time - clk_period, DUT.FDatapath._XDatapath._IMEM.pc);
            end
        end
    end
endmodule

