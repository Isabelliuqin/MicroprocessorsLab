#include p18f87k22.inc
 
	global	    counter_setup, table_setup, counter_pickvalue
	extern	    LCD_Send_Byte_D, LCD_rightshift,LCD_leftshift4
	extern	    addition_player,addition_dealer
	
JQK_TABLE	udata	0x440
table		res 10
		
acs0	udata_acs
uptofifteen	res 1
import		res 10
twenty_one	res 1		
	    
int_hi	code	0x0008	; high vector, no low vector
	
    btfss	INTCON,TMR0IF	; check that this is timer0 interrupt
    retfie	FAST		; if not then return
    incf	LATD		; increment PORTD
    bcf		INTCON,TMR0IF	; clear interrupt flag
    retfie	FAST		; fast return from interrupt
		
RNG code
 
counter_setup
    clrf	TRISD		; Set PORTD as all outputs
    clrf	LATD		; Clear PORTD outputs
    movlw	b'10000011'	; Set timer0 to 16-bit, Fosc/4/256
    movwf	T0CON		; = 62.5KHz clock rate, approx 1sec rollover
    bsf		INTCON,TMR0IE	; Enable timer0 interrupt
    bsf		INTCON,GIE	; Enable all interrupts
    
    
    return

table_setup
    ; put 21 in memory register
    movlw	0x15
    movwf	twenty_one
    
    ; Set value for 10, J,Q,K,
    lfsr	FSR0, table	; Load FSR0 with address in RAM	
    MOVLW	0x0A		;input 10
    MOVWF	POSTINC0
    MOVLW	0x0B		;input J
    MOVWF	POSTINC0
    MOVLW	0x0C		;input Q
    MOVWF	POSTINC0
    MOVLW	0x0D		;input K
    MOVWF	POSTINC0
    return

counter_pickvalue    
    movlw	b'00001111'	;pick the last 4 digits
    andwf	LATD, 0
    movwf	uptofifteen
     
    goto	card_poll
    

card_poll
 
    movlw	    0xA		    ; value above 9 goto large value subroutine
    CPFSLT	    uptofifteen
    goto	    large_value
    
    movlw	    0x02		;value below 2 goto small value subroutine
    CPFSGT	    uptofifteen
    goto	    small_value

middle_value			;2-9
    
    movf	    uptofifteen,W	;first digit
    addlw	    0x30		;change to ascii code	   
    call	    LCD_Send_Byte_D	;send the ascii code of one of value from {2-9} to LCD
    call	    LCD_rightshift
    movf	    uptofifteen, W
    return

large_value			;10-13
    movlw	    0xE		; if the value = 14, 15, loop again
    CPFSLT	    uptofifteen
    goto	    counter_pickvalue
    
loop    
loop10
    movf	    uptofifteen,W
    lfsr	    FSR2, table	;Load FSR2 with address in RAM
    CPFSEQ	    POSTINC2
    goto	    loopJ
	
    MOVLW	    b'01011000'		;dealer's interface, send 'X'
    call	    LCD_Send_Byte_D	;send the ascii code of one of value from {2-9} to LCD
    
    call	    LCD_rightshift
    movf	    uptofifteen, W
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
    movlw	    0x01		;if the value = 0, loop again
    CPFSEQ	    uptofifteen
    goto	    counter_pickvalue	
    
    movlw	    0x41		;for input = 1, send ascii code of A to LCD		
    call	    LCD_Send_Byte_D	;send 1 byte of data to LCD
    call	    LCD_rightshift
    
Ace_value
ace11
    call	    addition_player
    addlw	    0xB			;add 11 to the sum of the picked values
    
    CPFSGT	    twenty_one		;compare added value with 21, input 11 for summation if summed values + 11 smaller than 21
    goto	    ace01	    
    movlw	    0xB		;use 11 for addition
    return
    
ace01  
    movlw	    0x01
    return
    
    
    

    
    
    end
   


 



