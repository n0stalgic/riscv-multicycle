`timescale 1ns / 1ps
module aludecoder(input  logic [1:0] ALUOp,
                  input  logic [2:0] funct3,
                  input  logic op_5, 
                  input  logic funct7_5,
                  output logic [3:0] ALUControl);

    always @ (*)
    begin
      casez ({ALUOp, funct3, op_5, funct7_5})
        7'b00?????:
          ALUControl = 4'b0000;  // add for PC increment
        7'b0100011:
          ALUControl = 4'b0001;  // subtract for beq
        7'b0100110:
          ALUControl = 4'b1010;  // bne predicate
        7'b0110010:
          ALUControl = 4'b1011;  // blt predicate
        7'b0110110:
          ALUControl = 4'b1101;  // bge predicate
        7'b0111010:
          ALUControl = 4'b1110;  // bltu prediicate
        7'b0111110:
          ALUControl = 4'b1111;  // bgeu predicate
        7'b1000000,
        7'b1000001:
          ALUControl = 4'b0000;  // add 
        7'b1000010:              
          ALUControl = 4'b0100;  // jalr, we add rs1 + imm and clip LSB to 0 
        7'b1000011:
          ALUControl = 4'b0001;  // subtract
        7'b10010??:
          ALUControl = 4'b0101;  // slt(i)
        7'b10011??:
          ALUControl = 4'b1100;  // slt(i)u
        7'b10110??:
          ALUControl = 4'b0011;  // or(i) 
        7'b10111??:
          ALUControl = 4'b0010;  // and(i)
        7'b10100??:
          ALUControl = 4'b0110;  // xor(i)
        7'b10001??:              
          ALUControl = 4'b0111;  // sll(i)
        7'b10101?0:
          ALUControl = 4'b1000;  // srl(i)
        7'b1010111:
          ALUControl = 4'b1001;  // sra(i)

      endcase
    end
    
endmodule