section .bss
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
    cmp eax, strict byte 0
    jle short readDone
    mov edx, eax
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
    lea ebx, [edx * 3]
    test ebx, ebx
    mov word [rsi + rbx], cx
    mov byte [rsi + 2 + rbx], 0x20
    jz short .loopEnd
    dec rdx
    jmp short .loop
.loopEnd:
    lea edx, [eax*3]
    mov eax, 1
    mov edi, 1
    syscall 
    jmp short readStart
readDone:
    mov eax, 60
    syscall
