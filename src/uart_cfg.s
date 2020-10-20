V24_DATA                = 0x00
V24_CONTROL             = 0x01
V24_RX                  = 1
V24_TX                  = 0
BAUDRATE                = 9600                 ;the implementation is for 9600 or 19200 baud
CLK                     = 2000000               ; and 2 MHz or 2.45 MHz only
;CLK                     = 2457600
V24_CLK_WIDTH           = (CLK/BAUDRATE)        ; 2.000.000 /  9600 = 208
;                                               ; 2.000.000 / 19200 = 104
;                                               ; 2.457.600 /  9600 = 256
;                                               ; 2.457.600 / 19200 = 128



