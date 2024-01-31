///////////////////////////////////////////////////////////////
// riscvmulti
//
// Multicycle RISC-V microprocessor
///////////////////////////////////////////////////////////////
typedef enum logic[6:0] {r_type_op=7'b0110011, i_type_alu_op=7'b0010011, lw_op=7'b0000011, sw_op=7'b0100011, beq_op=7'b1100011, jal_op=7'b1101111} opcodetype;

module riscvmulti(input  logic        clk, reset,
                  output logic        MemWrite,
                  output logic [31:0] Adr, WriteData,
                  input  logic [31:0] ReadData);

  // Your code goes here
  // Instantiate controller (from lab 5) and datapath (new for this lab)

 /*verilator public_flat_rd_on*/
  wire [31:0] PC;
  wire [31:0] instr;
  wire Zero;
  wire [2:0] ImmSrc;
  wire [1:0] ALUSrcA;
  wire [1:0] ALUSrcB;
  wire [1:0] ResultSrc;
  wire AdrSrc;
  wire [3:0] ALUControl;
  wire LSE;
  wire IRWrite;
  wire PCWrite;
  wire RegWrite;
  wire [2:0]  LST;
  wire [31:0] Data;
  wire [31:0] OldPC;
  wire [31:0] A, Rd1;
  wire [31:0] Rd2;
  wire [31:0] SrcA;
  wire [31:0] SrcB;
  wire [31:0] ALUResult;
  wire [31:0] ALUOut;
  wire [31:0] Result;
  wire [31:0] ImmExt;

  /*verilator public_off*/
  
  controller cntrl(
    .clk(clk),
    .reset(reset),
    .op(instr[6:0]),
    .funct3(instr[14:12]),
    .funct7b5(instr[30]),
    .Zero(Zero),
    .ImmSrc(ImmSrc),
    .ALUSrcA(ALUSrcA),
    .ALUSrcB(ALUSrcB),
    .ResultSrc(ResultSrc),
    .AdrSrc(AdrSrc),
    .ALUControl(ALUControl),
    .LST(LST),
    .LSE(LSE),
    .IRWrite(IRWrite),
    .PCWrite(PCWrite),
    .RegWrite(RegWrite),
    .MemWrite(MemWrite)
  );

  DFF_CE pc_reg (

    .CLK(clk),
    .RST(reset),
    .CE(PCWrite),
    .D(Result),
    .Q(PC)
  );

  mux_2_1 pc_mux (
    .sel(AdrSrc),
    .in1(PC),
    .in2(Result),
    .dout(Adr)
  );

  DUAL_DFF instr_reg (

    .CLK(clk),
    .RST(reset),
    .CE(IRWrite),
    .D1(PC),
    .D2(ReadData),
    .Q1(OldPC),
    .Q2(instr)

  );

  DFF data_reg (
    .CLK(clk),
    .RST(reset),
    .D(ReadData),
    .Q(Data)
  );

  regfile regfile (
    .CLK(clk),
    .WE3(RegWrite),
    .A1(instr[19:15]),
    .A2(instr[24:20]),
    .A3(instr[11:7]),
    .LST(LST),
    .LSE(LSE),
    .WD3(Result),
    .RD1(Rd1),
    .RD2(Rd2)
  );

  DUAL_DFF regfile_reg (

    .CLK(clk),
    .RST(reset),
    .CE(1'b1),
    .D1(Rd1),
    .D2(Rd2),
    .Q1(A),
    .Q2(WriteData)
  );

  mux_3_1 alu_a_mux (
    .sel(ALUSrcA),
    .in1(PC),
    .in2(OldPC),
    .in3(A),
    .dout(SrcA)
  );

  mux_3_1 alu_b_mux (
    .sel(ALUSrcB),
    .in1(WriteData),
    .in2(ImmExt),
    .in3(32'b100),
    .dout(SrcB)
  );

  ALU ALU (
    .A(SrcA),
    .B(SrcB),
    .ALUControl(ALUControl),
    .Z(Zero),
    .Q(ALUResult)
  );

  DFF alu_reg (
    .CLK(clk),
    .RST(reset),
    .D(ALUResult),
    .Q(ALUOut)
  );

  mux_3_1 alu_out_mux (
    .sel(ResultSrc),
    .in1(ALUOut),
    .in2(Data),
    .in3(ALUResult),
    .dout(Result)
  );

  extender extender (
    .Instr(instr[31:7]),
    .ImmSrc(ImmSrc),
    .ImmExt(ImmExt)
  );

endmodule


