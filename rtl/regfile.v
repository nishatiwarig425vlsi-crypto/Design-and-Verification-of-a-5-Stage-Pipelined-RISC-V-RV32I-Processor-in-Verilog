`timescale 1ns/1ps

module regfile(

    input clk,

    // Read ports
    input  [4:0] rs1,
    input  [4:0] rs2,

    // Write port
    input        reg_write,
    input  [4:0] rd,
    input  [31:0] write_data,

    output [31:0] read_data1,
    output [31:0] read_data2

);

    reg [31:0] registers [0:31];

    integer i;

    initial begin
        for(i = 0; i < 32; i = i + 1)
            registers[i] = 32'd0;
    end

    // Read ports
    assign read_data1 = (rs1 == 5'd0) ? 32'd0 : registers[rs1];
    assign read_data2 = (rs2 == 5'd0) ? 32'd0 : registers[rs2];

    // Write port
    always @(posedge clk) begin
        if(reg_write && (rd != 5'd0))
            registers[rd] <= write_data;
    end

endmodule
