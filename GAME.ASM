.model small
.stack 100h

.data
    greetMsg db "Welcome to the Word Hunt Game:$"
    board db 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
    rows equ 5
    cols equ 5
    cursor_x db 0
    cursor_y db 0
    selected_x db -1
    selected_y db -1
    word_found_msg db 'This DOG word is found!$'
    word_to_find db 'DOG$'
    found db 0

    normal_attr db 07h
    cursor_attr db 70h
    selected_attr db 0E0h

.code
main proc
    mov ax, @data
    mov ds, ax

    mov ax, 0003h
    int 10h
    
    ; Display greeting message
    mov ah, 02h
    mov dh, 0
    mov dl, 0
    int 10h
    
    mov ah, 09h
    lea dx, greetMsg
    int 21h

    mov ah, 01h
    mov cx, 2607h
    int 10h
    
game_loop:
    call draw_board

    cmp found, 1
    jne input_loop

    mov ah, 02h
    mov dh, rows + 2
    mov dl, 0
    int 10h
    
    mov ah, 09h
    lea dx, word_found_msg
    int 21h
    jmp input_loop
    
input_loop:

    mov ah, 00h
    int 16h
    

    cmp al, 1Bh
    jne continue_game
    jmp exit_game_intermediate
continue_game:
    cmp ah, 48h
    je move_up
    cmp ah, 50h
    je move_down
    cmp ah, 4Bh
    je move_left
    cmp ah, 4Dh
    je move_right
    cmp al, 20h
    je select_cell
    jmp input_loop
    
move_up:
    cmp cursor_y, 0
    jne do_move_up
    jmp input_loop
do_move_up:
    dec cursor_y
    jmp game_loop
    
