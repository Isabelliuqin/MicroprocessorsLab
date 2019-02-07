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

small_value			;2-9
    movlw	0xA
    CPFSLT	PORTD
    goto	large_value
 
    movf	uptofifteen,W		;first digit
    movwf	card_set1
    addlw	0x30		;change to ascii code	   
    call	LCD_Send_Byte_D	;send 1 byte of data to LCD
    call	LCD_shift
 
large_value			;1,10-13
    lfsr	FSR0, counter	; Load FSR0 with address in RAM	
    MOVLW	0x01		;input A
    MOVWF	POSTINC0
    MOVLW	0x0A		;input 10
    MOVWF	POSTINC0
    MOVLW	0x0B		;input J
    MOVWF	POSTINC0
    MOVLW	0x0C		;input Q
    MOVWF	POSTINC0
    MOVLW	0x0D		;input K
    MOVWF	POSTINC0
    
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
   


 



