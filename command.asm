#include p18f87k22.inc
    
global	Choice_hit_or_stand	
extern	Cursormove
    acs0	udata_acs   ; reserve data space in access ram
    counter	    res 1   ; reserve one byte for a counter variable
    delay_count res 1   ; reserve one byte for counter in the delay routine


hit_data	udata	0x600    ; reserve data anywhere in RAM (here at 0x400)
hit_Array res 0x100    ; reserve 64 bytes for message data


pdata	code    ; a section of programme memory for storing data

	; ******* myTable, data in programme memory, and its length *****
hit	data	    "Hit?\n"	; message, plus carriage return
	constant    hit_c=.4	; length of data
choice1	data	    "Yes No ...\n"	; message, plus carriage return
	constant    choice1_c =.10	; length of data

choice2	data	    "Double Down\n"	; message, plus carriage return
	constant    choice2_c =.11	; length of data
	
choice3	data	    "Surrender\n"	; message, plus carriage return
	constant    choice3_c =.9	; length of data
	; ******* Programme FLASH read Setup Code ***********************
hit_setup	
	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory
	return

	; ******* Main programme ****************************************
	
	; HIT------ -------
command_start 	
	call	LCD_clear	; clear LCD screen before choice page
	
	lfsr	FSR0, hit_Array	; Load FSR0 with address in RAM	
	movlw	upper(hit)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(hit)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(hit)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	hit_c		; bytes to read
	movwf 	counter		; our counter register
loop 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	counter		; count down to zero
	bra	loop		; keep going until finished
		
	movlw	hit_c-1	; output message to LCD (leave out "\n")
	lfsr	FSR2, hit_Array
	
	;movlw	b'10000010'	;set the string to the middle of LCD
	;call LCD_Move_to_position 
	call	LCD_Write_Message
	
	call	LCD_row_shift
	
	; YES NO NEXT PAGE -------------
	lfsr	FSR0, hit_Array	; Load FSR0 with address in RAM	
	movlw	upper(choice1)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(choice1)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(choice1)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	choice1_c		; bytes to read
	movwf 	counter		; our counter register
loop2 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	counter		; count down to zero
	bra	loop2		; keep going until finished
		
	movlw	choice1_c-1	; output message to LCD (leave out "\n")
	lfsr	FSR2, hit_Array
	call	LCD_Write_Message

	
	
	; SECOND CHOICE PAGE DOUBLE DOWN -------
	
	lfsr	FSR0, hit_Array	; Load FSR0 with address in RAM	
	movlw	upper(choice2)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(choice2)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(choice2)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	choice2_c		; bytes to read
	movwf 	counter		; our counter register
loop3 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	counter		; count down to zero
	bra	loop2		; keep going until finished
		
	movlw	choice2_c-1	; output message to LCD (leave out "\n")
	lfsr	FSR2, hit_Array
	call	LCD_Write_Message
	
	
	; SECOND CHOICE PAGE SURRENDER -------
	
	lfsr	FSR0, hit_Array	; Load FSR0 with address in RAM	
	movlw	upper(choice3)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(choice3)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(choice3)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	choice3_c		; bytes to read
	movwf 	counter		; our counter register
loop4 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	counter		; count down to zero
	bra	loop2		; keep going until finished
		
	movlw	choice3_c-1	; output message to LCD (leave out "\n")
	lfsr	FSR2, hit_Array
	call	LCD_Write_Message


	return
	
Choice_hit_or_stand

	call	Keypad_Input	; let the key loop going and set W register to corresponding number
	call	Cursormove	
	
	movlb   5
	cpfseq  0x500, BANKED	;check whether is button A being pressed, if not detect again
	;goto	ini_carddealer
	goto    Title_press_to_start
	
	call	LCD_clear_display
	movlw   .255
	call    LCD_delay_ms
	
	
	;goto	bet_page
	
	return


end