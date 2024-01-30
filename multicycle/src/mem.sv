///////////////////////////////////////////////////////////////
// mem
//
// Single-ported RAM with read and write ports
// Initialized with machine language program
///////////////////////////////////////////////////////////////
`timescale 1ns / 1ps
module mem # (  
    MEM_SIZE = 512

) (
    input logic clk, we,
    input logic [31:0] a,
    input logic [31:0] wd,
    output logic [31:0] rd
);

reg [7:0] RAM [MEM_SIZE*4-1:0];

// temporary storage before endian conversion and memory transformation
reg [31:0] temp [MEM_SIZE-1:0];
integer i=0, j=0;
integer asm_ID;


initial begin

    asm_ID = $fopen("riscvcpu_sim.bin", "rb");
    $fread(temp, asm_ID);

    /* endian conversion to little endian and transform to 4-byte alignment */
    /* verilator lint_off SELRANGE */
    repeat(MEM_SIZE) begin
      RAM[i]     = temp[j][7:0];
      RAM[i + 1] = temp[j][15:8];
      RAM[i + 2] = temp[j][23:16];
      RAM[i + 3] = temp[j][31:24];
      i += 4;
      j += 1;
    end
  end
/* verilator lint_on SELRANGE */
always @ (*) begin
  rd[7:0]   = RAM[a + 3];
  rd[15:8]  = RAM[a + 2];
  rd[23:16] = RAM[a + 1];
  rd[31:24] = RAM[a];
  
end

always @(posedge clk) begin
    if (we) begin
        RAM[a]     <= wd[7:0];
        RAM[a + 1] <= wd[15:8];
        RAM[a + 2] <= wd[23:16];
        RAM[a + 3] <= wd[31:24];
    end

end

endmodule

