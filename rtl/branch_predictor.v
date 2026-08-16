`timescale 1ns/1ps

module branch_predictor(

    input  [31:0] pc,
    input         branch_taken_actual,

    output        predict_taken

);

assign predict_taken = 1'b0;

endmodule
