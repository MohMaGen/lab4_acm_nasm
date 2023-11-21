global colors_ansi


section .rodata
    colors_ansi:
        db "\033[0m",0 ; clear
        db "\033[30m",0 ; black
        db "\033[31m",0 ; red
        db "\033[32m",0 ; green
        db "\033[33m",0 ; yellow
        db "\033[34m",0 ; blue
        db "\033[35m",0 ; magenta
        db "\033[36m",0 ; cyan
        db "\033[37m",0 ; while
