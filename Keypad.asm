#include p18f87k22.inc
    GLOBAL  ini_TABLE, KEYPAD_Setup,Input
    extern	LCD_delay_x4us
    
acs0	udata_acs   ; reserve data space in access ram
TABLE	udata	0x100    ; reserve data anywhere in RAM (here at 0x400)
myTABLE res 0x0F    ; reserve 16 bits for message data

keypad	code
        
KEYPAD_Setup
    movlw   .15
    movwf   BSR
    bsf	    PADCFG1, REPU, BANKED
    clrf    LATE
    clrf    TRISH,A
    clrf    LATJ
    CLRF    TRISJ,A
    MOVLW   0Xff
    MOVF    PORTJ,A
    return

Input;set 0-3 as 1
    
    movlw   0x0F
    movwf   TRISE, A
    movlw   .12		; wait 48us
    call    LCD_delay_x4us
    
    
    movff    PORTE, PORTH  
;4-7 as 1
    movlw   0xF0
    movwf   TRISE, A
    movlw   .12		; wait 48us
    call    LCD_delay_x4us

    MOVF    PORTE,W
    IORWF   LATH,1,0
    call    loop
    return
    
    
ini_TABLE
    lfsr    FSR0, myTABLE	; Load FSR0 with address in RAM	
    MOVLW    b'01111101'	;input 0
    MOVWF   POSTINC0
    MOVLW    b'11101110'	;input 1
    MOVWF   POSTINC0
    MOVLW    b'11010111'	;input 2
    MOVWF   POSTINC0
    MOVLW    b'10110111'	;input 3
    MOVWF   POSTINC0
    MOVLW    b'11101011'	;input 4
    MOVWF   POSTINC0
    MOVLW    b'11011011'	;input 5
    MOVWF   POSTINC0
    MOVLW    b'10111011'	;input 6
    MOVWF   POSTINC0
    MOVLW    b'11101101'	;input 7
    MOVWF   POSTINC0
    MOVLW    b'11011101'	;input 8
    MOVWF   POSTINC0
    MOVLW    b'10111101'	;input 9
    MOVWF   POSTINC0
    MOVLW    b'11101110'	;input A
    MOVWF   POSTINC0
    MOVLW    b'10111110'	;input B
    MOVWF   POSTINC0
    MOVLW    b'01111110'	;input C
    MOVWF   POSTINC0
    MOVLW    b'01111101'	;input D
    MOVWF   POSTINC0
    MOVLW    b'01111011'	;input E
    MOVWF   POSTINC0
    MOVLW    b'01110111'	;input F
    MOVWF   POSTINC0
    RETURN
    
loop    
    loop0
	movf    PORTH,W
	lfsr    FSR2, myTABLE	; Load FSR2 with address in RAM
	CPFSEQ  POSTINC2
	goto    loop1
	MOVLW	.0
	MOVF	PORTJ
	RETURN
    loop1
	CPFSEQ  POSTINC2
	goto    loop2
	MOVLW	'1'
	RETURN
    loop2
	CPFSEQ  POSTINC2
	goto    loop3
	MOVLW   '2'
	RETURN
    loop3
	CPFSEQ  POSTINC2
	goto    loop4
	MOVLW   '3'
	RETURN
    loop4
	CPFSEQ  POSTINC2
	goto    loop5
	MOVLW   '4'
	RETURN
    loop5
	CPFSEQ  POSTINC2
	goto    loop6
	MOVLW   '5'
	RETURN
    loop6
	CPFSEQ  POSTINC2
	goto    loop7
	MOVLW   '6'
	RETURN
    loop7
	CPFSEQ  POSTINC2
	goto    loop8
	MOVLW   '7'
	RETURN
    loop8
	CPFSEQ  POSTINC2
	goto    loop9
	MOVLW   '8'
	RETURN
    loop9
	CPFSEQ  POSTINC2
	goto    loopA
	MOVLW   '9'
	RETURN
    loopA
	CPFSEQ  POSTINC2
	goto    loopB
	MOVLW   'A'
	RETURN
    loopB
	CPFSEQ  POSTINC2
	goto    loopC
	MOVLW  'B'
	RETURN
    loopC
	CPFSEQ  POSTINC2
	goto    loopD
	MOVLW  'C'
	RETURN
    loopD
	CPFSEQ  POSTINC2
	goto    loopE
	MOVLW   'D'
	RETURN
    loopE
	CPFSEQ  POSTINC2
	goto    loopF
	MOVLW   'E'
	RETURN
    loopF
	CPFSEQ  POSTINC2
	goto    Input
	MOVLW   'F' 
	RETURN

	
	
	
	
    end
    	


=======
#include p18f87k22.inc

setup
	setf	PORTE
	; ******* Programme FLASH read Setup Code ***********************
	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory
