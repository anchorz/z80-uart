        .module uart_recv
        .include "uart_cfg.s"

.ifeq (V24_CLK_WIDTH-256)
        .macro WAIT_HALF
        DELAY = 1
        ld      b,#06                           ; +26
$3:     djnz    $3                              ; +33 loop=5*13+1*8
        ld      bc,#0x0008                      ; +106
        jr      $7                              ; +116
$7:                                             ; +128
        .endm
        .macro WAIT
        ld      b,#2                            ; +26
$1:     djnz    $1                              ; +33 1*13+8
        jr      com_get_byte_next_bit           ; +54
com_get_byte_next_bit:
        ld      b,#11                           ; +66
$4:     djnz    $4                              ; +73 +10*13+8
        ld      b,#00                           ; +237
        jr      $5                              ; +244
                                                ; +256
        .endm
.endif


.ifeq (V24_CLK_WIDTH-208)
        .macro WAIT_HALF
        DELAY = 1
        ld      b,#05                           ; +26
$3:     djnz    $3                              ; +33 loop=4*13+1*8
        ld      c,#0x08                         ; +93
        nop                                     ; +100
                                                ; +104
        .endm
        .macro WAIT
        ld      b,#2                            ; +26
$1:     djnz    $1                              ; +33 1*13+8
        jr      com_get_byte_next_bit           ; +54
com_get_byte_next_bit:
        ld      b,#10                           ; +66
$4:     djnz    $4                              ; +73
        jp      $5                              ; +208
        .endm
.endif

.ifeq (V24_CLK_WIDTH-128)
        .macro WAIT_HALF
        DELAY = 1
        ld      b,#02                           ; +26
$3:     djnz    $3                              ; +33 loop=1*13+1*8
        ld      bc,#0x08                        ; +54
                                                ; +64
        .endm
        .macro WAIT
        ld      b,#2                            ; +26
$1:     djnz    $1                              ; +33 1*13+8
        jr      com_get_byte_next_bit           ; +54
com_get_byte_next_bit:
        ld      b,#4                            ; +66
$4:     djnz    $4                              ; +73 3*13+8
        nop                                     ; +120
        nop                                     ; +124
                                                ; +128
        .endm
.endif

.ifeq (V24_CLK_WIDTH-104)
        .macro WAIT_HALF
        DELAY = 1
        ld      b,#01                           ; +26
$3:     djnz    $3                              ; +33 loop=0*13+1*8
        ld      c,#0x08                         ; +41
        nop                                     ; +48
                                                ; +52
        .endm
        .macro WAIT
        ld      b,#2                            ; +26
$1:     djnz    $1                              ; +33 1*13+8
        jr      com_get_byte_next_bit           ; +54
com_get_byte_next_bit:
        ld      b,#2                            ; +66
$4:     djnz    $4                              ; +73 1*13+8
        jp      $5                              ; +208
        .endm
.endif

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
; IN: E byte to send
; OUT: none
; modified registers: A
uart_recv:
        push    bc
        ld      e,#0
com_get_byte_wait_for_start:
        in      a,(V24_DATA)                    ;  wait from here 104 clock cycles to see check the middle of start bit
        bit     V24_RX,a                        ; +11
        jr      nz,com_get_byte_wait_for_start  ; +19
        WAIT_HALF
        in      a,(V24_DATA)                    ; +104
        ; wait from here another 208 clock cycles to read middle of the first bit
        bit     V24_RX,a                        ; +11
        jr      nz,com_get_byte_wait_for_start  ; +19
        WAIT
$5:     in      a,(V24_DATA)                    ; +11
        bit     V24_RX,a                        ; +19
        jr      nz,com_get_byte_is_one          ; +31
        or      a,a                             ; clear CF
        jr      com_get_byte_rol
com_get_byte_is_one:
        scf                                     ; +35
        ; fall through to have same number of clock cycles on each branch
        jr      nc,com_get_byte_rol             ; +42
com_get_byte_rol:
        rr      e                               ; +50
        dec     c                               ; +54
        jr      nz,com_get_byte_next_bit        ; +66
        ld      b,#2
$6:     djnz    $6
        pop     bc
        ret
