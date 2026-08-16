`timescale 1ns/1ps

module riscv_pipeline_cpu(

    input clk,
    input rst

);

//////////////////////////////////////////////////////
// IF Stage Wires
//////////////////////////////////////////////////////

wire [31:0] pc;
wire [31:0] pc_plus4;
wire [31:0] instruction;

//////////////////////////////////////////////////////
// IF/ID Pipeline Register
//////////////////////////////////////////////////////

wire [31:0] ifid_pc;
wire [31:0] ifid_pc4;
wire [31:0] ifid_instruction;

//////////////////////////////////////////////////////
// Decoder Outputs
//////////////////////////////////////////////////////

wire [6:0] opcode;
wire [4:0] rs1;
wire [4:0] rs2;
wire [4:0] rd;
wire [2:0] funct3;
wire [6:0] funct7;

//////////////////////////////////////////////////////
// Register File
//////////////////////////////////////////////////////

wire [31:0] rs1_data;
wire [31:0] rs2_data;

//////////////////////////////////////////////////////
// Immediate Generator
//////////////////////////////////////////////////////

wire [31:0] imm;

//////////////////////////////////////////////////////
// Control Signals
//////////////////////////////////////////////////////

wire reg_write;
wire mem_read;
wire mem_write;
wire mem_to_reg;
wire alu_src;
wire branch;
wire [1:0] alu_op;

wire [3:0] alu_control;

//////////////////////////////////////////////////////
// ID/EX
//////////////////////////////////////////////////////

wire [31:0] idex_pc;
wire [31:0] idex_pc4;
wire [31:0] idex_rs1_data;
wire [31:0] idex_rs2_data;
wire [31:0] idex_imm;

wire [4:0] idex_rs1;
wire [4:0] idex_rs2;
wire [4:0] idex_rd;

wire [2:0] idex_funct3;
wire [6:0] idex_funct7;

wire idex_reg_write;
wire idex_mem_read;
wire idex_mem_write;
wire idex_mem_to_reg;
wire idex_alu_src;
wire idex_branch;

wire [3:0] idex_alu_control;

//////////////////////////////////////////////////////
// EX Stage
//////////////////////////////////////////////////////

wire [31:0] alu_result;
wire alu_zero;

//////////////////////////////////////////////////////
// EX/MEM
//////////////////////////////////////////////////////

wire [31:0] exmem_alu_result;
wire [31:0] exmem_write_data;

wire [4:0] exmem_rd;

wire exmem_zero;

wire exmem_reg_write;
wire exmem_mem_read;
wire exmem_mem_write;
wire exmem_mem_to_reg;
wire exmem_branch;

//////////////////////////////////////////////////////
// MEM Stage
//////////////////////////////////////////////////////

wire [31:0] memory_data;

//////////////////////////////////////////////////////
// MEM/WB
//////////////////////////////////////////////////////

wire [31:0] wb_memory_data;
wire [31:0] wb_alu_result;

wire [4:0] wb_rd;

wire wb_reg_write;
wire wb_mem_to_reg;

//////////////////////////////////////////////////////
// Forwarding Unit
//////////////////////////////////////////////////////

wire [1:0] forwardA;
wire [1:0] forwardB;

wire [31:0] forwarded_rs1;
wire [31:0] forwarded_rs2;

wire [31:0] alu_operand_b;

assign alu_operand_b =
    idex_alu_src ? idex_imm : forwarded_rs2;
//////////////////////////////////////////////////////
// Write Back
//////////////////////////////////////////////////////

wire [31:0] write_back_data;

assign write_back_data =
        wb_mem_to_reg ?
        wb_memory_data :
        wb_alu_result;
//////////////////////////////////////////////////////
// Program Counter
//////////////////////////////////////////////////////
wire stall;
wire flush;
pc_unit pc_inst(

    .clk(clk),
    .rst(rst),

    .branch_taken(1'b0),
    .target_address(32'd0),

    .pc_out(pc),
    .pc_plus4_out(pc_plus4)

);
//////////////////////////////////////////////////////
// Instruction Memory
//////////////////////////////////////////////////////

instruction_memory imem(

    .address(pc),
    .instruction(instruction)



);


//////////////////////////////////////////////////////
// IF/ID Pipeline Register
//////////////////////////////////////////////////////

if_id_reg ifid(

    .clk(clk),
    .rst(rst),

 .stall(stall),
.flush(flush),
    .pc_in(pc),
    .pc_plus4_in(pc_plus4),
    .instruction_in(instruction),

    .pc_out(ifid_pc),
    .pc_plus4_out(ifid_pc4),
    .instruction_out(ifid_instruction)

);

//////////////////////////////////////////////////////
// Decoder
//////////////////////////////////////////////////////

decoder decoder_inst(

    .instruction(ifid_instruction),

    .opcode(opcode),
    .rd(rd),
    .funct3(funct3),
    .rs1(rs1),
    .rs2(rs2),
    .funct7(funct7)

);
//////////////////////////////////////////////////////
// Control Unit
//////////////////////////////////////////////////////

control_unit control(

    .opcode(opcode),

    .reg_write(reg_write),
    .mem_read(mem_read),
    .mem_write(mem_write),
    .mem_to_reg(mem_to_reg),
    .alu_src(alu_src),
    .branch(branch),
    .alu_op(alu_op)


);


//////////////////////////////////////////////////////
// ALU Control
//////////////////////////////////////////////////////

alu_control alu_ctrl(

    .alu_op(alu_op),
    .funct3(funct3),
    .funct7(funct7),

    .alu_control(alu_control)

);
//////////////////////////////////////////////////////
// Register File
//////////////////////////////////////////////////////

regfile rf(

    .clk(clk),

    .rs1(rs1),
    .rs2(rs2),

    .reg_write(wb_reg_write),
    .rd(wb_rd),
    .write_data(write_back_data),

    .read_data1(rs1_data),
    .read_data2(rs2_data)

);
//////////////////////////////////////////////////////
// Immediate Generator
//////////////////////////////////////////////////////

imm_extend immgen(

    .instruction(ifid_instruction),

    .imm(imm)

);
//////////////////////////////////////////////////////
// ID/EX Register
//////////////////////////////////////////////////////

id_ex_reg idex(

    .clk(clk),
    .rst(rst),
    .flush(flush),

    .pc_in(ifid_pc),
    .pc_plus4_in(ifid_pc4),

    .rs1_data_in(rs1_data),
    .rs2_data_in(rs2_data),

    .imm_in(imm),

    .rs1_in(rs1),
    .rs2_in(rs2),
    .rd_in(rd),

    .funct3_in(funct3),
    .funct7_in(funct7),

    .reg_write_in(reg_write),
    .mem_read_in(mem_read),
    .mem_write_in(mem_write),
    .mem_to_reg_in(mem_to_reg),
    .alu_src_in(alu_src),
    .branch_in(branch),
    .alu_control_in(alu_control),

    .pc_out(idex_pc),
    .pc_plus4_out(idex_pc4),

    .rs1_data_out(idex_rs1_data),
    .rs2_data_out(idex_rs2_data),

    .imm_out(idex_imm),

    .rs1_out(idex_rs1),
    .rs2_out(idex_rs2),
    .rd_out(idex_rd),

    .funct3_out(idex_funct3),
    .funct7_out(idex_funct7),

    .reg_write_out(idex_reg_write),
    .mem_read_out(idex_mem_read),
    .mem_write_out(idex_mem_write),
    .mem_to_reg_out(idex_mem_to_reg),
    .alu_src_out(idex_alu_src),
    .branch_out(idex_branch),
    .alu_control_out(idex_alu_control)

);


//////////////////////////////////////////////////////
// ALU
//////////////////////////////////////////////////////

alu alu_inst(

   .a(forwarded_rs1),
    .b(alu_operand_b),

    .alu_control(idex_alu_control),

    .result(alu_result),
    .zero(alu_zero)

);
//////////////////////////////////////////////////////
// EX/MEM Register
//////////////////////////////////////////////////////

ex_mem_reg exmem(

    .clk(clk),
    .rst(rst),

    .alu_result_in(alu_result),
    .write_data_in(idex_rs2_data),

    .rd_in(idex_rd),

    .zero_in(alu_zero),

    .reg_write_in(idex_reg_write),
    .mem_read_in(idex_mem_read),
    .mem_write_in(idex_mem_write),
    .mem_to_reg_in(idex_mem_to_reg),
    .branch_in(idex_branch),

    .alu_result_out(exmem_alu_result),
    .write_data_out(exmem_write_data),

    .rd_out(exmem_rd),

    .zero_out(exmem_zero),

    .reg_write_out(exmem_reg_write),
    .mem_read_out(exmem_mem_read),
    .mem_write_out(exmem_mem_write),
    .mem_to_reg_out(exmem_mem_to_reg),
    .branch_out(exmem_branch)

);
//////////////////////////////////////////////////////
// Data Memory
//////////////////////////////////////////////////////

data_memory dmem(

    .clk(clk),

    .mem_read(exmem_mem_read),
    .mem_write(exmem_mem_write),

    .address(exmem_alu_result),
    .write_data(exmem_write_data),

    .read_data(memory_data)

);
//////////////////////////////////////////////////////
// MEM/WB Register
//////////////////////////////////////////////////////

mem_wb_reg memwb(

    .clk(clk),
    .rst(rst),

    .mem_data_in(memory_data),
    .alu_result_in(exmem_alu_result),

    .rd_in(exmem_rd),

    .reg_write_in(exmem_reg_write),
    .mem_to_reg_in(exmem_mem_to_reg),

    .mem_data_out(wb_memory_data),
    .alu_result_out(wb_alu_result),

    .rd_out(wb_rd),

    .reg_write_out(wb_reg_write),
    .mem_to_reg_out(wb_mem_to_reg)

);
//////////////////////////////////////////////////////
// Forwarding Unit
//////////////////////////////////////////////////////

forwarding_unit forwarding(

    .ex_mem_reg_write(exmem_reg_write),
    .mem_wb_reg_write(wb_reg_write),

    .ex_mem_rd(exmem_rd),
    .mem_wb_rd(wb_rd),

    .id_ex_rs1(idex_rs1),
    .id_ex_rs2(idex_rs2),

    .forwardA(forwardA),
    .forwardB(forwardB)

);
assign forwarded_rs1 =
    (forwardA == 2'b00) ? idex_rs1_data :
    (forwardA == 2'b10) ? exmem_alu_result :
                          write_back_data;

assign forwarded_rs2 =
    (forwardB == 2'b00) ? idex_rs2_data :
    (forwardB == 2'b10) ? exmem_alu_result :
                          write_back_data;

hazard_unit hazard(

    .id_ex_mem_read(idex_mem_read),

    .id_ex_rd(idex_rd),

    .if_id_rs1(rs1),
    .if_id_rs2(rs2),

    .stall(stall),
    .flush(flush)

);
endmodule
