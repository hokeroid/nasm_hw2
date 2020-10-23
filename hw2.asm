;nasm -f macho64 hw2.asm && ld -macosx_version_min 10.7.0 -lSystem -o hw2 hw2.o && ./hw2
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
    ansArrSz resq 1

section .text

_printN:
    xor rax, rax

    mov rdi, numMsg
    mov rsi, [ansArrSz]
    call _printf
    ret

_printEmptyLine:
    xor rax, rax
    mov rdi, emptyStr
    call _printf
    ret
    
start:
    mov rax, 0
    mov [ansArrSz], rax

    mov rsi, n
    call _inputNumber
    

    mov rsi, x
    call _inputNumber
    

    mov r15, 0
    call _inputArray
    
    call _printEmptyLine
    
    mov r15, 0
    call _printArray ;must print whole arr
        
    mov r15, 0
    call _makeAns
    
    call _printEmptyLine
    
    mov r15, 0
    call _printAnsArray
    
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
    mov rdx, 16
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

_makeAns:
    mov rax, r15
    mov rbx, 16
    mul rbx
    mov rbx, arr
    add rax, rbx

    ;достаем значение по адресу
    mov rax, [rax]
    call _addToAnsIfDivisable

    add r15, 1

    cmp r15, [n]
        jl _makeAns
    ret

;prints RAX if it is divisable by x
_addToAnsIfDivisable:
    mov r14, rax
    xor rdx, rdx
    mov ecx, [x]
    div ecx
    cmp rdx, 0
        jne _ret
    call _addToAns
_ret:
    ret

;r14 - number to add
_addToAns:
    mov rax, [ansArrSz]
    mov rdx, 16
    mul rdx
    mov rdx, ansArr
    add rax, rdx
    
    mov [rax], r14

    mov rdx, [ansArrSz]
    inc rdx
    mov [ansArrSz], rdx

    ret


_printArray:
    mov rax, r15
    mov rdx, 16
    mul rdx
    mov rdx, arr
    add rax, rdx

    ;достаем значение по адресу
    mov rsi, [rax]
    
    call _printNumber
    

    add r15, 1

    cmp r15, [n]
        jl _printArray
    ret

_printAnsArray:
    mov rax, 0
    cmp [ansArrSz], rax
        jle _ret

    mov rax, r15
    mov rdx, 16
    mul rdx
    mov rdx, ansArr
    add rax, rdx

    ;достаем значение по адресу
    mov rsi, [rax]

    call _printNumber

    add r15, 1

    cmp r15, [ansArrSz]
        jl _printAnsArray
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