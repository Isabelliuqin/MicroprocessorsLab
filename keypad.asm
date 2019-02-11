#include p18f87k22.inc

GLOBAL  KEYPAD_ini_TABLE, KEYPAD_Setup, KEYPAD_loop
acs0	udata_acs   	 ; reserve data space in access ram
TABLE	udata	0x100    ; reserve data anywhere in RAM (here at 0x400)
myTABLE res 0x0F    	 ; reserve 16 bits for message data

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

    mof    PORTE,W
    iorwf   LATH,1,0
    call    loop
    return

KEYPAD_ini_TABLE
    lfsr    FSR0, myTABLE	; Load FSR0 with address in RAM	
    MOVLW    b'01111101'	; input 0
    MOVWF   POSTINC0
    MOVLW    b'11101110'	; input 1
    MOVWF   POSTINC0
    MOVLW    b'11010111'	; input 2
    MOVWF   POSTINC0
    MOVLW    b'10110111'	; input 3
    RETURN

KEYPAD_loop				; 3 different outputs if different buttons are pressed
    loop0
	movf    PORTH,W
	lfsr    FSR2, myTABLE	; Load FSR2 with address in RAM
	CPFSEQ  POSTINC2
	goto    loop1
	call	one
	RETURN
    loop1
	CPFSEQ  POSTINC2
	goto    loop2
	call	two
	RETURN
    loop2
	CPFSEQ  POSTINC2
	goto    loop3
	MOVLW   three
