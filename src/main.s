        .module main
;
;       imports
;
        .globl  uart_init
        .globl  uart_send
        .globl  uart_recv
        .globl  putchar
;
;       exports
;
        .globl  main
;
;       program code
;
        .area  _CODE
main:
        call    uart_init
        ld      hl,#msg_welcome
        call    send_msg

next_char:
        call    uart_recv
        ld      a,e
        cp      a,#0x03
        ret     z
        call    putchar
        jr      next_char

send_msg:
        ld      a,(hl)
        or      a,a
        ret     z
        ld      e,a
        call    uart_send
        inc     hl
        jr      send_msg

msg_welcome:
        .asciz  'Hello UART\r'

