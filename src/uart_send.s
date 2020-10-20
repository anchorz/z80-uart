         .module uart_send
        .include "uart_cfg.s"

.ifeq (V24_CLK_WIDTH-256)
        DELAY = 1
        .macro WAIT
        jp      a$              ;+11
a$:     ld      b,#14           ;+21
b$:     djnz    b$              ;+28 +13*13+8
        .endm
.endif

.ifeq (V24_CLK_WIDTH-208)
        DELAY = 1
        .macro WAIT
        ld      b,#10           ;+11
        ld      b,#10           ;+18
        ld      b,#10           ;+25
b$:     djnz    b$              ;+32
        .endm
.endif

.ifeq (V24_CLK_WIDTH-128)
        DELAY = 1
        .macro WAIT
        jr      a$              ;+11
a$:     ld      b,#4            ;+23
b$:     djnz    b$              ;+30 +3*13+8
        .endm
.endif

.ifeq (V24_CLK_WIDTH-104)
        DELAY = 1
        .macro WAIT
        ld      b,#10           ;+11
        ld      b,#10           ;+18
        ld      b,#2            ;+25
b$:     djnz    b$              ;+32  + 1*13+8
        .endm
.endif

.ifne (DELAY-1)
        .macro WAIT
        ld      hl,#V24_CLK_WIDTH
        .endm
        .error bit width should be implemented with DELAY values above
.endif
;
;       imports
;

;
;       exports
;
        .globl  uart_send
;
;       program code
;
        .area  _CODE
uart_send:
        push    bc
        push    de
        xor     a,a             ;res V24_TX,a
        ld      c,#10
        scf
$next_bit:
        out     (V24_DATA),a    ;+0 / +208
        WAIT
        rr      e               ;+157
        jr      c,$set_one      ;+165
        res     V24_TX,a        ;+172
        jr      $bit_set        ;+180
$set_one:
        set     V24_TX,a        ;+177
        ;fall through
        jr      nc,$bit_set     ;+185
$bit_set:
        dec     c               ;+192
        jr      nz,$next_bit    ;+196
        pop     de
        pop     bc
        ret
