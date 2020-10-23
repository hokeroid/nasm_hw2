
_testStack:
    mov rax, 10
    push rax
    pop rbx

;top of stack - element in row, below - potentional divisor
_printIfDivisable:
    mov rax, 10
    mov ecx, 5
    xor rdx, rdx
    div ecx
    cmp rdx, 0
    je _printRAX
    ret

_printRAX:
    ;mov rsi, rax
    ;mov rax, 0x2000004      ;номер системного вызова sys_write
    ;mov rdi, 1      ;файловый дескриптор stdout
    ;mov rdx, 64    ;длина строки
    ;syscall

    mov rdi, numMsg
    mov rsi, 10
    call _printf

    ret
