;nasm -f macho64 hw2Old.asm && ld -macosx_version_min 10.7.0 -lSystem -o hw2Old hw2Old.o && ./hw2Old
extern _printf, _scanf
global start
default rel

section .data
    numMsg db '%lld',10,0
    inputFormat db '%lld',0
    emptyStr db 10,0

section .bss
    n resq 1
    x resq 1
    arr resq 100
    ansArr resq 100

section .text

_test: 
    mov rax, 21
    mov ecx, 7
    call _printIfDivisable

    mov rax, 22
    mov ecx, 2
    call _printIfDivisable

    mov rax, 15
    mov ecx, 5
    call _printIfDivisable

_printN:
    xor rax, rax

    mov rdi, numMsg
    mov rsi, [arr]
    call _printf
    ret

_printEmptyLine:
    xor rax, rax
    mov rdi, emptyStr
    call _printf
    ret
    
start:
    mov rsi, n
    call _inputNumber

    mov rsi, x
    call _inputNumber

    mov r15, 0
    call _inputArray

    call _printEmptyLine

    mov r15, 0
    call _printArray
    
    call _sys_exit

;rsi - address
_inputNumber:
    xor rax, rax
    mov rdi, inputFormat
    call _scanf
    ret

;R15 - pointer on start
_inputArray:
    ;по итогу rax станет адресом элемента массива
    mov rax, r15
    mov rdx, 8
    mul rdx
    mov rdx, arr
    add rax, rdx

    ;кладем адрес в rsi чтобы в него вводить
    mov rsi, rax
    call _inputNumber

    add r15, 1

    cmp r15, [n]
        jl _inputArray
    ret

_printArray:
    mov rax, r15
    mov rdx, 8
    mul rdx
    mov rdx, arr
    add rax, rdx

    ;достаем значение по адресу
    mov rax, [rax]

    mov ecx, 5
    call _printIfDivisable

    add r15, 1

    cmp r15, [n]
        jl _printArray
    ret

;prints RAX if it is divisable by x
_printIfDivisable:
    mov rsi, rax
    xor rdx, rdx
    mov ecx, [x]
    div ecx
    cmp rdx, 0
        jne _ret
    call _printNumber
_ret:
    ret

;prints rsi
_printNumber:
    xor rax, rax
    mov rdi, numMsg
    call _printf

    ret


_sys_exit:
    mov rax, 0x2000001      ;системный вызов sys_exit
    mov rdi, 0              ;код ошибки

    syscall
    ret