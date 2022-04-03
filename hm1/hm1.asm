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

    section .text
    global  _start
_start:
    mov dx, 0
    mov [lastSpace], dx
    mov dx, 0
    mov [cnt], dx

    mov ecx, lenText
    mov ebx, 0


cycle:
    push ecx

    lea esi, [text + ebx]
    lea edi, [space]
    inc ebx

    cmpsb

    jne notEqSym

    mov dx, [lastSpace]
    mov [lastSpace], bx
    mov ax, bx
    dec ax
    sub ax, dx ; eax have lenght of word
    mov dx, 4

    cmp ax, dx
    jle lessThanFour
    
    mov ax, [cnt]
    inc ax
    mov [cnt], ax

lessThanFour:


notEqSym: 
    pop ecx
    loop cycle
    

;write message
printAns:
    mov eax, 4
    mov ebx, 1
    mov ecx, mesGood 
    mov edx, lenMesGood
    int 80h

    mov esi, OutBuf
    mov ax, [cnt]
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