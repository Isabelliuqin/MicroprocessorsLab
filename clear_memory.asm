#include p18f87k22.inc
    global  clear_memory400_420,clear_memory450_460
    
clearm	code	
clear_memory400_420
	movlw	0x00
	lfsr    FSR0,0x400
	movwf	POSTINC0
	movlw	0x00
	movwf	POSTINC0
	movlw	0x00
	movwf	POSTINC0
	movlw	0x00
	movwf	POSTINC0
	movlw	0x00
	movwf	POSTINC0
	movlw	0x00
	movwf	POSTINC0
	movlw	0x00
	movwf	POSTINC0
	movlw	0x00
	movwf	POSTINC0
	movlw	0x00
	movwf	POSTINC0
	movlw	0x00
	movwf	POSTINC0
	
	lfsr    FSR0,0x410
	movlw	0x00
	movwf	POSTINC0
	movlw	0x00
	movwf	POSTINC0
	movlw	0x00
	movwf	POSTINC0
	movlw	0x00
	movwf	POSTINC0
	movlw	0x00
	movwf	POSTINC0
	movlw	0x00
	movwf	POSTINC0
	movlw	0x00
	movwf	POSTINC0
	movlw	0x00
	movwf	POSTINC0
	movlw	0x00
	movwf	POSTINC0
	movlw	0x00
	movwf	POSTINC0
	return
	
clear_memory450_460
	movlw	0x00
	lfsr    FSR0,0x450
	movwf	POSTINC0
	movlw	0x00
	movwf	POSTINC0
	movlw	0x00
	movwf	POSTINC0
	movlw	0x00
	movwf	POSTINC0
	movlw	0x00
	movwf	POSTINC0
	movlw	0x00
	movwf	POSTINC0
	movlw	0x00
	movwf	POSTINC0
	movlw	0x00
	movwf	POSTINC0
	movlw	0x00
	movwf	POSTINC0
	movlw	0x00
	movwf	POSTINC0
	return
	end

