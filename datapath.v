module datapath (
    input  wire                 clk,
    input  wire               reset,
    input  wire [1 : 0]  result_src,
    inout  wire              pc_src,
    input  wire           ALU_src_A,
    input  wire           ALU_src_B,
    input  wire           reg_write,
    input  wire [2 : 0]     imm_src,
    input  wire [3 : 0] alu_control,
    input  wire [1 : 0]   load_type,
    input  wire          store_type,
    input  wire       pc_target_src,
    input  wire [31 : 0]      instr,
    input  wire [31 : 0]  read_data,
    output wire [3 : 0]       flags,
    output wire [31 : 0]         pc,
    output wire [31 : 0] alu_result,
    output wire [31 : 0] write_data
);  
    wire [31 : 0] pc_next;
    wire [31 : 0] pc_plus4;
    wire [31 : 0] pc_target;
    wire [31 : 0] pc_relative_target;
    wire [31 : 0] imm_ext;
    wire [31 : 0] src_A;
    wire [31 : 0] src_B;
    wire [31 : 0] RD1;
    wire [31 : 0] RD2;
    wire [31 : 0] result;
    wire [31 : 0] zero_extend_byte;
    wire [31 : 0] read_data_out;
    wire [31 : 0] sign_extend_byte;
    wire [7 : 0] byte_out ;
    
    flopr #(32) pc_reg (
        .clk(clk),
        .reset(reset),
        .d(pc_next),
        .q(pc)
    );

    adder #(32) pc_add4 (
        .a(pc),
        .b(32'd4),
        .y(pc_plus4)
    );

    adder #(32) pc_add_branch (
        .a(pc),
        .b(imm_ext),
        .y(pc_relative_target)
    );

    mux2 #(32) pc_target_mux (
        .d0(pc_relative_target),
        .d1(alu_result),
        .s(pc_target_src),
        .y(pc_target)
    );

    mux2 #(32) pc_mux (
        .d0(pc_plus4),
        .d1(pc_target),
        .s(pc_src),
        .y(pc_next)
    );

    regfile rf (
        .clk(clk),
        .we3(reg_write),
        .a1(instr[19 : 15]),
        .a2(instr[24 : 20]),
        .a3(instr[11 : 7]),
        .wd3(result),
        .rd1(RD1),
        .rd2(RD2)
    );

    extend ext (
        .instr(instr[31 : 7]),
        .immsrc(imm_src),
        .immext(imm_ext)
    );

    mux2 #(32) src_A_mux (
        .d0(RD1),
        .d1(32'b0),
        .s(ALU_src_A),
        .y(src_A)
    );

    mux2 #(32) src_B_mux (
        .d0(RD2),
        .d1(imm_ext),
        .s(ALU_src_B),
        .y(src_B)
    );

    alu alu (
        .a(src_A),
        .b(src_B),
        .alu_control(alu_control),
        .result(alu_result),
        .flags(flags)
    );

    mux4 #(32) result_mux (
        .d0(alu_result),
        .d1(read_data_out),
        .d2(pc_plus4),
        .d3(pc_target),
        .s(result_src),
        .y(result)
    );

    mux4 #(8) byte_select (
        .d0(read_data[7 : 0]),
        .d1(read_data[15 : 8]),
        .d2(read_data[23 : 16]),
        .d3(read_data[31 : 24]),
        .s(alu_result[1 : 0]),
        .y(byte_out)
    );

    zeroextend ze (
        .a(byte_out),
        .zeroimmext(zero_extend_byte)
    );

    signeextend se (
        .a(byte_out),
        .signimmext(sign_extend_byte)
    );

    mux3 #(32) read_data_mux (
        .d0(read_data),
        .d1(zero_extend_byte),
        .d2(sign_extend_byte),
        .s(load_type),
        .y(read_data_out)
    );

    wdunit wd (
        .rd2(RD2),
        .read_data(read_data),
        .store_type(store_type),
        .byte_of_fset(alu_result[1 : 0]),
        .write_data(write_data)
    );
    
endmodule