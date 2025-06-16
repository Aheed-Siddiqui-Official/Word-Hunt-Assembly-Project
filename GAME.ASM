Word Puzzle Game In Assembly Language;

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
    
move_down:
    cmp cursor_y, rows-1
    jne do_move_down
    jmp input_loop
do_move_down:
    inc cursor_y
    jmp game_loop
    
move_left:
    cmp cursor_x, 0
    jne do_move_left
    jmp input_loop
do_move_left:
    dec cursor_x
    jmp game_loop
    
move_right:
    cmp cursor_x, cols-1
    jne do_move_right
    jmp input_loop
do_move_right:
    inc cursor_x
    jmp game_loop
    
select_cell:

    cmp selected_x, -1
    je first_selection
    jmp check_word
    
first_selection:

    mov al, cursor_x
    mov selected_x, al
    mov al, cursor_y
    mov selected_y, al
    jmp game_loop
    
check_word:

    mov al, selected_y
    mov bl, cols
    mul bl
    mov bl, selected_x
    add bl, al
    mov al, board[bx]
    
    mov bl, cursor_y
    mov cl, cols
    mul cl
    mov bl, cursor_x
    add bl, al
    mov ah, board[bx]
    
    cmp al, 'D'
    jne reset_selection
    cmp ah, 'O'
    jne reset_selection 

    mov found, 1
    
reset_selection:
    mov selected_x, -1
    mov selected_y, -1
    jmp game_loop
    
exit_game_intermediate:
    jmp exit_game

exit_game:

    mov ax, 0003h
    int 10h
    

    mov ax, 4C00h
    int 21h
main endp

draw_board proc
    mov si, 0
    mov dh, 1  ; Start drawing board one row below to make space for greeting
    
row_loop:
    mov dl, 0
    mov bh, 0
    
col_loop:
    mov ah, 02h
    int 10h
    
    mov al, cursor_y
    cmp al, dh
    jne check_selected
    mov al, cursor_x
    cmp al, dl
    jne check_selected
    

    mov bl, cursor_attr
    jmp print_char
    
check_selected:
    cmp selected_x, -1
    je normal_cell
    mov al, selected_y
    cmp al, dh
    jne normal_cell
    mov al, selected_x
    cmp al, dl
    jne normal_cell

    mov bl, selected_attr
    jmp print_char
    
normal_cell:
    mov bl, normal_attr
    
print_char:
    mov ah, 09h
    mov al, board[si]
    mov bh, 0
    mov cx, 1
    int 10h
    
    inc si
    inc dl
    cmp dl, cols
    jb col_loop
    
    inc dh
    cmp dh, rows+1  ; Adjusted for the offset
    jb row_loop
    
    ret
draw_board endp

end main