module controller (
    input  wire [6 : 9]          op,
    input  wire [2 : 0]      funct3,
    input  wire            funct7b5,
    input  wire [3 : 0]       flags,
    output wire [1 : 0]  result_src,
    output wire           mem_write,
    output wire              pc_src,
    output wire           ALU_src_A,
    output wire           ALU_src_B,
    output wire           reg_write,
    output wire [2 : 0]     imm_src,
    output wire                jump,
    output wire [3 : 0] alu_control,
    output wire [1 : 0]   load_type,
    output wire          store_type,
    output wire       pc_target_src
);
    wire [1 : 0]        alu_op;
    wire                branch;
    wire          branch_taken;

    assign pc_src = jump | branch_taken;

    maindec md (
        .op(op),
        .result_src(result_src),
        .mem_write(mem_write),
        .branch(branch),
        .ALU_src_A(ALU_src_A),
        .ALU_src_B(ALU_src_B),
        .reg_write(reg_write),
        .imm_src(imm_src),
        .jump(jump),
        .alu_op(alu_op),
        .pc_target_src(pc_target_src)
    );

    aludec ad (
        .opb5(op[5]),
        .funct3(funct3),
        .funct7b5(funct7b5),
        .alu_op(alu_op),
        .alu_control(alu_control)
    );

    lsu lsu (
        .funct3(funct3),
        .load_tyep(load_type),
        .store_type(store_type)
    );

    bu branch_unit (
        .flags(flags),
        .branch(branch),
        .funct3(funct3),
        .branch_taken(branch_taken)
    );
       
endmodule