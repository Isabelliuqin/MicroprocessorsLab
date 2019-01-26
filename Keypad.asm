
    
#include p18f87k22.inc
    
extern	LCD_delay_x4us

KEYPAD_Setup
    bsf	    PADCFG1, REPU, banked
    clrf    LATE

Output_0_3
    movlw   0xf0
    movwf   TRISE, A
    movlw   .10		; wait 40us
    call    LCD_delay_x4us
    
    movf    PORTE, PORTH
    
Output_4_7
    movlw   0x0f
    movwf   TRISE, A
    movlw   .10		; wait 40us
    call    LCD_delay_x4us
    movlw   0xF0
    andwf   PORTE, W
    movf    W, PORTH
    


