section .bss ; wd31f 
buf2 resb 12289 ; must be >= block size *3 +1 
section .text
global _start
_start:
    lea rsi, [rel buf2]
readStart:
    xor eax, eax
    xor edi, edi
    mov edx, 4096 ; block size
    syscall
    cmp rax, strict byte 0
    jle short readDone
    mov rdx, rax
.loop:
    mov ch, byte [rsi + rdx]
    mov cl, ch
    shr cl, 4
    cmp cl, 9
    seta bl
    neg bl
    and bl, 00000111b
    add cl, 0x30
    add cl, bl
    and ch, 0x0F
    cmp ch, 0x09
    seta bl
    neg bl
    and bl, 00000111b
    add ch, 0x30
    add ch, bl
    lea ebx, [rdx*2 + rdx]
    test ebx, ebx
    mov word [rsi + rbx], cx
    mov byte [rsi + rbx + 2], 0x20
    jz short .loopEnd
    dec rdx
    jmp short .loop
.loopEnd:
    lea edx, [rax*2 + rax]
    mov eax, 1
    mov edi, 1
    syscall 
    jmp short readStart
readDone:
    mov eax, 60
    syscall
