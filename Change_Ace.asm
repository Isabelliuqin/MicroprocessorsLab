#include p18f87k22.inc
 
	global	    Change_Ace_dealer,Change_Ace_player
	
change_ace_data	udata_acs   ; reserve data space in access ram
change_Ace_counter		res 1

Change_Ace	    code ;i.e. change 11 to 1 when sum>21
	    
Change_Ace_dealer
	movlw	0x0A
	movwf	change_Ace_counter
	
	movlw	0x15		;compare sum_dealer with 21
	movlb	4
	cpfsgt	0x430, BANKED
	return			;if sum_dealer < 21, return
	
	lfsr	FSR0,0x410	;if sum_dealer > 21, change 0x0B into 0x01
	movlw	0x0B
change_Ace_loop	
	dcfsnz	change_Ace_counter  ;check 10 registors
	return
	
	cpfseq	POSTINC0
	goto	change_Ace_loop
	
	movlw	0x00
	addwf	POSTDEC0	;trivial, same as predec0	 
	movlw	0x01
	movwf	INDF0
	return
	
	
	
Change_Ace_player
	movlw	0x0A
	movwf	change_Ace_counter
	
	movlw	0x15		;compare sum_player with 21
	movlb	4
	cpfsgt	0x420, BANKED
	return			;if sum_player < 21, return
	
	lfsr	FSR0,0x400	;if sum_player > 21, change 0x0B into 0x01
	movlw	0x0B
change_Ace_loop_	
	dcfsnz	change_Ace_counter  ;check 10 registors
	return
	
	cpfseq	POSTINC0
	goto	change_Ace_loop_
	
	movlw	0x00
	addwf	POSTDEC0	;trivial, same as predec0	 
	movlw	0x01
	movwf	INDF0
	return	
	end
	
	
	
