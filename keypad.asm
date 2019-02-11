#include p18f87k22.inc
    extern  LCD_delay_x4us

    global  KEYPAD_ini_TABLE, KEYPAD_Setup, KEYPAD_loop, Input, button_data
acs0	udata_acs   	 ; reserve data space in access ram
nonpressed  res 1
  
TABLE	udata	0x100    ; reserve data anywhere in RAM (here at 0x400)
myTABLE res 0x0F    	 ; reserve 16 bits for message data

buttondata  udata   0x120
button_data res 1


 
keypad	code

KEYPAD_Setup
    movlw   .15
    movwf   BSR
    bsf	    PADCFG1, REPU, BANKED
    clrf    LATE
    clrf    TRISH,A
    return

Input;set 0-3 as 1
    
    movlw   0x0F
    movwf   TRISE, A
    movlw   .12			; wait 48us
    call    LCD_delay_x4us
       
    movff    PORTE, PORTH  

;4-7 as 1
    movlw   0xF0
    movwf   TRISE, A
    movlw   .12			; wait 48us
    call    LCD_delay_x4us

    movf    PORTE,W		; combine 8 bits
    iorwf   LATH,1,0
        
    call    KEYPAD_loop
    return

KEYPAD_ini_TABLE
    lfsr    FSR0, myTABLE	; Load FSR0 with address in RAM	
    MOVLW    b'01111110'	; input A
    MOVWF   POSTINC0
    MOVLW    b'01111011'	; input B
    MOVWF   POSTINC0
    
    movlw   b'11111111'
    movwf   nonpressed
    
    MOVLW    b'01111101'	; input 0
    MOVWF   POSTINC0
    MOVLW    b'11101110'	; input 1
    MOVWF   POSTINC0
    MOVLW    b'11101101'	; input 2
    MOVWF   POSTINC0
    MOVLW    b'11101011'	; input 3
    RETURN

KEYPAD_loop				; 3 different outputs if different buttons are pressed
loopA
    movf    LATH,W
    lfsr    FSR2, myTABLE	; Load FSR2 with address in RAM
    CPFSEQ  POSTINC2
    goto    loopB
    
    ;call    wait1
    movlw   0x01
    RETURN
loopB
    

    movlw   0x02
    movwf   button_data
    RETURN

    
;wait1
    ;call    Input
    ;cpfseq  nonpressed
    ;goto    wait1
    ;return    


    
    end
