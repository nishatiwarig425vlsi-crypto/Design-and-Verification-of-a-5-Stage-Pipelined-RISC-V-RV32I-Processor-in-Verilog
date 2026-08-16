`timescale 1ns/1ps

module store_unit(

    input [31:0] write_data,

    output [31:0] mem_write_data

);

assign mem_write_data = write_data;

endmodule
