    section .data ; сегмент инициализированных переменных 
ExitMsg db "Zero division",10
a dw 0
b dw 1
x dw 1
y dw 2
term1 dw 0
term2 dw 0
term3 dw 0
lenExit equ $-ExitMsg

    section .bss ; сегмент неинициализированных переменных

InBuf resb 10 ; буфер для вводимой строки

OutBuf resb 10
n resw 1

lenIn equ $-InBuf
    section .text
    global  _start
_start:
    mov ax, [x]
    imul ax
    mov bx, [a]
    imul bx
    mov [term1], ax

    
    mov ax, [y]
    mov bx, [b]
    mov cx, [a]
    imul bx
    ;mov dx, 0
    cwd ;обнуляем dx
    cmp cx, 0 ; проверка деления на ноль
    je ZeroDiv
    idiv cx
    mov [term2], ax

    
    mov ax, [x]
    mov bx, [y]
    add bx, [a]
    ;mov dx, 0
    cwd
    idiv bx
    mov [term3], ax 

    mov ax, [term1]
    sub ax, [term2]
    add ax, [term3]
    mov [n], ax 
    %ifdef com
    %endif
    ;cmp byte[ebx], 5

    ;call function IntToStr
    mov esi, OutBuf
    mov ax, [n]
    cwde
    call IntToStr
    
    mov ecx, esi ; ecx have addres of output string
    mov edx, eax ; edx have len of output string

    mov eax, 4
    mov ebx, 1
    int 80h
    jmp Exit

ZeroDiv:
    mov     eax, 4
    mov     ebx, 1
    mov     ecx, ExitMsg
    mov     edx, lenExit
    int     80h

Exit
    ; exit
    mov eax, 1
    xor ebx, ebx
    int 80h

%include "../int_string.asm"
