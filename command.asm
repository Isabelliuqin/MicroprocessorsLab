#include p18f87k22.inc
    
    global	Command_setup, Command_make_choice,command_start,Command_recoverycomplete, loop_YES	
    extern	Cursor_move
    extern	LCD_Write_Message, LCD_row_shift,LCD_clear_display,LCD_delay_ms,LCD_delay_x4us,LCD_Send_Byte_I,LCD_sq
    extern	Keypad_Input
    extern	Title_press_to_start
    extern	carddraw_player,drawcard_dealer_after_player
    extern	Recovery_card
    extern	Simple_player_yes,Simple_player_no
acs0	udata_acs   ; reserve data space in access ram
counter	    res 1   ; reserve one byte for a counter variable
delay_count res 1   ; reserve one byte for counter in the delay routine
YES	    res 1
NO	    res 1

hit_data    udata   0x350    ; reserve data anywhere in RAM 
hit_Array	res 0x50    ; reserve 108 bytes for message data


pdata	code    ; a section of programme memory for storing data

	; ******* myTable, data in programme memory, and its length *****
hit	data	    "Hit?\n"		; message, plus carriage return
	constant    hit_c=.5		; length of data
choice1	data	    "Yes No ...\n"	; message, plus carriage return
	constant    choice1_c =.11	; length of data


	; ******* Programme FLASH read Setup Code ***********************
Command_setup	
	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory
	movlw	0xA1
	movwf	YES
	movlw	0xA2
	movwf	NO
	return

	; ******* Main programme ****************************************
	
	; HIT------ -------
command_start				;setting up the HIT choice page on LCD screen	
	call	LCD_clear_display	; clear LCD screen before choice page
	
	lfsr	FSR0, hit_Array		; Load FSR0 with address in RAM	
	movlw	upper(hit)		; address of data in PM
	movwf	TBLPTRU			; load upper bits to TBLPTRU
	movlw	high(hit)		; address of data in PM
	movwf	TBLPTRH			; load high byte to TBLPTRH
	movlw	low(hit)		; address of data in PM
	movwf	TBLPTRL			; load low byte to TBLPTRL
	movlw	hit_c			; bytes to read
	movwf 	counter			; our counter register
loop1 	tblrd*+				; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0	; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	counter			; count down to zero
	bra	loop1			; keep going until finished
		

	movlw	hit_c-1			; output message to LCD (leave out "\n")
	movlb	3
	lfsr	FSR2, hit_Array
	;movlw	b'10000010'	;set the string to the middle of LCD
	;call LCD_Move_to_position 
	call	LCD_Write_Message
	
	;movlw	.255			 ; wait 255ms
	;call	LCD_delay_ms
	
	call	LCD_row_shift

	; YES NO NEXT PAGE -------------
	lfsr	FSR0, hit_Array		 ; Load FSR0 with address in RAM	
	movlw	upper(choice1)		 ; address of data in PM
	movwf	TBLPTRU			 ; load upper bits to TBLPTRU
	movlw	high(choice1)		 ; address of data in PM
	movwf	TBLPTRH			 ;load high byte to TBLPTRH
	movlw	low(choice1)		; address of data in PM
	movwf	TBLPTRL			; load low byte to TBLPTRL
	movlw	choice1_c		; bytes to read
	movwf 	counter			; our counter register
loop2 	tblrd*+				; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0	; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	counter			; count down to zero
	bra	loop2			; keep going until finished
		
	movlw	choice1_c-1		; output message to LCD (leave out "\n")
	movlb	3
	lfsr	FSR2, hit_Array
	call	LCD_Write_Message
	movlw	.255			; wait 255ms
	call	LCD_delay_ms	
	
	
	return
	
Command_make_choice			; call cursor_move to move cursor and make choice, once choice is made, recover cards and draw a card
	call	Cursor_move
	goto	Recovery_card		;recover the card picked before determine adding cards for dealer or player
loop_YES				; user confrim to hit, draw card for player
	movlb	9
	movf	0x900, W, BANKED
	cpfseq	YES			;check if YES being pressed
	goto	loop_NO
	
	
Command_recoverycomplete
	call	carddraw_player		;draw a card for player   
	goto	Simple_player_yes	;goto simple 1 and check the result of the game
	return	
	
loop_NO					; user confirmed to stand, draw card for dealer
	
	goto	Simple_player_no	;goto simple 1 to check the result of the game		   
	
	
	
	return


	end