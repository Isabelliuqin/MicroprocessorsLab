#include p18f87k22.inc
 
	;global
	extern	    LCD_Send_Byte_D, LCD_shift
	
acs0	udata_acs
	card_set1   res 10  ;player's cards
	card_set2   res 10  ;dealer's cards
	counter	    res 100
	uptofifteen res 1
        import	    res 10


    
RNG code
card_poll
 
    movlw	0xA		; value above 9 goto large value subroutine
    CPFSLT	PORTD
    goto	large_value
    
    movlw	0x02		;value below 2 goto small value subroutine
    CPFSGT	PORTD
    goto	small_value

middle_value			;2-9
    
 
    movf	uptofifteen,W	;first digit
    movwf	card_set1
    addlw	0x30		;change to ascii code	   
    call	LCD_Send_Byte_D	;send the ascii code of one of value from {2-9} to LCD
    call	LCD_shift
    return

large_value			;1,10-13
    movlw	0xE		; if the value = 14, 15, loop again
    CPFSLT	PORTD
    goto	counter_setup
    
    lfsr	FSR0, counter	; Load FSR0 with address in RAM	
    MOVLW	0x0A		;input 10
    MOVWF	POSTINC0
    MOVLW	0x0B		;input J
    MOVWF	POSTINC0
    MOVLW	0x0C		;input Q
    MOVWF	POSTINC0
    MOVLW	0x0D		;input K
    MOVWF	POSTINC0
    return

small_value			;0,1
    movlw	0x01		; if the value = 0, loop again
    CPFSEQ	PORTD
    goto	counter_setup	
    
    movlw	0x41		; for input = 1, send ascii code of A to LCD		
    call	LCD_Send_Byte_D	;send 1 byte of data to LCD
    call	LCD_shift
    
    return
    
    
    
loop    
	movf    PORTD,W
	lfsr    FSR2, import	; Load FSR2 with address in RAM
	
    loop0			; check input 1
	CPFSEQ  POSTINC2
	goto    loop1
	MOVLW	0x41
	MOVF	PORTJ
	;RETURN
    loop1
	CPFSEQ  POSTINC2
	goto    loop2
	MOVLW	0x4A
	RETURN
    loop2
	CPFSEQ  POSTINC2
	goto    loop3
	MOVLW	0x51
	RETURN
    loop3
	CPFSEQ  POSTINC2
	goto    loop4
	MOVLW   0x4B
	RETURN
    loop4
	CPFSEQ  POSTINC2
	goto    loop5
	MOVLW   '4'
	RETURN
 
counter_setup
    clrf	TRISD		; Set PORTD as all outputs
    clrf	LATD		; Clear PORTD outputs
    movlw	b'10000111'	; Set timer0 to 16-bit, Fosc/4/256
    movwf	T0CON		; = 62.5KHz clock rate, approx 1sec rollover
    
    movlw	b'00001111'	;pick the last 4 digits
    andwf	PORTD, 0
    movwf	uptofifteen
    
    return
    
loop
    
    
    
    
    
    
    end
   


 



