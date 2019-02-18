#include p18f87k22.inc
    

	
	extern	LCD_leftshift, LCD_rightshift, LCD_row_shift, LCD_row_return,LCD_delay_ms, LCD_clear_display
	extern	carddraw_player, drawcard_dealer_after_player
	extern	Keypad_Input
	global	Cursor_move
cursor	code
	

	

Cursor_confirm
		
	
Cursor_move
	call	LCD_row_shift
	
	call	Keypad_Input	    ; let the key loop going and set W register to corresponding number	

Check_leftshift			    ; choose YES
	
	movlb	5
	cpfseq	0x504,BANKED
	goto    Check_rightshift
	
	call	LCD_leftshift
	call	LCD_leftshift
	call	LCD_leftshift
	call	LCD_leftshift
	
	call	Check_nonpressed_after_pressing
	call	Check_confirm
	

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

	call	Check_nonpressed_after_pressing
	call	Check_confirm
	goto	drawcard_dealer_after_player	    ; user confirmed to stand	
	
	movlw   .255
	call    LCD_delay_ms
	
	return

Check_nonpressed
	
	movlw	0x00		    
	movlb	7
	cpfseq	0x700, BANKED		;compare Keypad_Input with 0x00
	goto	Check_leftshift
	
	call    Keypad_Input		;detect the key pressing on keypad
	movlb   5
	cpfseq  0x500, BANKED	;check whether is button A being pressed, if not detect again
	goto    Check_leftshift
	call	LCD_clear_display
	goto	carddraw_player
	
	movlw   .255
	call    LCD_delay_ms
	
	return
	
	
Check_nonpressed_after_pressing		;pressed the key to move cursor, check whether the user stop pressing and ready to press key A to confirm
	call    Keypad_Input
	movlw	0x00		    
	movlb	7
	cpfseq	0x700, BANKED		;equal for non pressed
	goto	Check_nonpressed_after_pressing	
	goto	Check_confirm
	return
	
Check_confirm	
	call    Keypad_Input		;detect confirmation by pressing A
	movlb   5
	cpfseq  0x500, BANKED		;check whether is button A being pressed, if not detect again
	goto    Check_leftshift		;check whether the cursor is moved again
	call	LCD_clear_display
	
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
	


