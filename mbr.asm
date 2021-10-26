;  ------------------------------------------------------------------------
;    File Name: mbr.asm
;       Author: Zhao Yanbai
;               2021-10-25 20:09:17 Monday CST
;  Description: none
;  ------------------------------------------------------------------------

BITS 16
ORG 0x7C00

VideoSegment EQU 0xB800         ; 显存段地址

CursorIndexRegister EQU 0x3D4   ; 光标索引寄存器
CursorIndexH EQU 0x0E           ; 光标位置高8位索引值
CursorIndexL EQU 0x0F           ; 光标位置高8位索引值
CursorDataRegister  EQU 0x3D5   ; 光标位置数据寄存器

VWidth  EQU 80
VHeight EQU 25

_start:
    jmp 0x0000:entry

entry:
    ; 初始化段寄存器
    mov ax, cs
    mov ds, ax
    mov es, ax

    ; 初始化栈
    mov ss, ax
    mov sp, _start


   call clear_screen

    
    mov bx, msg
    call show_msg
    mov bx, loadmsg
    call show_msg


   jmp $

   ; bx msg
show_msg:
    push ax
    push bx

    mov ah, 0x1F
 .show_next:
    mov al, [bx]
    cmp al, 0
    jz .show_end
    call putc
    inc bx
    jmp .show_next

 .show_end:
    pop bx
    pop ax
    ret


    ; 在光标处显示一个字符，并将光标向后移动一位
    ; AH: 显示模式
    ; AL: 显示字符
putc:
    push ax
    push bx
    push cx
    push dx
    push es

    mov cx, ax

    ; 将es设为显存段地址
    mov ax, VideoSegment
    mov es, ax

    ; 先获得光标的位置放到bx中
    ; 向索引寄存器写入要读取高8位的索引
    mov al, CursorIndexH
    mov dx, CursorIndexRegister
    out dx, al

    ; 从数据寄存器中读出高8位的位置放到ah中
    mov dx, CursorDataRegister
    in  al, dx
    mov bh, al

    ; 向索引寄存器写入要读取低8位的索引
    mov al, CursorIndexL
    mov dx, CursorIndexRegister
    out dx, al

    ; 从数据寄存器中读出低8位的位置放到al中
    mov dx, CursorDataRegister
    in  al, dx
    mov bl, al

    ; 判断是不是\n
    cmp cl, 0x0A
    jnz .normal_char
    mov ax, bx
    mov bl, VWidth
    add ax, VWidth - 1
    div bl
    mul bl
    mov bx, ax
    jmp .set_cursor

 .normal_char:
    ; 在光标处写入字符
    shl bx, 1               ; 因为一个字符占两个字节
    mov word [es:bx], cx

    ; 接下来向后移动一下光标
    shr bx, 1
    add bx, 1

 .set_cursor:
    call set_cursor

    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    ret

clear_screen:
    push es
    push bx
    push ax

    mov ax, VideoSegment
    mov es, ax
    mov ax, VWidth
    mov bl, VHeight
    mul bl
    shl ax, 1
    xor bx, bx

    call set_cursor

 .aa
    cmp bx, ax
    jz .cleaned
    mov word [es:bx], 0x1020
    add bx, 2
    jmp .aa
 .cleaned

   pop ax
   pop bx
   pop es
   ret

   ; BH - 光标位置高8位
   ; BL - 光标位置低8位
set_cursor:
   push dx
   push bx
   push ax

    mov al, CursorIndexH
    mov dx, CursorIndexRegister
    out dx, al
    mov al, bh              ; 得到光标的高8位
    mov dx, CursorDataRegister
    out dx, al

    mov al, CursorIndexL
    mov dx, CursorIndexRegister
    out dx, al
    mov al, bl              ; 得到光标的低8位
    mov dx, CursorDataRegister
    out dx, al

   pop ax
   pop bx
   pop dx
   ret

    msg db "this is a test x86 mbr....", 0x0A, 0x00
    loadmsg db "load loader.bin", 0x0A, 0x00

    gap times 510 - (($ - $$)) db 0x00
    dw 0xAA55
