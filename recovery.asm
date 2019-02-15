#include p18f87k22.inc

    
extern	LCD_rightcorner, LCD_Send_Byte_D, LCD_leftshift4, LCD_rightshift,LCD_clear_display
    
recovery_data	udata_acs   ; reserve data space in access ram
nocard		res 1
Recovery_counter    res 1
    
Recovery    code
    
Recovery_card
    call    LCD_clear_display
    
    movlw   0x00
    movwf   nocard
    movlw   0xA
    movwf   Recovery_counter
    
Recovery_dealer    
    movlb   4
    lfsr    FSR0, 0x410
    
Recovery_loop_dealer    
    movf    POSTINC0, W
    cpfseq  nocard
    call    Recovery_dealer_card_to_LCD
    
    decfsz  Recovery_counter		; count down to zero
    bra	    Recovery_loop_dealer 		; keep going until finished

Recovery_player
    movlb   4
    lfsr    FSR2, 0x400
    call    LCD_rightcorner
    
Recovery_loop_player
    movf    POSTINC2, W
    cpfseq  nocard
    call    Recovery_player_card_to_LCD	;send the ascii code of one of value from {2-9} to LCD

    decfsz  Recovery_counter		; count down to zero
    bra	    Recovery_loop_dealer 		; keep going until finished
    return 

    
Recovery_dealer_card_to_LCD
    call    LCD_Send_Byte_D	;send the ascii code of one of value from {2-9} to LCD
    call    LCD_rightshift
    return

Recovery_player_card_to_LCD
    call    LCD_Send_Byte_D	;send the ascii code of one of value from {2-9} to LCD
    call    LCD_leftshift4
    return
    
    end


