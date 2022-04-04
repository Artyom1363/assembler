    section .data ; сегмент инициализированных переменных
text db "this is some beautiful amazing text which length is ten", 10
lenText equ $-text

mesGood db "Quantity of works with size more than 4 symbols: "
lenMesGood equ $-mesGood

space db " "


    section .bss ; сегмент неинициализированных переменных
OutBuf resb 10
lastSpace resw 1
cnt resw 1
InBuf resb 50 ; буфер для вводимой строки
lenIn equ $-InBuf

    section .text
    global  _start
_start:
    ;read
    mov eax, 3
    mov ebx, 0
    mov ecx, InBuf
    mov edx, lenIn
    int 80h

    ;
    lea edi,[InBuf]
    mov ecx,lenIn
    mov al,0Ah
    repne scasb
    mov ax,50
    sub ax,cx
    mov cx,ax

;write message
printAns:

    mov esi, OutBuf
    mov ax, cx
    cwde
    call IntToStr

    ;print output 
    mov ecx, esi
    mov edx, eax
    mov eax, 4
    mov ebx, 1
    int 80h

    jmp exit


exit:
    ; exit
    mov eax, 1
    xor ebx, ebx
    int 80h
%include "../int_string.asm"



