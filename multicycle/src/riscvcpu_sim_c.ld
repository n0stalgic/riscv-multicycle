
RAM_SIZE   = 0x1000; /* 4KB */
STACK_SIZE = 0x200;

MEMORY 
{
    ram (rwx) : ORIGIN = 0x0, LENGTH = RAM_SIZE
}

SECTIONS
{
    .text :
    {
        . = ALIGN(4);
        *(.text*)
    }  > ram

    .data : 
    { 
        . = ALIGN(4);
        *(.data)
    
    } > ram

    .bss(NOLOAD) : 
    { 
        *(.bss*) 

    } > ram

    .stack (NOLOAD):
    {
        . = ALIGN(16);
        __stacktop = ORIGIN(ram) + LENGTH(ram);
        . = . + STACK_SIZE;
        . = ALIGN(16);
    } > ram

}
