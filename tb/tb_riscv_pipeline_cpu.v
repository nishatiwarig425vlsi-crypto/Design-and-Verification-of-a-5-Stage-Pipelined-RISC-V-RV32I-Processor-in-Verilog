`timescale 1ns/1ps

module tb_riscv_pipeline_cpu;

reg clk;
reg rst;

riscv_pipeline_cpu dut(
    .clk(clk),
    .rst(rst)
);

// Clock generation
always #5 clk = ~clk;

initial begin
    clk = 0;
    rst = 1;

    #20;
    rst = 0;

    #300;

    $finish;
end

initial begin
    $dumpfile("waves/pipeline.vcd");
    $dumpvars(0, tb_riscv_pipeline_cpu);
end

endmodule
