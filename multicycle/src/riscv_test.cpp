#include <cstdlib>
#include <stdlib.h>
#include "verilated.h"
#include "obj_dir/Vriscv_sys.h"
#include "testbench.h"

#define PC_MAX 0x44

int main(int argc, char** argv)
{
    
    VerilatedContext* contextp = new VerilatedContext;
    contextp->commandArgs(argc, argv);

    Verilated::commandArgs(argc, argv);
    TESTBENCH<Vriscv_sys>* tb = new TESTBENCH<Vriscv_sys>(contextp);

    tb->opentrace("wave.vcd");
    printf("Starting simulation\n"); 
    while(!tb->done())
    {
        tb->tick();
    }

    tb->closetrace();
    printf("Test complete\n");
    exit(EXIT_SUCCESS);

}

