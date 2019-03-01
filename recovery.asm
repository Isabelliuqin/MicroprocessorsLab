#include p18f87k22.inc

    global	Recovery_card
    extern	LCD_rightcorner, LCD_Send_Byte_D, LCD_leftshift, LCD_rightshift,LCD_clear_display,LCD_Send_Byte_I,LCD_sq
    extern	Command_recoverycomplete,loop_YES
    
recovery_data	udata_acs   ; reserve data space in access ram
nocard		res 1
Recovery_counter    res 1
Recovery_counter2    res 1
cardvalue_dealer	res 1
cardvalue_player	res 1
zero		    res 1
number_JQK10	    res 1		   
Recovery    code
    

Recovery_card
    
    movlw   0x00			; nocard describe the number in the memory register when no card is put into
    movwf   nocard
    movlw   0xA
    movwf   Recovery_counter		;counter for dealer's card recovery
    movlw   0xA
    movwf   Recovery_counter2		;counter for player's card recovery
    movlw   0x00
    movwf   zero
    
Recovery_dealer    
    movlb   4
    lfsr    FSR0, 0x410
    
Recovery_loop_dealer
    
    movf    POSTINC0, W			;put cards value for dealer's card in cardvalue_dealer
    movwf   cardvalue_dealer
    
    call    Recovery_poll_dealer	; if card is stored, send the card to LCD screen

    decfsz  Recovery_counter		; count down to zero
    bra	    Recovery_loop_dealer 	; keep going until finished
Show_hiddencard				; goto check whether we need to show the hidden card after the counter counts to 0
    movlw   0x00
    movlb   4
    cpfseq  0x411, BANKED		; check if the second card of the dealer is picked , if no show the hidden card
    goto    Recovery_player		; if yes recover the player's card
    movlw   b'10000010'			
    call    LCD_Send_Byte_I
    call    LCD_sq
    goto    Recovery_player		; after show the hidden card, recover the player's card


    
Recovery_poll_dealer				; send ascii code of cardset to LCD to recover the game
nocard_						;if no card in a memory location, counter - 1
    movlw	    0x00
    cpfseq	    cardvalue_dealer
    goto	    one
    return
one					; if the card value is 1, recover Ace on LCD
    movlw	    0x01		;value below 2 goto small value subroutine
    CPFSEQ	    cardvalue_dealer
    goto	    eleven
    goto	    recoverA
eleven					; if the card value is 11, recover Ace on LCD
    movlw	    0xB
    CPFSEQ	    cardvalue_dealer
    goto	    JQKten
    goto	    recoverA
    
;10/J/Q/K?
JQKten
    movlw	    0xA			; if the card value stored is 10, goto large value counter
    cpfseq	    cardvalue_dealer
    goto	    middle_value
    goto	    large_value
    return
    
    
middle_value					;2-9  
    movf	    cardvalue_dealer,W		;first digit
    addlw	    0x30			;change to ascii code	   
    call	    LCD_Send_Byte_D		;send the ascii code of one of value from {2-9} to LCD

    call	    LCD_rightshift
    return    

recoverA     
    movlw	    0x41			;send ascii code of A to LCD		
    call	    LCD_Send_Byte_D		;send 1 byte of data to LCD
    call	    LCD_rightshift
    
    return



large_value					;10-13
loop10
    movlb	    4
    movf	    0x463,W, BANKED
    movwf	    number_JQK10
    
loop10_
    movlb	    4
    cpfslt	    zero			; if ten_counter_dealer larger than 0, display X on LCD
    
    goto	    loopJ
	
    MOVLW	    b'00000000'			;dealer's interface, send 'X'
    call	    LCD_Send_Byte_D		;send the ascii code of one of value from {2-9} to LCD
    
    call	    LCD_rightshift	    
    decfsz	    number_JQK10		
    bra		    loop10_			; keep going until finished

    RETURN
    
loopJ
    movlb	    4
    movf	    0x460,W, BANKED
    movwf	    number_JQK10
    
loopJ_     
    movlb	    4
    cpfslt	    zero			; if ten_counter_dealer larger than 0, display X on LCD
    
    goto	    loopQ
	
    MOVLW	    0x4A			;dealer's interfact, input 'J'
    call	    LCD_Send_Byte_D		;send the ascii code of one of value from {2-9} to LCD
    
    call	    LCD_rightshift		    
    decfsz	    number_JQK10
    bra		    loopJ_			; keep going until finished

    RETURN
    
    
loopQ
    movlb	    4
    movf	    0x461,W, BANKED
    movwf	    number_JQK10
    
loopQ_
    movlb	    4
    cpfslt	    zero			; if ten_counter_dealer larger than 0, display X on LCD
    
    goto	    loopK
	
    MOVLW	    0x51			;dealer's interfact, input 'J'
    call	    LCD_Send_Byte_D		;send the ascii code of one of value from {2-9} to LCD
    
    call	    LCD_rightshift	    
    decfsz	    number_JQK10
    bra		    loopQ_			; keep going until finished

    RETURN
    
    
loopK
    movlb	    4
    movf	    0x462,W, BANKED
    movwf	    number_JQK10
    
loopK_
    cpfslt	    zero			; if ten_counter_dealer larger than 0, display X on LCD
    return
    
    MOVLW	    0x4B		;dealer's interfact, input 'K'
    call	    LCD_Send_Byte_D		;send the ascii code of one of value from {2-9} to LCD
    
    call	    LCD_rightshift	    
    decfsz	    number_JQK10
    bra		    loopK_			; keep going until finished

    RETURN  
    
;same except for the registers of counters        
Recovery_player
    movlb   4
    lfsr    FSR0, 0x400
    call    LCD_rightcorner		; put the card in rightcorner
           
Recovery_loop_player
    movf    POSTINC0, W
    movwf   cardvalue_player
    
    call    Recovery_poll_player		; if card is stored, send the card to LCD screen
    
    decfsz  Recovery_counter2		; count down to zero
    bra	    Recovery_loop_player 	; keep going until finished    
    goto    loop_YES			; go back to command make choice when all player's card is recovered   
    
Recovery_poll_player				; send ascii code of cardset to LCD to recover the game    
nocard__
    movlw	    0x00
    cpfseq	    cardvalue_player
    goto	    one_
    return
one_
    movlw	    0x01		;value below 2 goto small value subroutine
    CPFSEQ	    cardvalue_player
    goto	    eleven_
    goto	    recoverA_
eleven_
    movlw	    0xB
    CPFSEQ	    cardvalue_player
    goto	    JQKten_
    goto	    recoverA_
    
;10/J/Q/K?
JQKten_
    movlw	    0xA			; card value stored as 10 goto check JQK
    cpfseq	    cardvalue_player
    goto	    middle_value_
    goto	    large_value_
    return

middle_value_				;2-9  
    movf	    cardvalue_player,W		;first digit
    addlw	    0x30		;change to ascii code	   
    call	    LCD_Send_Byte_D	;send the ascii code of one of value from {2-9} to LCD

    call	    LCD_leftshift
    call	    LCD_leftshift
    call	    LCD_leftshift
    return    

recoverA_     
    movlw	    0x41		;for input = 1, send ascii code of A to LCD		
    call	    LCD_Send_Byte_D	;send 1 byte of data to LCD
    call	    LCD_leftshift
    call	    LCD_leftshift
    call	    LCD_leftshift
    
    return

large_value_				;10-13
				;10-13
loop10_1
    movlb	    4
    movf	    0x473,W, BANKED
    movwf	    number_JQK10
    
loop10__1   
    movlb	    4
    cpfslt	    zero			; if ten_counter_dealer larger than 0, display X on LCD
    
    goto	    loopJ_1
	
    MOVLW	    b'00000000'			;dealer's interface, send 'X'
    call	    LCD_Send_Byte_D		;send the ascii code of one of value from {2-9} to LCD
    
    call	    LCD_leftshift
    call	    LCD_leftshift
    call	    LCD_leftshift	    
    decfsz	    number_JQK10
    bra		    loop10__1			; keep going until finished

    RETURN
    
loopJ_1
    movlb	    4
    movf	    0x470,W, BANKED
    movwf	    number_JQK10
    
loopJ__1      
    movlb	    4
    cpfslt	    zero			; if ten_counter_dealer larger than 0, display X on LCD
    
    goto	    loopQ_1
	
    MOVLW	    0x4A			;dealer's interfact, input 'J'
    call	    LCD_Send_Byte_D		;send the ascii code of one of value from {2-9} to LCD
    
    call	    LCD_leftshift
    call	    LCD_leftshift
    call	    LCD_leftshift	    
    decfsz	    number_JQK10
    bra		    loopJ__1			; keep going until finished

    RETURN
    
    
loopQ_1
    movlb	    4
    movf	    0x471,W, BANKED
    movwf	    number_JQK10
    
loopQ__1
    movlb	    4
    cpfslt	    zero			; if ten_counter_dealer larger than 0, display X on LCD
    
    goto	    loopK_1
	
    MOVLW	    0x51			;dealer's interfact, input 'J'
    call	    LCD_Send_Byte_D		;send the ascii code of one of value from {2-9} to LCD
    
    call	    LCD_leftshift
    call	    LCD_leftshift
    call	    LCD_leftshift	    
    decfsz	    number_JQK10
    bra		    loopQ__1			; keep going until finished

    RETURN
    
    
loopK_1
    movlb	    4
    movf	    0x472,W, BANKED
    movwf	    number_JQK10
    
loopK__1
    cpfslt	    zero			; if ten_counter_dealer larger than 0, display X on LCD
    return
    MOVLW	    0x4B		;dealer's interfact, input 'K'
    call	    LCD_Send_Byte_D		;send the ascii code of one of value from {2-9} to LCD
    
    call	    LCD_leftshift
    call	    LCD_leftshift
    call	    LCD_leftshift		    
    decfsz	    number_JQK10
    bra		    loopK__1			; keep going until finished

    RETURN     

    end


