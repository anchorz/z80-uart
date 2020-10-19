        .module uart_recv
;
;       imports
;

;
;       exports
;
        .globl  uart_recv
;
;       program code
;
        .area  _CODE
uart_recv:
        ld      e,#'.'
        ret
