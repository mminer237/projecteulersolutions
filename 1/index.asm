; Name:     index.asm
; Assemble: nasm.exe -f win64 index.asm -o index.obj
; Link:     GoLink.exe /console index.obj kernel32.dll index.exe
; Run:      index.exe

section	.text
    extern GetStdHandle
    extern WriteFile
    extern ExitProcess
    
global Start
Start:
    mov rax, 0   ; Accumulator
    xor rbx, rbx
    mov rcx, 999 ; Counter
    xor rdx, rdx
.check_3:
    push rax ; Stash accumulator
    mov  rax, rcx ; Copy counter to check
    mov  rdx, 6148914691236517206 ; Divide by 3
    imul rdx
    mov  rsi, rcx
    sar  rsi, 63
    sub  rdx, rsi
    mov  rax, rdx
    add  rax, rdx
    add  rax, rdx
    mov  rdx, rcx
    sub  rdx, rax
    pop  rax      ; Pop accumulator
    test rdx, rdx ; If remainder is 0
    jz   .add_counter_then_3
    jmp  .check_5
.check_5:
    push rax ; Stash accumulator
    mov  rax, rcx ; Copy counter to check
    mov  rdx, 7378697629483820647 ; Divide by 5
    imul rdx
    sar  rdx, 1
    mov  rax, rcx
    sar  rax, 63
    sub  rdx, rax
    mov  rax, rdx
    sal  rax, 2
    add  rax, rdx
    mov  rdx, rcx
    sub  rdx, rax
    pop  rax          ; Pop accumulator
    test rdx, rdx     ; If remainder is 0
    jz   .add_counter_then_3
    dec  rcx           ; Decrement counter
    test rcx, rcx      ; If counter is 0
    je   .print_result ; Then print result
    jmp  .check_3      ; Else jump to check_3
.add_counter_then_3:
    add  rax, rcx
    dec  rcx           ; Decrement counter
    test rcx, rcx      ; If counter is 0
    je   .print_result ; Then print result
    jmp  .check_3      ; Else jump to check_3

.print_result:
    mov  rsi, buffer   ; Point rsi to message buffer
    add  rsi, 10
    mov  byte [rsi], 0
    xor  R8, R8
.next_digit:
    push rax
    mov  edi, 10       ; Set divisor to 10
    xor  rdx, rdx
    div  rdi
    add  dl, '0'       ; Convert remainder to ASCII
    dec  rsi           ; Go to next character
    mov  [rsi], dl     ; Move remainder to buffer
    inc  R8            ; Increment counter/numberOfBytesToWrite parameter
    test rax, rax      ; If last digit
    jnz  .next_digit   ; Else do next digit
.actually_write:
    mov  rcx, -11           ; STD_OUTPUT_HANDLE
    call GetStdHandle       ; Get screen buffer handle in rax
    add  rsp, 8
    sub  rsp,32+8
    mov  qword [rsp+32], 0  ; Set overlapped parameter to null, after shadow space
    mov  R9, numberOfBytesWritten  ; Set numberOfBytesWritten parameter to numberOfBytesWritten buffer
    mov  rdx, rsi           ; Set buffer parameter to message buffer
    mov  rcx, rax           ; Set handle parameter to screen buffer
    call WriteFile

    xor rax, rax
    call ExitProcess

section .bss
    buffer resb 10
    numberOfBytesWritten resb 10
