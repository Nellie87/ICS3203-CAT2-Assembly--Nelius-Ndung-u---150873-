section .data
    prompt db "Enter up to 5 integers (space-separated): ", 0
    output_msg db "Reversed Array: ", 0
    space db " ", 0
    newline db 10, 0           ; Newline character for formatting

section .bss
    array resd 5               ; Reserve space for up to 5 integers
    input_buffer resb 64       ; Input buffer to hold user input

section .text
    global _start

_start:
    ; Prompt the user for input
    mov eax, 4                ; syscall: sys_write
    mov ebx, 1                ; stdout
    mov ecx, prompt           ; Message pointer
    mov edx, 39               ; Message length
    int 0x80

    ; Read input from the user
    mov eax, 3                ; syscall: sys_read
    mov ebx, 0                ; stdin
    mov ecx, input_buffer     ; Input buffer pointer
    mov edx, 64               ; Max buffer size
    int 0x80

    ; Convert input string to integers
    lea esi, input_buffer     ; Point to input buffer
    lea edi, array            ; Point to array in memory
    xor ecx, ecx              ; Counter for integers parsed

parse_input:
    mov al, byte [esi]
    cmp al, ' '               ; Skip spaces
    je skip_space
    cmp al, 10                ; Check for newline
    je end_parse
    cmp al, 0                 ; End of string
    je end_parse

    ; Convert ASCII to integer
    xor ebx, ebx              ; Reset current number
parse_digit:
    mov al, byte [esi]
    cmp al, '0'
    jl store_number           ; Stop if not a digit
    cmp al, '9'
    jg store_number
    sub al, '0'               ; Convert ASCII to numeric value
    imul ebx, ebx, 10         ; Multiply current number by 10
    add ebx, eax              ; Add the current digit
    inc esi                   ; Move to the next character
    jmp parse_digit

store_number:
    cmp ecx, 5                ; Check if we've reached max integers
    jge end_parse
    mov [edi], ebx            ; Store parsed number in array
    add edi, 4                ; Move to the next array element
    inc ecx                   ; Increment parsed integer count
    jmp parse_input

skip_space:
    inc esi
    jmp parse_input

end_parse:
    ; Reverse the array in place
    lea esi, array            ; Start pointer
    mov edx, ecx              ; Store count of parsed integers
    dec edx                   ; Index of last valid integer
    imul edx, edx, 4          ; Calculate offset in bytes
    lea edi, [array + edx]    ; End pointer

reverse_loop:
    cmp esi, edi              ; Check if pointers crossed
    jge end_reverse           ; End loop if done

    ; Swap elements
    mov eax, [esi]
    mov ebx, [edi]
    mov [esi], ebx
    mov [edi], eax

    add esi, 4                ; Move start pointer forward
    sub edi, 4                ; Move end pointer backward
    jmp reverse_loop

end_reverse:
    ; Output the reversed array
    mov eax, 4                ; syscall: sys_write
    mov ebx, 1                ; stdout
    mov ecx, output_msg       ; Message pointer
    mov edx, 17               ; Message length
    int 0x80

    lea esi, array            ; Point to reversed array
    mov ecx, edx              ; Number of parsed integers

output_loop:
    cmp ecx, 0                ; Check if we've printed all numbers
    je output_done
    mov eax, [esi]            ; Load integer from array
    call print_integer        ; Print the integer
    add esi, 4                ; Move to next array element
    dec ecx                   ; Decrement counter

    ; Print space after each number except the last
    cmp ecx, 0
    je output_done
    mov eax, 4                ; syscall: sys_write
    mov ebx, 1
    mov ecx, space            ; Space character
    mov edx, 1
    int 0x80
    jmp output_loop

output_done:
    ; Print a newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Exit program
    mov eax, 1                ; syscall: sys_exit
    xor ebx, ebx              ; Return code 0
    int 0x80

; Helper function to print an integer
print_integer:
    xor ecx, ecx              ; Clear digit count
    xor edx, edx              ; Clear remainder

print_loop:
    mov ebx, 10
    div ebx                   ; EAX = quotient, EDX = remainder
    add dl, '0'               ; Convert remainder to ASCII
    push dx                   ; Store digit on stack
    inc ecx                   ; Increment digit count
    test eax, eax             ; Check if quotient is zero
    jnz print_loop

output_digits:
    pop dx                    ; Get digit from stack
    mov al, dl
    mov ah, 0
    mov eax, 4                ; syscall: sys_write
    mov ebx, 1
    lea ecx, [esp]
    mov edx, 1
    int 0x80
    loop output_digits

    ret
