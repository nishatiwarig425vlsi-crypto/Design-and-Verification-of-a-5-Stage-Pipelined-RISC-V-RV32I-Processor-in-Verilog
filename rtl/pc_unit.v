`timescale 1ns/1ps

module pc_unit(

    input clk,
    input rst,

    input branch_taken,
    input [31:0] target_address,

    output reg [31:0] pc_out,
    output [31:0] pc_plus4_out

);

always @(posedge clk or posedge rst) begin

    if(rst)
        pc_out <= 32'd0;

    else if(branch_taken)
        pc_out <= target_address;

    else
        pc_out <= pc_out + 32'd4;

end

assign pc_plus4_out = pc_out + 32'd4;

endmodule
