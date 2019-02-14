#include p18f87k22.inc
    

	
	extern	LCD_leftshift, LCD_rightshift, LCD_row_shift, LCD_row_return
	global	Cursormove
cursor	code
	
Cursormove
	call	LCD_row_shift
Check_leftshift
	
	movlb	5
	cpfseq	0x504,BANKED
	
	goto    Check_rightshift
	
	call	LCD_leftshift
	call	LCD_leftshift
	call	
	return
	

Check_rightshift		;check whether 6 is preesed-shift to right
	movlb   5
	cpfseq  0x506, BANKED	;check whether is button A being pressed, if not detect again
	goto    Check_rightshift
	
	call	LCD_rightshift
	call	LCD_rightshift
	call	LCD_rightshift
	call	LCD_rightshift
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
	goto	cursormove  
	
	call	LCD_row_shift
	return
	
	end
	


