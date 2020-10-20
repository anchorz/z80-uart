        .module crt0
;
;       imports
;
        .globl  main
;
;       exports
;
        .globl  putchar
;
;       program code
;
        .area   _HEADER (ABS) 
        .area   _CODE (REL,CON) 
        .area   _BSS (REL,CON) 
        .area   _DATA (REL,CON) 
        
        .area   _HEADER
        .dw     start
        .dw     s__DATA-1
        .dw     start
        .ascii  'SDASZ8'
        .db     'C'
        .db     0xd3,0xd3,0xd3
        .ascii  'UART DEMO1      '
        
        .area   _CODE
start:
        call    main
        rst     0x38

putchar:
        rst     0x20
        .db     0x00
        ret
