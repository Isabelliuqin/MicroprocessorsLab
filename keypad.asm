#include p18f87k22.inc
    extern  LCD_delay_x4us

    global  KEYPAD_ini_TABLE, KEYPAD_Setup, KEYPAD_loop,Keypad_Input, Keypad_button_ini

	    
cursor_data    udata   0x700    ; reserve data anywhere in RAM (here at 0x400)
nonpressed	res 1
  

  
TABLE	udata	0x100    ; reserve data anywhere in RAM (here at 0x400)
myTABLE res 0x0F    	 ; reserve 16 bits for message data

Keypad_button	udata	0x500
button	res 0x10


keypad	code

	
Keypad_button_ini		    ;number corresponding to keypad pressing AB2468
    movlw	0x0A
    movlb	5
    movwf	0x500, BANKED	    ;input the corresponding number for keypad pressing A

    movlw	0x0B
    movlb	5
    movwf	0x501, BANKED	    ;input the corresponding number for keypad pressing B
    
    movlw	0x02
    movlb	5
    movwf	0x502, BANKED	    ;input the corresponding number for keypad pressing 2
    
    movlw	0x04
    movlb	5
    movwf	0x504, BANKED	    ;input the corresponding number for keypad pressing 4
    
    movlw	0x06
    movlb	5
    movwf	0x506, BANKED	    ;input the corresponding number for keypad pressing 6
    
    movlw	0x08
    movlb	5
    movwf	0x508, BANKED	    ;input the corresponding number for keypad pressing 8
    
    movlw	0xFF
    movlb	5
    movwf	0x5FF, BANKED	    ;input the corresponding number for keypad not pressing any keys
    return
    

	
KEYPAD_Setup
    movlw   .15
    movwf   BSR
    bsf	    PADCFG1, REPU, BANKED
    clrf    LATE
    clrf    TRISH,A
    return

Keypad_Input;set 0-3 as 1
    
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

KEYPAD_ini_TABLE		; binary number corresponding to different keys pressed
    
    lfsr    FSR0, myTABLE	; Load FSR0 with address in RAM	
    MOVLW    b'01111110'	; input A
    MOVWF   POSTINC0
    MOVLW    b'01111011'	; input B
    MOVWF   POSTINC0
    
    
    
    MOVLW    b'11101101'	; input 2
    MOVWF   POSTINC0
    MOVLW    b'11011110'	; input 4
    MOVWF   POSTINC0
    MOVLW    b'11011011'	; input 6
    MOVWF   POSTINC0
    MOVLW    b'10111101'	; input 8
    MOVWF   POSTINC0
    movlw   b'11111111'		; not pressing any keys
    RETURN

KEYPAD_loop	; 6 different outputs if different buttons are pressed
    movlw   0x00
    movwf   nonpressed
				
    movf    LATH,W
    lfsr    FSR2, myTABLE	; Load FSR2 with address in RAM
loopA
   
    CPFSEQ  POSTINC2		; compare the keypad input with the table, if the key pressed is A, stay in the loop
    goto    loopB		; otherwise goto loop B
    
    ;call    wait1
    call    Keypad_pressed
    movlw   0x0A		; W=A when A is checked being pressed
    
    RETURN
loopB
    CPFSEQ  POSTINC2
    goto    loop2
    call    Keypad_pressed
    ;call    wait1
    movlw   0x0B		; W=B when A is checked being pressed
    RETURN
loop2
    CPFSEQ  POSTINC2
    goto    loop4
    call    Keypad_pressed
    movlw   0x02		; W=2 when A is checked being pressed
    RETURN
loop4
    CPFSEQ  POSTINC2
    goto    loop6
    call    Keypad_pressed
    movlw   0x04		; W=4 when A is checked being pressed
    RETURN
loop6
    CPFSEQ  POSTINC2
    goto    loop8
    call    Keypad_pressed
    movlw   0x06		; W=6 when A is checked being pressed
    RETURN
loop8				
    CPFSEQ  POSTINC2
    goto    Keypad_Input
    call    Keypad_pressed
    movlw   0x08		; W=8 when A is checked being pressed
    
    RETURN

    
    
Keypad_pressed
    movlw   0xFF
    movwf   nonpressed
    return
    




    
;wait1
    ;call    Input
    ;cpfseq  nonpressed
    ;goto    wait1
    ;return    


    
    end
