.headersize 0x80025C00 - 0x1000
.org 0x80025C00

LUI t0, 0x800B
ADDIU t0, t0, 0x0A60
LUI t1, 0x0004
ADDIU t1, t1, 0xCF50
loop:
SD r0, 0x0000 (t0)
ADDI t1, t1, 0xFFF8
BNEZ t1, loop
ADDI t0, t0, 0x0008

//set up stack pointer
LUI sp, 0x800C
ADDIU sp, sp, 0x6BB0

ADDU a0, r0, r0
LUI a1, 0x0100 //0x01000000 rom addr
LUI a2, 0x8040 //0x80400000 ram addr
JAL osPiRawStartDma
LUI a3, 0x000C //dma 0.75 MB (update if more space needed, although savestate location would need adjustment)
J newBootCod
NOP

//per frame hook
.org 0x80025D74
J perFrameASM
NOP