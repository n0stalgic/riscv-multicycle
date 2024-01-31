`timescale 1ns / 1ps
module idecode(
    op,

    ImmSrc

);

input  [6:0] op;
output reg [2:0] ImmSrc;

`include "opcode.vh"

// instruction decoder
always @ (*)
begin

  case(op)
    `LW_OP:           ImmSrc = 3'b000;
    `SW_OP:           ImmSrc = 3'b001;
    `I_TYPE_ALU_OP:   ImmSrc = 3'b000;
    `R_TYPE_OP:       ImmSrc = 3'b000;
    `BRANCH_OP:       ImmSrc = 3'b010;
    `JAL_OP:          ImmSrc = 3'b011;
    `JALR_OP:         ImmSrc = 3'b000;
    `LUI_OP,
    `AUIPC_OP:        ImmSrc = 3'b100;
  endcase
end

endmodule

