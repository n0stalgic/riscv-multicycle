`timescale 1ns / 1ps
module ALU (
    
    // inputs
    A, B, ALUControl,
    
    // outputs
    Q, Z
);

/*verilator public_flat_rd_on*/
input [3:0] ALUControl;
input [31:0] A;
input [31:0] B;
output reg [31:0] Q;
output reg Z;

reg [31:0] sll, srl, sra;
reg [31:0] CondInvB, sum;
reg neq, blt, ltu;
/*verilator public_off*/

assign Z  = (Q == 32'b0);

assign sll = A << B[4:0];
assign srl = A >> B[4:0];
assign sra = A >>> B[4:0];

// we only branch when Z = 1
assign neq = (sum == 32'b0); 
assign blt = ($signed(A) < $signed(B));
assign ltu = (A < B);

// if we're performing subtraction (ALUControl[0] == 1), invert B
assign CondInvB = ALUControl[0] ? ~B : B;
assign sum = A + CondInvB + ALUControl[0]; // ALUControl[0] will be 0 if adding, 1 if subbing

always @ (*) 
begin
    case (ALUControl)
        4'b0000: Q = sum;                   // ADD 
        4'b0001: Q = sum;                   // SUB
        4'b0010: Q = A & B;                 // AND
        4'b0011: Q = A | B;                 // OR
        4'b0100: Q = {{sum[31:1]}, 1'b0};   // JALR calculation - reuse ALU
        4'b0101: Q = sum[31];               // SLT: do A - B, if result is neg (sum[31] == 1)
        4'b0110: Q = A ^ B;                 // XOR
        4'b0111: Q = sll;                   // SLL
        4'b1000: Q = srl;                   // SRL
        4'b1001: Q = sra;                   // SRA
        4'b1010: Q = neq;                   // BNE
        4'b1011: Q = ~({32{blt}});            // BLT  
        4'b1100: Q = ltu;                   // SLT(I)U
        4'b1101: Q = blt;                   // BGE
        4'b1110: Q = ~({32{ltu}});            // BLTU
        4'b1111: Q = ltu;                   // BGEU
        default: Q = 32'bx;
    endcase

end
    
endmodule