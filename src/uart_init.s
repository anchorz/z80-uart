        .module uart_init
        .include "uart_cfg.s"
;
;       imports
;
PIO_CMD_BITWISE_IO      .equ 0xcf
;
;       exports
;
        .globl  uart_init
;
;       program code
;
        .area  _CODE
; initialize uart
; IN : none
; OUT: C UART port address
; modified registers: A,C
uart_init:
        ld      a,#PIO_CMD_BITWISE_IO
        ld      c,#V24_CONTROL
        out     (c),a
        ; set only TX as output, others are input
        ; it is safer that way
        ; we dont know who else uses that pins
        ld      a,#~(1<<V24_TX) ; TX output, others input
        out     (c),a
        ld      c,#V24_DATA
        xor     a,a
        set     V24_TX,a
        out     (c),a
        ret
