#include p18f87k22.inc
    
    extern  LCD_delay_x4us, LCD_delay_ms, LCD_rightcorner, LCD_leftshift4,LCD_sq
    extern  Keypad_Input
    extern  counter_pickvalue
    extern  Choice_hit_or_stand
    extern  result
    global  addition_player, addition_dealer,ini_cardplayer, ini_carddealer
   
    
cardset1	udata	0x400	
card_set1	res 10  ;player's cards
	
cardset2	udata	0x410
card_set2	res 10  ;dealer's cards
	
acs0	udata_acs   ; reserve data space in access ram
sum	res 1

	
card	code
    
addition_player
    
    lfsr    FSR1, card_set1
    movlb   4
    movf    0x400, W, BANKED
    addwf   PREINC1, 0		;sum up the initial player's card values and place it in W
    addwf   PREINC1, 0		;sum up the initial player's card values and place it in W
    addwf   PREINC1, 0		;sum up the initial player's card values and place it in W
    addwf   PREINC1, 0		;sum up the initial player's card values and place it in W
    addwf   PREINC1, 0		;sum up the initial player's card values and place it in W
    addwf   PREINC1, 0		;sum up the initial player's card values and place it in W
    addwf   PREINC1, 0		;sum up the initial player's card values and place it in W
    addwf   PREINC1, 0		;sum up the initial player's card values and place it in W
    addwf   PREINC1, 0		;sum up the initial player's card values and place it in W
    
    return
    
addition_dealer
    
    lfsr    FSR1, card_set2
    movf    0x410, W, BANKED
    addwf   PREINC1, 0		;sum up the initial dealer's card values and place it in W
    addwf   PREINC1, 0		;sum up the initial dealer's card values and place it in W
    addwf   PREINC1, 0		;sum up the initial dealer's card values and place it in W
    addwf   PREINC1, 0		;sum up the initial dealer's card values and place it in W
    addwf   PREINC1, 0		;sum up the initial dealer's card values and place it in W
    addwf   PREINC1, 0		;sum up the initial player's card values and place it in W
    addwf   PREINC1, 0		;sum up the initial player's card values and place it in W
    addwf   PREINC1, 0		;sum up the initial player's card values and place it in W
    addwf   PREINC1, 0		;sum up the initial player's card values and place it in W
    
    call    result
    return
    


    
    
ini_carddealer
drawcard_dealer
    call    Keypad_Input		;detect the key pressing on keypad
    movlb   5
    cpfseq  0x500, BANKED	;check whether is button A being pressed, if not detect again
    goto    drawcard_dealer
    call    counter_pickvalue	;if A is pressed, pick the first value
    lfsr    FSR2,card_set2
    movwf   POSTINC2		;place player's card 1 in cardset1 and move to the next memory location 
    
    movlw   .255
    call    LCD_delay_ms

hiddencard_dealer
    
    call    Keypad_Input
    movlb   5
    cpfseq  0x500, BANKED	;check whether is button A being pressed, if not detect again
    goto    hiddencard_dealer
    
    ;call    counter_pickvalue
    ;movwf   POSTINC2
    call    LCD_sq		;hide dealer's card 2
    ;call    LCD_delay_ms
    ;call    addition_dealer
    movlw   .255
    call    LCD_delay_ms
    
    return
    
    
    
ini_cardplayer
    call    Keypad_Input
    movlb   5
    cpfseq  0x500, BANKED	;check whether is button A being pressed, if not detect again
    goto    ini_cardplayer
    
    call    LCD_rightcorner	;start play's card at the down-right corner of the LCD screen   
    call    counter_pickvalue	;pick and display the player's card 1    	
    lfsr    FSR0,card_set1	
    movwf   POSTINC0		;place player's card 1 in cardset1 and move to the next memory location
    call    LCD_leftshift4
    movlw   .255
    call    LCD_delay_ms
    
carddraw_player
    call    Keypad_Input
    movlb   5
    cpfseq  0x500, BANKED	;check whether is button A being pressed, if not detect again
    goto    carddraw_player
    
    call    counter_pickvalue	;pick and display the player's card 2
    movwf   POSTINC0		;place player's card 2 in cardset1 and move to the next memory location
    call    LCD_leftshift4
    movlw   .255
    call    LCD_delay_ms
    
    call    addition_player	;sum up initial player's card values 
    
    goto    $
    return
    

    
    end