        .module main
;
;       imports
;
        .globl  uart_init
        .globl  uart_send
        .globl  uart_recv
        .globl  uart_putstr
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
        call    uart_putstr

next_char:
        call    uart_recv
        ld      a,e
        cp      a,#0x03
        ret     z
        call    putchar
        jr      next_char

msg_welcome:
        .asciz  'UHello UART\r'

