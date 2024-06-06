newBootCod:
//wait on our dma to finish before continuing
dmaBusyLoop:
LUI t0, 0xA460
LW t1, 0x0010 (t0)
ANDI t1, t1, 0x0001
BNEZ t1, dmaBusyLoop
NOP

LUI t2, 0x8008
ADDIU t2, t2, 0x62E0
JR t2
NOP

perFrameASM:
JAL MainLoop
NOP
JAL 0x80033EC8
NOP
J 0x80025D7C
NOP