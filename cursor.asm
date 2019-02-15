#include p18f87k22.inc
    

	
	extern	LCD_leftshift, LCD_rightshift, LCD_row_shift, LCD_row_return,LCD_delay_ms, LCD_clear_display
	extern	carddraw_player, drawcard_dealer_after_player
	extern	Keypad_Input
	global	Cursor_move
cursor	code
	

	

Cursor_confirm
		
	
Cursor_move
	call	LCD_row_shift
		

Check_leftshift
	call	Keypad_Input	    ; let the key loop going and set W register to corresponding number
	movlb	5
	cpfseq	0x504,BANKED
	goto    Check_rightshift
	
	call	LCD_leftshift
	call	LCD_leftshift
	
	movlw   .255
	call    LCD_delay_ms
	
	call    Keypad_Input	;detect the key pressing on keypad
	movlb   5
	cpfseq  0x500, BANKED	;check whether is button A being pressed, if not detect again
	goto    Check_leftshift
	
	
	goto	carddraw_player
	
	

	return
	

Check_rightshift		;check whether 6 is preesed-shift to right
	
	movlb   5
	cpfseq  0x506, BANKED	;check whether is button A being pressed, if not detect again
	goto    Check_nonpressed
	
	call	LCD_rightshift
	call	LCD_rightshift
	call	LCD_rightshift
	call	LCD_rightshift
	
	call    Keypad_Input		;detect the key pressing on keypad
	movlb   5
	cpfseq  0x500, BANKED	;check whether is button A being pressed, if not detect again
	goto    Check_leftshift
	call	LCD_clear_display
	goto	drawcard_dealer_after_player	
	
	movlw   .255
	call    LCD_delay_ms
	
	return

Check_nonpressed
	
	movlw	0x00
	movlb	7
	cpfseq	0x700, BANKED
	goto	Check_leftshift
	
	call    Keypad_Input		;detect the key pressing on keypad
	movlb   5
	cpfseq  0x500, BANKED	;check whether is button A being pressed, if not detect again
	goto    Check_leftshift
	goto	carddraw_player
	
	movlw   .255
	call    LCD_delay_ms
	
	return
	
	
Check_topshift		;check whether 6 is preesed-shift to right
	movlb   5
	cpfseq  0x502, BANKED	;check whether is button A being pressed, if not detect again
	goto    Check_downshift
	
	call	LCD_row_return
	return
	
Check_downshift		;check whether 6 is preesed-shift to right
	movlb   5
	cpfseq  0x508, BANKED	;check whether is button A being pressed, if not detect again
	goto	Check_leftshift  
	
	call	LCD_row_shift
	return
	
	end
	


