`timescale 1ns / 1ps
module extender (
    
    // inputs
    Instr, ImmSrc,

    //outputs
    ImmExt
);

input [31:7] Instr;
input [1:0]  ImmSrc;
output reg [31:0] ImmExt;

always @ (*)
    case(ImmSrc) 
               // I-type (IMMEDIATES)
      2'b00:   ImmExt = {{20{Instr[31]}}, Instr[31:20]};  
               // S-type (stores)
      2'b01:   ImmExt = {{20{Instr[31]}}, Instr[31:25], Instr[11:7]}; 
               // B-type (branches)
      2'b10:   ImmExt = {{20{Instr[31]}}, Instr[7], Instr[30:25], Instr[11:8], 1'b0}; 
               // J-type (jal)
      2'b11:   ImmExt = {{12{Instr[31]}}, Instr[19:12], Instr[20], Instr[30:21], 1'b0}; 
      default: ImmExt = 32'bx; // undefined
    endcase             
endmodule