//Automatically generated by makefile, do not edit
.n64 // Let armips know we're coding for the N64 architecture
.open "rom/shadowgate64.z64", "rom/shadowgate64.mod.z64", 0 // Open the ROM file
.include "asm/symbols.asm" // Include symbols.asm to tell armips' linker where to find the game's function(s)
.include "asm/bootPatch.asm"
.headersize 0x7F400000
.org 0x80400000
.importobj "obj/main.o"
.include "asm/hooks.s"
.close //close file
