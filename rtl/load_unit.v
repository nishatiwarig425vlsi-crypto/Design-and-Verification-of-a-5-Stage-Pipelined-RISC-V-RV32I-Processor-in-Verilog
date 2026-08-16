`timescale 1ns/1ps

module load_unit(

    input [31:0] mem_data,

    output [31:0] load_data

);

assign load_data = mem_data;

endmodule
