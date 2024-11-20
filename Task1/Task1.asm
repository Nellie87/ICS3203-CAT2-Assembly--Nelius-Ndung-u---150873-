section .data
    prompt db "Enter a number: ", 0
    positive_msg db "POSITIVE", 0
    negative_msg db "NEGATIVE", 0
    zero_msg db "ZERO", 0

section .bss
    num resb 10  ; Allocate space for up to 10 characters (to include multi-digit numbers and '\n')

section .text
    global _start
_start:
    ; Prompt for user input
    mov eax, 4            ; syscall number for sys_write
    mov ebx, 1            ; file descriptor 1 is stdout
    mov ecx, prompt
    mov edx, 17           ; message length
    int 0x80

    ; Read user input
    mov eax, 3            ; syscall number for sys_read
    mov ebx, 0            ; file descriptor 0 is stdin
    mov ecx, num
    mov edx, 10           ; read up to 10 bytes (including '\n')
    int 0x80

    ; Convert ASCII input to integer
    mov esi, num          ; Point to the input buffer
    xor eax, eax          ; Clear EAX (accumulator for the integer)
    xor ebx, ebx          ; Clear EBX (sign indicator)

convert_loop:
    movzx edx, byte [esi] ; Load a single byte from the input
    cmp dl, 0x2D          ; Check if the character is a '-'
    je handle_negative    ; If so, set the sign indicator
    cmp dl, 0x30          ; Check if the character is '0'
    jl end_conversion     ; Stop if it's not a valid digit
    cmp dl, 0x39          ; Check if the character is '9'
    jg end_conversion     ; Stop if it's not a valid digit

    ; Convert ASCII digit to integer
    sub dl, 0x30          ; Convert ASCII to numeric value
    imul eax, eax, 10     ; Multiply the current result by 10
    add eax, edx          ; Add the new digit
    inc esi               ; Move to the next character
    jmp convert_loop

handle_negative:
    mov bl, 1             ; Set sign indicator
    inc esi               ; Skip the '-' character
    jmp convert_loop

end_conversion:
    cmp bl, 0             ; Check if the number is negative
    je classify_number    ; If not, skip negation
    neg eax               ; Negate the number

classify_number:
    cmp eax, 0            ; Compare the number with 0
    je zero_label         ; If zero, jump to zero_label
    jl negative_label     ; If negative, jump to negative_label
    jmp positive_label    ; Otherwise, it's positive

zero_label:
    mov ecx, zero_msg
    jmp display_message

negative_label:
    mov ecx, negative_msg
    jmp display_message

positive_label:
    mov ecx, positive_msg

display_message:
    mov eax, 4            ; syscall number for sys_write
    mov ebx, 1            ; stdout
    mov edx, 8            ; message length
    int 0x80

    ; Exit
    mov eax, 1            ; syscall number for sys_exit
    xor ebx, ebx          ; Exit code 0
    int 0x80
