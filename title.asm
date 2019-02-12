	#include p18f87k22.inc
	global	title_setup
	extern  LCD_Setup, LCD_Write_Message, LCD_row_shift    ; external LCD subroutines
	extern	Input
	


acs0	udata_acs   ; reserve data space in access ram
counter	    res 1   ; reserve one byte for a counter variable
delay_count res 1   ; reserve one byte for counter in the delay routine


tables	udata	0x300    ; reserve data anywhere in RAM (here at 0x400)
myArray res 0x40    ; reserve 64 bytes for message data


pdata	code    ; a section of programme memory for storing data

	; ******* myTable, data in programme memory, and its length *****
name	data	    "Blackjack\n"	; message, plus carriage return
	constant    title_l=.10	; length of data
Title_2	data	    "Press to Start\n"	; message, plus carriage return
	constant    title_l2=.15	; length of data
	; ******* Programme FLASH read Setup Code ***********************
title_setup	
	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory
	goto	start

	; ******* Main programme ****************************************
start 	lfsr	FSR0, myArray	; Load FSR0 with address in RAM	
	movlw	upper(name)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(name)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(name)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	title_l		; bytes to read
	movwf 	counter		; our counter register
loop 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	counter		; count down to zero
	bra	loop		; keep going until finished
		
	movlw	title_l-1	; output message to LCD (leave out "\n")
	lfsr	FSR2, myArray
	
	;movlw	b'10000010'	;set the string to the middle of LCD
	;call LCD_Move_to_position 
	call	LCD_Write_Message
	
	call	LCD_row_shift
	
	lfsr	FSR0, myArray	; Load FSR0 with address in RAM	
	movlw	upper(Title_2)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(Title_2)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(Title_2)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	title_l2		; bytes to read
	movwf 	counter		; our counter register
loop2 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	counter		; count down to zero
	bra	loop2		; keep going until finished
		
	movlw	title_l2-1	; output message to LCD (leave out "\n")
	lfsr	FSR2, myArray
	call	LCD_Write_Message

	;interupt
;Title_press_to_start
	;call	KEYPAD_loop
	;cpfseq  buttonA
	return
	end


