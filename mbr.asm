BITS 16
ORG 0x7C00

_start:
    jmp 0x0000:entry

entry:
    nop
    nop
    nop
    jmp entry


    gap times 510 - (($ - $$)) db 0
    dw 0xAA55
