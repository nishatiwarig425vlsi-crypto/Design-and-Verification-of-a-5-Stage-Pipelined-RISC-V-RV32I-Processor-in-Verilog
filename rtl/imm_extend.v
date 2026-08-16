`timescale 1ns/1ps

module imm_extend(

    input  [31:0] instruction,
    output reg [31:0] imm

);

wire [6:0] opcode;

assign opcode = instruction[6:0];

always @(*) begin

    case(opcode)

        // I-Type
        7'b0010011,
        7'b0000011,
        7'b1100111:
            imm = {{20{instruction[31]}}, instruction[31:20]};

        // S-Type
        7'b0100011:
            imm = {{20{instruction[31]}},
                   instruction[31:25],
                   instruction[11:7]};

        // B-Type
        7'b1100011:
            imm = {{19{instruction[31]}},
                   instruction[31],
                   instruction[7],
                   instruction[30:25],
                   instruction[11:8],
                   1'b0};

        // U-Type
        7'b0110111,
        7'b0010111:
            imm = {instruction[31:12],12'b0};

        // J-Type
        7'b1101111:
            imm = {{11{instruction[31]}},
                   instruction[31],
                   instruction[19:12],
                   instruction[20],
                   instruction[30:21],
                   1'b0};

        default:
            imm = 32'd0;

    endcase

end

endmodule
