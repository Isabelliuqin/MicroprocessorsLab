#include p18f87k22.inc
    

	
	extern	LCD_leftshift, LCD_rightshift, LCD_row_shift, LCD_row_return,LCD_delay_ms, LCD_clear_display
	extern	carddraw_player, drawcard_dealer_after_player
	extern	Keypad_Input
	global	Cursor_move
cursor	code
	

	

Cursor_confirm
		
	
Cursor_move
	call	LCD_row_shift	    ; shift cursor at Y
	
	

Check_leftshift			    ; choose YES, put 0xA1 in W
	call	Keypad_Input	    ; let the key loop going and set W register to corresponding number	
	movlb	5
	cpfseq	0x504,BANKED	    ; check whether 4 is pressed, if no, check other number
	goto    Check_rightshift
	
	call	LCD_leftshift	    ;Yes, shift the cursor to Y
	call	LCD_leftshift
	call	LCD_leftshift
	call	LCD_leftshift
	
	call	Check_nonpressed_after_pressing	    ;check whether the user release key 4
	call	Check_confirm			    ;check whether confirmed key A is pressed
	movlw	0xA1		
	

	;goto	carddraw_player
	
	return
	

Check_rightshift			; choose No, put 0xA2 in W
	
	movlb   5
	cpfseq  0x506, BANKED		;check whether is key 6 is pressed, if not detect again
	goto    Check_nonpressed
	
	call	LCD_rightshift		;shift the cursor to N
	call	LCD_rightshift
	call	LCD_rightshift
	call	LCD_rightshift

	call	Check_nonpressed_after_pressing	    ;check whether the user release key 4
	call	Check_confirm			    ;check whether confirmed key A is pressed
	movlw	0xA2
	
	
	return

Check_nonpressed
	
	movlb   5
	cpfseq  0x500, BANKED			    ;check whether is button A being pressed, if not detect again
	goto    Check_leftshift
	call	LCD_clear_display
	movlw	0xA1				    ;choose YES
	
	
	
	return
	
	
Check_nonpressed_after_pressing			;check whether the key pressed is released
	call    Keypad_Input			; reload W with key
	movlw	0x00		    
	movlb	7
	cpfseq	0x700, BANKED			;0x700 = 0x00 when the key is not pressed anymore, if equal, key not pressed, check whether the user confirm the choice
	goto	Check_nonpressed_after_pressing	;not equal, detect again
	goto	Check_confirm
	return
	
Check_confirm	
	call    Keypad_Input			;detect confirmation by pressing A
	movlb   5	
	cpfseq  0x500, BANKED			;check whether is button A being pressed, if not 
	goto    Check_leftshift			;check whether the cursor is moved again
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
	


