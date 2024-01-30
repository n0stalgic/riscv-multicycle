`timescale 1ns / 1ps
module controller(input  logic       clk,
                  input  logic       reset,  
                  input  logic [6:0] op,
                  input  logic [2:0] funct3,
                  input  logic       funct7b5,
                  input  logic       Zero,

                  output logic [1:0] ImmSrc,
                  output logic [1:0] ALUSrcA, ALUSrcB,
                  output logic [1:0] ResultSrc, 
                  output logic       AdrSrc,
                  output logic [3:0] ALUControl,
                  output logic [2:0] LST,
                  output logic       IRWrite, PCWrite, 
                  output logic       RegWrite, MemWrite,
                  output logic       LSE);

/*verilator public_flat_rd_on*/
localparam FETCH      = 0;
localparam DECODE     = 1;
localparam MEM_ADR    = 2;
localparam MEM_READ   = 3;
localparam MEM_WB     = 4;
localparam MEM_WRITE  = 5;
localparam EXECUTE_R  = 6;
localparam ALU_WB     = 7;
localparam EXECUTE_I  = 8;
localparam JAL        = 9;
localparam JALR       = 10;
localparam BRANCH     = 11;

`include "opcode.vh"

reg [3:0] state  ;
reg [3:0] next_state  ;

reg [1:0] ALUOp;
reg Branch, PCUpdate;
/*verilator public_off*/
assign PCWrite = (Zero & Branch) | PCUpdate;

// instantiate the ALU Decoder
aludecoder aludecoder(
      .ALUOp(ALUOp),
      .funct3(funct3),
      .op_5(op[5]),
      .funct7_5(funct7b5),
      .ALUControl(ALUControl)
);

// instantiate instruction decoder
idecode i_decode(
  .op(op),
  .ImmSrc(ImmSrc)
);

// state transitions
always @ (posedge clk or posedge reset)
  if (reset)
    state <= FETCH;
  else
    state <= next_state;


// main controller
always @ (*) 
begin
  next_state = state;
  case(state)
    FETCH:
      next_state = DECODE;
    DECODE: begin
      if (op == `LW_OP || op == `SW_OP)
        next_state = MEM_ADR;
      else if (op == `R_TYPE_OP)
        next_state = EXECUTE_R;
      else if (op == `I_TYPE_ALU_OP || op == `JALR_OP)
        next_state = EXECUTE_I;
      else if (op == `JAL_OP)
        next_state = JAL;
      else if (op == `BRANCH_OP)
        next_state = BRANCH;
    end
    MEM_ADR: begin
      if (op == `LW_OP)
        next_state = MEM_READ;
      else if (op == `SW_OP)
        next_state = MEM_WRITE;
    end
    MEM_READ:
      next_state = MEM_WB;
    MEM_WB,
    ALU_WB,
    BRANCH,
    MEM_WRITE:
      next_state = FETCH;

    EXECUTE_I:
      if (op == `JALR_OP)
        next_state = JALR;
      else
        next_state = ALU_WB;
    EXECUTE_R,
    JAL:
      next_state = ALU_WB;
    JALR:
      next_state = ALU_WB;

  endcase
end



// output vectors
always @ (*)
begin
  AdrSrc  = 1'b0;
  IRWrite = 1'b0;
  ALUSrcA = 2'b00;
  ALUSrcB = 2'b00;
  ResultSrc = 2'b00;
  PCUpdate = 1'b0;
  ALUOp = 2'b00;
  RegWrite = 1'b0;
  MemWrite = 1'b0;
  Branch = 1'b0;
  LSE = 1'b0;
  case (state)
    FETCH: begin
      AdrSrc  = 1'b0;
      IRWrite = 1'b1;
      ALUOp = 2'b00;
      ALUSrcA = 2'b00;
      ALUSrcB = 2'b10;
      ResultSrc = 2'b10;
      PCUpdate = 1'b1;     
    end
    DECODE: begin
      ALUSrcA = 2'b01;
      ALUSrcB = 2'b01;
      ALUOp = 2'b00;      
    end
    MEM_ADR: begin
      ALUSrcA = 2'b10;
      ALUSrcB = 2'b01;
      ALUOp = 2'b00;
      LSE = 1'b1;
      LST = funct3;    
    end
    MEM_READ: begin
      ResultSrc = 2'b00;
      AdrSrc = 1'b1;  
    end
    MEM_WB: begin
      ResultSrc = 2'b01;
      RegWrite = 1'b1;
    end
    MEM_WRITE: begin
      ResultSrc = 2'b00;
      AdrSrc = 1'b1;
      MemWrite = 1'b1;
    end
    EXECUTE_R: begin
      ALUSrcA = 2'b10;
      ALUSrcB = 2'b00;
      ALUOp = 2'b10;
    end
    ALU_WB: begin
      ResultSrc = 2'b00;
      RegWrite = 1'b1;
    end
    EXECUTE_I: begin
      ALUSrcA = 2'b10;
      ALUSrcB = 2'b01;
      ALUOp = 2'b10;    
    end
    JAL: begin
      ALUSrcA = 2'b01;
      ALUSrcB = 2'b10;
      ALUOp = 2'b00;
      ResultSrc = 2'b00;
      PCUpdate = 1'b1;  
    end
    JALR: begin
      ALUSrcA = 2'b10;
      ALUSrcB = 2'b01;
      ALUOp   = 2'b10;
      ResultSrc = 2'b00;
      PCUpdate = 1'b1;
    end
    BRANCH: begin
      ALUSrcA = 2'b10;
      ALUSrcB = 2'b00;
      ALUOp = 2'b01;
      ResultSrc = 2'b00;
      Branch = 1'b1;             
    end
  endcase
end

endmodule


