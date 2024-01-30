`timescale 1ns / 1ps
///////////////////////////////////////////////////////////////
// riscvcpu
//
// Instantiates multicycle RISC-V processor and memory
///////////////////////////////////////////////////////////////

module riscv_sys(input  logic        clk, reset, 
           output logic [31:0] WriteData, DataAdr, 
           output logic        MemWrite);

  logic [31:0] ReadData;
  
  // instantiate processor and memories
  riscvmulti rvmulti(clk, reset, MemWrite, DataAdr, 
                     WriteData, ReadData);
  mem mem(clk, MemWrite, DataAdr, WriteData, ReadData);

endmodule
