module top (
    input  wire                clk,
    input  wire               reset,
    output wire [31 : 0]  data_addr,
    output wire [31 : 0] write_data,
    output wire           mem_write
);
    wire [31 : 0]        pc;
    wire [31 : 0]     instr;
    wire [31 : 0] read_data;

    riscvsingle riscv (
        .clk(clk),
        .reset(reset),
        .instr(instr),
        .read_data(read_data),
        .pc(pc),
        .alu_result(data_addr),
        .write_data(write_data),
        .mem_write(mem_write)
    );

    imem imem (
        .a(pc),
        .rd(instr)
    );

    dmem dmem (
        .clk(clk),
        .we(mem_write),
        .a(data_addr),
        .wd(write_data),
        .rd(read_data)
    );

endmodule