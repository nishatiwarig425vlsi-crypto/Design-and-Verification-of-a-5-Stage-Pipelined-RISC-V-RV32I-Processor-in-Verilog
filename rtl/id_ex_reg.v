`timescale 1ns/1ps

module id_ex_reg(

    input clk,
    input rst,
    input flush,

    // Data Inputs
    input [31:0] pc_in,
    input [31:0] pc_plus4_in,
    input [31:0] rs1_data_in,
    input [31:0] rs2_data_in,
    input [31:0] imm_in,

    input [4:0] rs1_in,
    input [4:0] rs2_in,
    input [4:0] rd_in,

    input [2:0] funct3_in,
    input [6:0] funct7_in,

    // Control Inputs
    input reg_write_in,
    input mem_read_in,
    input mem_write_in,
    input mem_to_reg_in,
    input alu_src_in,
    input branch_in,
    input [3:0] alu_control_in,

    // Data Outputs
    output reg [31:0] pc_out,
    output reg [31:0] pc_plus4_out,
    output reg [31:0] rs1_data_out,
    output reg [31:0] rs2_data_out,
    output reg [31:0] imm_out,

    output reg [4:0] rs1_out,
    output reg [4:0] rs2_out,
    output reg [4:0] rd_out,

    output reg [2:0] funct3_out,
    output reg [6:0] funct7_out,

    // Control Outputs
    output reg reg_write_out,
    output reg mem_read_out,
    output reg mem_write_out,
    output reg mem_to_reg_out,
    output reg alu_src_out,
    output reg branch_out,
    output reg [3:0] alu_control_out

);

always @(posedge clk or posedge rst) begin

    if (rst || flush) begin

        pc_out <= 0;
        pc_plus4_out <= 0;
        rs1_data_out <= 0;
        rs2_data_out <= 0;
        imm_out <= 0;

        rs1_out <= 0;
        rs2_out <= 0;
        rd_out <= 0;

        funct3_out <= 0;
        funct7_out <= 0;

        reg_write_out <= 0;
        mem_read_out <= 0;
        mem_write_out <= 0;
        mem_to_reg_out <= 0;
        alu_src_out <= 0;
        branch_out <= 0;
        alu_control_out <= 0;

    end

    else begin

        pc_out <= pc_in;
        pc_plus4_out <= pc_plus4_in;

        rs1_data_out <= rs1_data_in;
        rs2_data_out <= rs2_data_in;

        imm_out <= imm_in;

        rs1_out <= rs1_in;
        rs2_out <= rs2_in;
        rd_out <= rd_in;

        funct3_out <= funct3_in;
        funct7_out <= funct7_in;

        reg_write_out <= reg_write_in;
        mem_read_out <= mem_read_in;
        mem_write_out <= mem_write_in;
        mem_to_reg_out <= mem_to_reg_in;
        alu_src_out <= alu_src_in;
        branch_out <= branch_in;
        alu_control_out <= alu_control_in;

    end

end

endmodule
