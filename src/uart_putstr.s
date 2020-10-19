         .module uart_putstr
;
;       imports
;

;
;       exports
;
        .globl  uart_putstr
;
;       program code
;
        .area  _CODE
; send zero terminated string via uart
; IN : HL address
; OUT: none
; modified registers: A,HL
uart_putstr:
        push    de
next_char:
        ld      a,(hl)
        or      a,a
        jr      nz,send
        pop     de
        ret
send:
        ld      e,a
        call    uart_send
        inc     hl
        jr      next_char

