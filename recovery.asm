#include p18f87k22.inc

    global	Recovery_card
    extern	LCD_rightcorner, LCD_Send_Byte_D, LCD_leftshift4, LCD_rightshift,LCD_clear_display
    
recovery_data	udata_acs   ; reserve data space in access ram
nocard		res 1
Recovery_counter    res 1
cardvalue	res 1

Recovery    code
    

Recovery_card
    ;call    LCD_clear_display
    
    movlw   0x00			; nocard describe the number in the memory register when no card is put into
    movwf   nocard
    movlw   0xA
    movwf   Recovery_counter
    
Recovery_dealer    
    movlb   4
    lfsr    FSR0, 0x410
    
Recovery_loop_dealer
    
    movf    POSTINC0, W
    movwf   cardvalue
    
    call    Recovery_poll		; if card is stored, send the card to LCD screen

    decfsz  Recovery_counter		; count down to zero
    bra	    Recovery_loop_dealer 	; keep going until finished

Recovery_player
    movlb   4
    lfsr    FSR0, 0x400
    call    LCD_rightcorner		; put the card in rightcorner
    
Recovery_loop_player
    movf    POSTINC0, W
    movwf   cardvalue
    
    call    Recovery_poll		; if card is stored, send the card to LCD screen

    decfsz  Recovery_counter		; count down to zero
    bra	    Recovery_loop_player 	; keep going until finished

    return 

    
Recovery_dealer_card_to_LCD
    call    LCD_Send_Byte_D	
    call    LCD_rightshift
    return

Recovery_player_card_to_LCD
    call    LCD_Send_Byte_D	
    call    LCD_leftshift4
    return
    
Recovery_poll				; send ascii code of cardset to LCD to recover the game
 
    movlw	    0xA			; value above 9 goto large value subroutine
    CPFSLT	    cardvalue
    goto	    large_value
    
    movlw	    0x02		;value below 2 goto small value subroutine
    CPFSGT	    cardvalue
    goto	    small_value

middle_value				;2-9
    
    movf	    cardvalue,W		;first digit
    addlw	    0x30		;change to ascii code	   
    call	    LCD_Send_Byte_D	;send the ascii code of one of value from {2-9} to LCD

    call	    LCD_rightshift
    return

large_value				;10-13
    
loop10
    movf	    cardvalue,W
    movlb	    4
    lfsr	    FSR2, 0x440		;Load FSR2 with address in RAM
    CPFSEQ	    POSTINC2
    goto	    loopJ
	
    MOVLW	    b'01011000'		;dealer's interface, send 'X'
    call	    LCD_Send_Byte_D	;send the ascii code of one of value from {2-9} to LCD
    
    call	    LCD_rightshift

    RETURN
    
loopJ
    CPFSEQ	    POSTINC2
    goto	    loopQ
    MOVLW	    0x4A		;dealer's interfact, input 'J'
    call	    LCD_Send_Byte_D	;send the ascii code of one of value from {2-9} to LCD
    call	    LCD_rightshift
    movlw	    0xA		;J is recognised as 10
 
    RETURN
    
loopQ
    CPFSEQ	    POSTINC2
    goto	    loopK
    MOVLW	    0x51		;dealer's interfact, input 'Q'
    call	    LCD_Send_Byte_D	;send the ascii code of one of value from {2-9} to LCD
    call	    LCD_rightshift
    movlw	    0xA		;Q is recognised as 10
    RETURN
    
loopK
    MOVLW	    0x4B		;dealer's interfact, input 'K'
    call	    LCD_Send_Byte_D	;send the ascii code of one of value from {2-9} to LCD
    call	    LCD_rightshift
    movlw	    0xA		;K is recognised as 10
    RETURN    
	

small_value				;0,1
    
    movlw	    0x41		;for input = 1, send ascii code of A to LCD		
    call	    LCD_Send_Byte_D	;send 1 byte of data to LCD
    call	    LCD_rightshift
    
    return
    
    end


