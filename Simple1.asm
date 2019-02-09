	#include p18f87k22.inc

	extern	UART_Setup, UART_Transmit_Message   ; external UART subroutines
	extern  LCD_Setup, LCD_Write_Message	    ; external LCD subroutines
	extern	LCD_Write_Hex, LCD_row_shift,LCD_clear,LCD_delay_x4us,LCD_delay_ms,LCD_row_return,LCD_sq,LCD_rightcorner,LCD_cursoroff; external LCD subroutines
	extern  ADC_Setup, ADC_Read		    ; external ADC routines
	extern	multip
	extern	counter_setup, table_setup, counter_pickvalue
	
cardset		udata	0x400	
card_set1	res 10  ;player's cards
card_set2	res 10  ;dealer's cards
	
rst	code	0    ; reset vector
	goto	setup


main	code
	; ******* Programme FLASH read Setup Code ***********************
setup	bcf	EECON1, CFGS	; point to Flash program memory  
	bsf	EECON1, EEPGD 	; access Flash program memory
	call	counter_setup
	call	UART_Setup	; setup UART
	call	LCD_Setup	; setup LCD
	call	ADC_Setup	; setup ADC
	call	LCD_cursoroff	; turn the cursor of LCD display off
	call	table_setup
	clrf	TRISE
	goto	ini_carddealer
	
	
	; ******* Main programme ****************************************
ini_carddealer	
    movlw   .255
    call    LCD_delay_ms
    movlw   .100
    call    LCD_delay_x4us
    
    call    counter_pickvalue
    lfsr    FSR2,card_set2	
    movwf   POSTINC2		;place player's card 1 in cardset1 and move to the next memory location
    
    
    call    LCD_delay_ms
    ;call    counter_pickvalue
    ;movwf   card_set2
    call    LCD_sq		;hide dealer's card 2
    call    LCD_delay_ms

    
    goto    $
    
    
ini_cardplayer
    
    movlw   .255
    call    LCD_delay_ms
    movlw   .100
    call    LCD_delay_x4us
    
    call    LCD_rightcorner	;start play's card at the down-right corner of the LCD screen
    
    call    counter_pickvalue	;pick and display the player's card 1
    call    LCD_leftshift2	
    lfsr    FSR0,card_set1	
    movwf   POSTINC0		;place player's card 1 in cardset1 and move to the next memory location
    call    LCD_delay_ms
    
    call    counter_pickvalue	;pick and display the player's card 2
    call    LCD_leftshift2	
    movwf   POSTINC0		;place player's card 2 in cardset1 and move to the next memory location
    call    LCD_delay_ms
    
    call    addition_player	;sum up initial player's card values 
    

addition_player
    
    lfsr    FSR0, card_set1
    movf    0x400, W, BANKED
    addwf   POSTINC0, 0		;sum up the initial player's card values and place it in W
    
    addwf   POSTINC0, 0		;sum up the initial player's card values and place it in W
    addwf   POSTINC0, 0		;sum up the initial player's card values and place it in W
    addwf   POSTINC0, 0		;sum up the initial player's card values and place it in W
    addwf   POSTINC0, 0		;sum up the initial player's card values and place it in W
    addwf   POSTINC0, 0		;sum up the initial player's card values and place it in W
    addwf   POSTINC0, 0		;sum up the initial player's card values and place it in W
    addwf   POSTINC0, 0		;sum up the initial player's card values and place it in W
    addwf   POSTINC0, 0		;sum up the initial player's card values and place it in W
    movwf   PORTE
    return
    
addition_dealer
    
    lfsr    FSR0, card_set2
    movf    0x410, W, BANKED
    addwf   POSTINC0, 0		;sum up the initial dealer's card values and place it in W
    
    addwf   POSTINC0, 0		;sum up the initial dealer's card values and place it in W
    addwf   POSTINC0, 0		;sum up the initial dealer's card values and place it in W
    addwf   POSTINC0, 0		;sum up the initial dealer's card values and place it in W
    addwf   POSTINC0, 0		;sum up the initial dealer's card values and place it in W
    addwf   POSTINC0, 0		;sum up the initial player's card values and place it in W
    addwf   POSTINC0, 0		;sum up the initial player's card values and place it in W
    addwf   POSTINC0, 0		;sum up the initial player's card values and place it in W
    addwf   POSTINC0, 0		;sum up the initial player's card values and place it in W
    movwf   PORTE
    return
    
    
    end