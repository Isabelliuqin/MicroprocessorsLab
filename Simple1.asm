	#include p18f87k22.inc

	extern	UART_Setup, UART_Transmit_Message   ; external UART subroutines
	extern  LCD_Setup, LCD_Write_Message	    ; external LCD subroutines
	extern	LCD_Write_Hex, LCD_row_shift,LCD_clear,LCD_delay_x4us,LCD_delay_ms,LCD_row_return,LCD_sq; external LCD subroutines
	extern  ADC_Setup, ADC_Read		    ; external ADC routines
	extern	multip
	extern	counter_setup, table_setup, counter_pickvalue
	
acs0	udata_acs	
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
	
	call	table_setup
	goto	ini
	
	; ******* Main programme ****************************************
ini 		
    movlw   .255
    call    LCD_delay_ms
    movlw   .100
    call    LCD_delay_x4us
    
    call    counter_pickvalue
    movwf   card_set2		;dealer's card 1
    
    
    call    LCD_delay_ms
    ;call    counter_pickvalue
    ;movwf   card_set2
    call    LCD_sq		;hide dealer's card 2
    call    LCD_delay_ms

    
    goto    $

    end