    section .data ; сегмент инициализированных переменных
getA db "Enter a: ", 10
lenGetA equ $-getA
getJ db "Enter j: ", 10
lenGetJ equ $-getJ
getK db "Enter k: ", 10
lenGetK equ $-getK
zeroDiv db "Devision by zero", 10
lenZeroDiv equ $-zeroDiv
res db "result: ", 10
lenRes equ $-res
errorGetElem db "error while getting input", 10
lenErrorGetElem equ $-errorGetElem

    section .bss ; сегмент неинициализированных переменных

InBuf resb 10 ; буфер для вводимой строки
lenIn equ $-InBuf
OutBuf resb 10
a resw 1
j resw 1
k resw 1
f resw 1

    section .text
    global  _start
_start:
    ;write
    mov eax, 4
    mov ebx, 1
    mov ecx, getA 
    mov edx, lenGetA 
    int 80h

    ; read a
    mov eax, 3
    mov ebx, 0
    mov ecx, InBuf
    mov edx, lenIn
    int 80h
    
    ; convert a to int 
    mov esi, InBuf
    call StrToInt
    cmp ebx, 0
    jne errorMessage
    mov [a], ax 

    ;write message to get j
    mov eax, 4
    mov ebx, 1
    mov ecx, getJ
    mov edx, lenGetJ
    int 80h

    ; read j
    mov eax, 3
    mov ebx, 0
    mov ecx, InBuf
    mov edx, lenIn
    int 80h

    ; convert j to int 
    mov esi, InBuf
    call StrToInt
    cmp ebx, 0
    jne errorMessage
    mov [j], ax

    ;write message to get k
    mov eax, 4
    mov ebx, 1
    mov ecx, getK
    mov edx, lenGetK
    int 80h

    ; read k
    mov eax, 3
    mov ebx, 0
    mov ecx, InBuf
    mov edx, lenIn
    int 80h

    ; convert a to int 
    mov esi, InBuf
    call StrToInt
    cmp ebx, 0
    jne errorMessage
    mov [k], ax


    ;CALCULATIONS
    mov ax, [j] 
    cmp ax, 3
    jng lessThan3
    mov bx, [k]
    cmp bx, 0
    je zeroDivision
    
    ; calculate case j > 3
    mov ax, [j]
    imul ax ; ax = j * j
    mov bx, [k]
    cwd
    idiv bx ; ax = j * j / k
    ;mov [f], ax
    ;jmp printAns ; DEBUG
    mov cx, ax
    mov ax, [a]
    mov bx, [j]
    imul bx
    ;mov [f], ax
    ;jmp printAns ;Debug
    sub ax, cx
    mov [f], ax
    jmp printAns 


lessThan3:
    mov ax, 8
    mov [f], ax 
    jmp printAns


printAns:
    ;convert j to string
    mov esi, OutBuf
    mov ax, [f]
    cwde
    call IntToStr

    ;print output 
    mov ecx, esi
    mov edx, eax
    mov eax, 4
    mov ebx, 1
    int 80h
    jmp exit


errorMessage:
    mov eax, 4
    mov ebx, 1
    mov ecx, errorGetElem
    mov edx, lenErrorGetElem
    int 80h
    jmp exit

zeroDivision:
    mov eax, 4
    mov ebx, 1
    mov ecx, zeroDiv
    mov edx, lenZeroDiv
    int 80h
    jmp exit


exit:
    ; exit
    mov eax, 1
    xor ebx, ebx
    int 80h
%include "../int_string.asm"