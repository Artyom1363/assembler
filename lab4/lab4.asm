    section .data ; сегмент инициализированных переменных
getMatr db "Enter matrix 6x4: ", 10
lenGetMatr equ $-getMatr

outMes db "Number of string with maxim sum of positive numbers: "
lenOutMes equ $-outMes

outMesSum  db "Sum of positive numbers: "
lenOutMesSum equ $-outMesSum

errorGetElem db "error while getting input", 10
lenErrorGetElem equ $-errorGetElem

    section .bss ; сегмент неинициализированных переменных

InBuf resb 10 ; буфер для вводимой строки
lenIn equ $-InBuf
OutBuf resb 10
matr resw 24
bestQuantity resw 1
numberOfBest resw 1

    section .text
    global  _start
_start:
    ;write message
    mov eax, 4
    mov ebx, 1
    mov ecx, getMatr 
    mov edx, lenGetMatr
    int 80h

    mov ecx, 24
    mov ebx, 0

cycle_read:
    push ecx
    push ebx
    mov eax, 3
    mov ebx, 0
    mov ecx, InBuf
    mov edx, lenIn
    int 80h

    ; convert number to int 
    mov esi, InBuf
    call StrToInt
    cmp ebx, 0
    jne errorMessage
    pop ebx
    mov [matr + ebx], ax
    pop ecx
    add ebx, 2
    loop cycle_read



;logic
; ax - sum, bx - number
    mov ecx, 6
    mov ebx, 0

loop_i:
    push ecx
    mov eax, 0
    mov ecx, 4

loop_j:
    mov dx, 0   ; only to compare
    cmp [matr + ebx], dx
    jl skipAdding
    add eax, [matr + ebx]
skipAdding:
    add ebx, 2
    loop loop_j

    pop ecx
    cmp eax, [bestQuantity]
    jle skipUpdateMax
    mov dx, 5
    sub dx, cx
    ; dx have index of optimal
    mov [bestQuantity], eax
    mov [numberOfBest], dx

skipUpdateMax:
    loop loop_i

    jmp printNumberOfBestString


printMatrix:
    mov ecx, 24
    mov ebx, 0
cycle_write:
    push ecx
    ;convert elem of matr to string
    mov esi, OutBuf
    mov ax, [matr + ebx]
    add ebx, 2
    push ebx
    cwde
    call IntToStr

    ;print output 
    mov ecx, esi
    mov edx, eax
    mov eax, 4
    mov ebx, 1
    int 80h
    
    pop ebx
    pop ecx
    loop cycle_write
    

printNumberOfBestString:

    ;write message
    mov eax, 4
    mov ebx, 1
    mov ecx, outMes 
    mov edx, lenOutMes
    int 80h

    ;convert elem of matr to string
    mov esi, OutBuf
    mov ax, [numberOfBest]
    cwde
    call IntToStr

    ;print output 
    mov ecx, esi
    mov edx, eax
    mov eax, 4
    mov ebx, 1
    int 80h
    
    jmp printSumOfBestString

printSumOfBestString:

    ;write message
    mov eax, 4
    mov ebx, 1
    mov ecx, outMesSum
    mov edx, lenOutMesSum
    int 80h

    ;convert elem of matr to string
    mov esi, OutBuf
    mov ax, [bestQuantity]
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

exit:
    ; exit
    mov eax, 1
    xor ebx, ebx
    int 80h

%include "../int_string.asm"