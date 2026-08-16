`timescale 1ns/1ps

module hazard_unit(

    input id_ex_mem_read,

    input [4:0] id_ex_rd,

    input [4:0] if_id_rs1,
    input [4:0] if_id_rs2,

    output reg stall,
    output reg flush

);

always @(*) begin

    stall = 0;
    flush = 0;

    if(id_ex_mem_read &&
      ((id_ex_rd == if_id_rs1) ||
       (id_ex_rd == if_id_rs2)) &&
      (id_ex_rd != 0))
    begin
        stall = 1;
        flush = 1;
    end

end

endmodule
