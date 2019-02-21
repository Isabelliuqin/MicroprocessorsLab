#include p18f87k22.inc
    global  clear_memory400_420,clear_memory450_460,clear_sum
    
clearm	code	
clear_memory400_420
	movlw	0x00
	movlb	4
	lfsr    FSR0,0x400
	movwf	POSTINC0
	movwf	POSTINC0
	movwf	POSTINC0
	movwf	POSTINC0
	movwf	POSTINC0
	movwf	POSTINC0
	movwf	POSTINC0
	movwf	POSTINC0
	movwf	POSTINC0
	movwf	POSTINC0
	
	lfsr    FSR0,0x410
	movwf	POSTINC0
	movwf	POSTINC0
	movwf	POSTINC0
	movwf	POSTINC0
	movwf	POSTINC0
	movwf	POSTINC0
	movwf	POSTINC0
	movwf	POSTINC0
	movwf	POSTINC0
	movwf	POSTINC0
	return
	
clear_memory450_460
	lfsr    FSR0,0x450
	movwf	POSTINC0
	movwf	POSTINC0
	movwf	POSTINC0
	movwf	POSTINC0
	movwf	POSTINC0
	movwf	POSTINC0
	movwf	POSTINC0
	movwf	POSTINC0
	movwf	POSTINC0
	movwf	POSTINC0
	return
	
clear_sum

	movlw	0x00
	movwf	0x420, BANKED
	
	movlw	0x00
	movwf	0x430, BANKED
	return
	end

