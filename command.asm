#include p18f87k22.inc
    
    global	Command_setup, Command_make_choice,command_start	
    extern	Cursor_move
    extern	LCD_Write_Message, LCD_row_shift,LCD_clear_display,LCD_delay_ms,LCD_delay_x4us
    extern	Keypad_Input
    extern	Title_press_to_start
acs0	udata_acs   ; reserve data space in access ram
counter	    res 1   ; reserve one byte for a counter variable
delay_count res 1   ; reserve one byte for counter in the delay routine


hit_data    udata   0x350    ; reserve data anywhere in RAM 
hit_Array	res 0x50    ; reserve 108 bytes for message data


pdata	code    ; a section of programme memory for storing data

	; ******* myTable, data in programme memory, and its length *****
hit	data	    "Hit?\n"	; message, plus carriage return
	constant    hit_c=.5	; length of data
choice1	data	    "Yes No ...\n"	; message, plus carriage return
	constant    choice1_c =.11	; length of data


	; ******* Programme FLASH read Setup Code ***********************
Command_setup	
	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory
	return

	; ******* Main programme ****************************************
	
	; HIT------ -------
command_start 	
	call	LCD_clear_display	; clear LCD screen before choice page
	
	lfsr	FSR0, hit_Array	; Load FSR0 with address in RAM	
	movlw	upper(hit)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(hit)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(hit)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	hit_c		; bytes to read
	movwf 	counter		; our counter register
loop1 	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	counter		; count down to zero
	bra	loop1		; keep going until finished
		

	movlw	hit_c-1	; output message to LCD (leave out "\n")
	lfsr	FSR2, hit_Array
	;movlw	b'10000010'	;set the string to the middle of LCD
	;call LCD_Move_to_position 
	call	LCD_Write_Message
	
	;movlw	.255		; wait 255ms
	;call	LCD_delay_ms
	
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
	movlw	.255		; wait 255ms
	call	LCD_delay_ms	
	
	
	
	
	return
	
Command_make_choice

	
	call	Cursor_move	
	
	
	
	return


	end