#include p18f87k22.inc

	extern	command_start, Command_make_choice
	extern	drawcard_dealer_after_player
	extern	LCD_Write_Message, LCD_delay_ms, LCD_clear_display,LCD_cursoroff
	extern	Simple_player_no
	global	Result_before_dealerdrawcards, Result_after_dealerdrawcards,Result_setup
result_data	udata_acs
twenty_one	res 1
seventeen	res 1
Result_counter	    res 1   ; reserve one byte for a counter variable

result_page	udata	0x800
result_Array	res 0x50

	
result	code
	
Resultwin	
	data	    "Win!\n"	; message, plus carriage return
	constant    win_c=.5	; length of data
Resultlose	
	data	    "Lose\n"	; message, plus carriage return
	constant    lose_c =.5	; length of data
Resultpush	
	data	    "Push\n"	; message, plus carriage return
	constant    push_c =.5	; length of data
	

Result_setup	
	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory
	
;result_value			;!!!!
	movlw	0x15
	movwf	twenty_one
	movlw	0x11
	movwf	seventeen
	return

Result_before_dealerdrawcards			; game result totally depends on player's card
equal_to_21
	movlb	4
	movf	0x420, W, BANKED
	cpfseq	twenty_one
	goto	not_21
	goto	Result_win
						;called by addition_player
	
not_21	
	cpfslt	twenty_one
	goto	smaller_than_21
	goto	Result_lose
	
smaller_than_21
	
	return
	
Result_after_dealerdrawcards
	;called by addition_dealer
equal_to_21_a
	movlb	4
	movf	0x430, W, BANKED
	cpfseq	twenty_one
	goto	not_21_a
	goto	Result_lose
not_21_a
	cpfslt	twenty_one
	goto	smaller_than_21_a
	goto	Result_win
smaller_than_21_a
smaller_than_17_a
	cpfsgt	seventeen
	goto	larger_or_equal_to_17_a
	call	drawcard_dealer_after_player
	goto	Simple_player_no
larger_or_equal_to_17_a
equal_to_player_a
	movlb	4
	cpfseq	0x420, BANKED		;compare with player's card sum, equal goto result push
	goto	not_equal_to_player_a
	goto	Result_push
	
not_equal_to_player_a
	movlb	4
	cpfsgt	0x420, BANKED
	goto	larger_than_player
	goto	Result_win
	
larger_than_player
	goto	Result_lose
	
Result_win
win_start 	
	call	LCD_clear_display	; clear LCD screen before choice page
	call	LCD_cursoroff
	lfsr	FSR0, result_Array	; Load FSR0 with address in RAM	
	movlw	upper(Resultwin)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(Resultwin)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(Resultwin)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	win_c		; bytes to read
	movwf 	Result_counter		; our counter register
win_loop 	
	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	Result_counter		; count down to zero
	bra	win_loop		; keep going until finished
		

	movlw	win_c-1	; output message to LCD (leave out "\n")
	movlb	8
	lfsr	FSR2, result_Array
	call	LCD_Write_Message
	movlw	.255		; wait 255ms
	call	LCD_delay_ms
	
	goto	$
Result_lose
lose_start 	
	call	LCD_clear_display	; clear LCD screen before choice page
	call	LCD_cursoroff
	lfsr	FSR0, result_Array	; Load FSR0 with address in RAM	
	movlw	upper(Resultlose)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(Resultlose)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(Resultlose)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	lose_c		; bytes to read
	movwf 	Result_counter		; our counter register
lose_loop 	
	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	Result_counter		; count down to zero
	bra	lose_loop		; keep going until finished
		
	movlw	lose_c-1	; output message to LCD (leave out "\n")
	movlb	8
	lfsr	FSR2, result_Array
	call	LCD_Write_Message
	movlw	.255		; wait 255ms
	call	LCD_delay_ms
	goto	$
	;goto	restart
Result_push	
push_start 	
	call	LCD_clear_display	; clear LCD screen before choice page
	call	LCD_cursoroff
	lfsr	FSR0, result_Array	; Load FSR0 with address in RAM	
	movlw	upper(Resultpush)	; address of data in PM
	movwf	TBLPTRU		; load upper bits to TBLPTRU
	movlw	high(Resultpush)	; address of data in PM
	movwf	TBLPTRH		; load high byte to TBLPTRH
	movlw	low(Resultpush)	; address of data in PM
	movwf	TBLPTRL		; load low byte to TBLPTRL
	movlw	push_c		; bytes to read
	movwf 	Result_counter		; our counter register
push_loop 	
	tblrd*+			; one byte from PM to TABLAT, increment TBLPRT
	movff	TABLAT, POSTINC0; move data from TABLAT to (FSR0), inc FSR0	
	decfsz	Result_counter		; count down to zero
	bra	push_loop		; keep going until finished
		

	movlw	win_c-1	; output message to LCD (leave out "\n")
	movlb	8
	lfsr	FSR2, result_Array
	call	LCD_Write_Message
	movlw	.255		; wait 255ms
	call	LCD_delay_ms
	goto	$
    end