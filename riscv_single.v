module riscvsingle (
    input  wire                  clk,
    input  wire                reset,
    input  wire  [31 : 0]      instr,
    input  wire  [31 : 0]  read_data,
    output wire  [31 : 0]         pc,
    output wire  [31 : 0] alu_result,
    output wire  [31 : 0] write_data,
    output wire            mem_write
);
    wire            ALU_src_A;
    wire            ALU_src_B;
    wire            reg_write;
    wire                 jump;
    wire [3 : 0]        flags;
    wire [1 : 0]   result_src;
    wire [2 : 0]      imm_src;
    wire [3 : 0]  alu_control;
    wire [1 : 0]    load_type;
    wire           store_type;
    wire        pc_target_src;
    wire               pc_src;

    controller c (
        .op(instr[6 : 0]),
        .funct3(instr[14 : 12]),
        .funct7b5(instr[30]),
        .flags(flags),
        .result_src(result_src),
        .mem_write(mem_write),
        .pc_src(pc_src),
        .ALU_src_A(ALU_src_A),
        .ALU_src_B(ALU_src_B),
        .reg_write(reg_write),
        .imm_src(imm_src),
        .jump(jump),
        .alu_control(alu_control),
        .load_type(load_type),
        .store_type(store_type),
        .pc_target_src(pc_target_src)
    );

    datapath dp (
        .clk(clk),
        .reset(reset),
        .result_src(result_src),
        .pc_src(pc_src),
        .ALU_src_A(ALU_src_A),
        .ALU_src_B(ALU_src_B),
        .reg_write(reg_write),
        .imm_src(imm_src),
        .alu_control(alu_control),
        .load_type(load_type),
        .store_type(store_type),
        .pc_target_src(pc_target_src),
        .instr(instr),
        .read_data(read_data),
        .flags(flags),
        .pc(pc),
        .alu_result(alu_result),
        .write_data(write_data)
    );

endmodule