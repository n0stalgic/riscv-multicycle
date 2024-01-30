

SRCS = riscvcpu_sim.s


VERILOG_SRCS = alu.v \
			   dff.v \
			   extend.v \
			   idecode.v \
			   mux.v \
			   regfile.v \

SYSTEM_VERILOG_SRCS = riscv_sys.sv \
					  aludec.sv \
				      controller.sv \
					  mem.sv \
					  riscvmulti.sv 

VERILOG_HEADERS = opcode.vh
VERILOG_TOP     = riscv_sys

VERILATOR_CPP_SRC = riscv_test.cpp

VCD_FILE          = wave.vcd
GTKWAVE_FORMAT    = wave.gtkw

ARCH = rv32i
BASE = riscvcpu_sim
OBJ_TARGET = $(BASE).o
TARGET = $(BASE).bin
MAX_TRACE_ARRAY = 4096

CC = riscv32-unknown-linux-gnu-gcc
AS = riscv32-unknown-linux-gnu-as
OC = riscv32-unknown-linux-gnu-objcopy 
OD = riscv32-unknown-linux-gnu-objdump
VV = verilator

VVFLAGS = -Wno-WIDTHEXPAND -Wno-MULTITOP -Wno-CASEINCOMPLETE --trace-max-array $(MAX_TRACE_ARRAY) --trace --exe --build 
CCFLAGS = -march=$(ARCH)
OBJFLAGS = -j .text

OCFLAGS = -O binary $(OBJFLAGS)
DISASSEMBLER_FLAGS = no-aliases,numeric
ODFLAGS = -d --disassembler-options=$(DISASSEMBLER_FLAGS) $(OBJFLAGS)

OBJS = $(SRCS:.s=.o)

%.o : %.s
	$(CC) $(CCFLAGS) -c $< -o $@

.PHONY: compile
compile: $(OBJS)

.PHONY: binary
binary: $(OBJS) $(OBJ_TARGET)

$(OBJ_TARGET) : $(SRCS)
	$(CC) $(CCFLAGS) -c $< -o $@
	$(OC) $(OCFLAGS) $@ $(TARGET)

.PHONY: disassemble
disassemble: $(OBJS)
	$(OD) $(ODFLAGS) $<

.PHONY: build
build: $(OBJS) $(OBJ_TARGET) disassemble

.PHONY: verilate
verilate: build
	$(VV) $(VVFLAGS) --cc $(VERILATOR_CPP_SRC) --top-module $(VERILOG_TOP) $(VERILOG_SRCS) $(SYSTEM_VERILOG_SRCS) $(VERILOG_HEADERS)

.PHONY: sim
sim:
	gtkwave $(VCD_FILE) $(GTKWAVE_FORMAT) &

.PHONY: clean
clean:
	rm -rf *.o
	rm -rf *.bin
	rm -rf *.out
	rm -rf *.vcd
	rm -rf obj_dir/
