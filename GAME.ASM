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

