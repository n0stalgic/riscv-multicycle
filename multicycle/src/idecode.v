`timescale 1ns / 1ps
module idecode(
    op,

    ImmSrc

);

input  [6:0] op;
output reg [1:0] ImmSrc;

`include "opcode.vh"

// instruction decoder
always @ (*)
begin

  case(op)
    `LW_OP:           ImmSrc = 2'b00;
    `SW_OP:           ImmSrc = 2'b01;
    `I_TYPE_ALU_OP:   ImmSrc = 2'b00;
    `R_TYPE_OP:       ImmSrc = 2'b00;
    `BRANCH_OP:       ImmSrc = 2'b10;
    `JAL_OP:          ImmSrc = 2'b11;
    `JALR_OP:         ImmSrc = 2'b00;
  endcase
end

endmodule

