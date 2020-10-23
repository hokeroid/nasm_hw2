;nasm -f macho64 first.asm && ld -macosx_version_min 10.7.0 -lSystem -o first first.o && ./first


section .data

    msg db "I did it! Yeah...",10,0 ; 10 is \n
    msgLen equ $ - msg

    m1 db "They are equal",10,0
    m1Len equ $ - m1

    m2 db "They are not equal",10,0
    m2Len equ $ - m2

    whatName db "What's your name?",10,0
    whatNameLen equ $ - whatName

    hello db "Hello, "
    helloLen equ $ - hello

section .bss
    name resb 16


section .text
    global start

sys_exit:
    mov rax, 0x2000001      ;системный вызов sys_exit
    mov rdi, 0              ;код ошибки

    syscall
    ret

start:
    call _hello_world
    call sys_exit

;input: RAX as pointer to string
;output: print string at RAX
_print:
    push rax
    mov rbx, 0

_printLoop:
    inc rax
    inc rbx
    mov cl, [rax]
    cmp cl, 0
    jne _printLoop

    mov rax, 0x2000004      ;номер системного вызова sys_write
    mov rdi, 1      ;файловый дескриптор stdout
    pop rsi         ;
    mov rdx, rbx

    syscall
    ret



;________________________
_name_program:
    call _print_whats_name
    call _get_name
    call _print_hello
    call _print_name
    ret

_print_whats_name:
    mov rax, 0x2000004      ;номер системного вызова sys_write
    mov rdi, 1      ;файловый дескриптор stdout
    mov rsi, whatName    ;наша строка
    mov rdx, whatNameLen    ;длина строки
    syscall

    ret

_get_name:
    mov rax, 0x2000003      ;номер системного вызова sys_read
    mov rdi, 0      ;файловый дескриптор stdin
    mov rsi, name    ;наша строка
    mov rdx, 16    ;длина строки
    syscall
    ret

_print_hello:
    mov rax, 0x2000004      ;номер системного вызова sys_write
    mov rdi, 1      ;файловый дескриптор stdout
    mov rsi, hello    ;наша строка
    mov rdx, helloLen    ;длина строки
    syscall
    ret

_print_name:
    mov rax, 0x2000004      ;номер системного вызова sys_write
    mov rdi, 1      ;файловый дескриптор stdout
    mov rsi, name    ;наша строка
    mov rdx, 16    ;длина строки
    syscall
    ret









;_______________________________________________________
_hello_world:

    ; код для вывода строки на экран

    mov rax, 0x2000004      ;номер системного вызова sys_write
    mov rdi, 1      ;файловый дескриптор stdout
    mov rsi, msg    ;наша строка
    mov rdx, msgLen    ;длина строки

    syscall
    mov r12, 2
    cmp r12, 0
    je isEqual
    jne isNotEqual

    ret

isEqual:
    mov rax, 0x2000004      ;номер системного вызова sys_write
    mov rdi, 1      ;файловый дескриптор stdout
    mov rsi, m1    ;наша строка
    mov rdx, m1Len    ;длина строки

    syscall
    ret

isNotEqual:

    mov rax, 0x2000004      ;номер системного вызова sys_write
    mov rdi, 1      ;файловый дескриптор stdout
    mov rsi, m2    ;наша строка
    mov rdx, m2Len    ;длина строки

    syscall
    ret