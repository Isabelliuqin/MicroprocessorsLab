#include p18f87k22.inc
    
    extern  LCD_delay_x4us, LCD_delay_ms, LCD_rightcorner, LCD_leftshift4,LCD_sq,LCD_rightshift
    extern  Keypad_Input
    extern  counter_pickvalue
    extern  Command_make_choice
    ;extern  result
    global  addition_player, addition_dealer,ini_cardplayer, ini_carddealer, carddraw_player, drawcard_dealer_after_player 
   
    
cardset1	udata	0x400	
card_set1	res 10  ;player's cards
	
cardset2	udata	0x410
card_set2	res 10  ;dealer's cards
	
player_sum_	udata	0x420
player_sum		res 1

dealer_sum_	udata	0x430
dealer_sum		res 1
	
acs0	udata_acs   ; reserve data space in access ram
sum	res 1
card_counter	res 1

	
	
card	code
    
addition_player	;adding all cards randomly picked and stored them into player_sum
    
    movlb   4    
    lfsr    FSR0, card_set1
    movlb   4
    movf    0x400, W, BANKED
    addwf   PREINC0, 0		;sum up the initial player's card values and place it in W
    addwf   PREINC0, 0		;sum up the initial player's card values and place it in W
    addwf   PREINC0, 0		;sum up the initial player's card values and place it in W
    addwf   PREINC0, 0		;sum up the initial player's card values and place it in W
    addwf   PREINC0, 0		;sum up the initial player's card values and place it in W
    addwf   PREINC0, 0		;sum up the initial player's card values and place it in W
    addwf   PREINC0, 0		;sum up the initial player's card values and place it in W
    addwf   PREINC0, 0		;sum up the initial player's card values and place it in W
    addwf   PREINC0, 0		;sum up the initial player's card values and place it in W
    
    movlb   4
    movwf   player_sum, BANKED
    ;call    Result_before_dealerdrawcards
    return
    
addition_dealer			;adding all cards randomly picked by dealer and stored them into dealer_sum  
    movlb   4			   
    lfsr    FSR0, card_set2
    movlb   4
    movf    0x410, W, BANKED
    addwf   PREINC0, 0		;sum up the initial dealer's card values and place it in W
    addwf   PREINC0, 0		;sum up the initial dealer's card values and place it in W
    addwf   PREINC0, 0		;sum up the initial dealer's card values and place it in W
    addwf   PREINC0, 0		;sum up the initial dealer's card values and place it in W
    addwf   PREINC0, 0		;sum up the initial dealer's card values and place it in W
    addwf   PREINC0, 0		;sum up the initial player's card values and place it in W
    addwf   PREINC0, 0		;sum up the initial player's card values and place it in W
    addwf   PREINC0, 0		;sum up the initial player's card values and place it in W
    addwf   PREINC0, 0		;sum up the initial player's card values and place it in W
    
    movlb   4
    movwf   dealer_sum, BANKED
    ;call    Result_after_dealerdrawcards
    return
    


    
    
ini_carddealer
drawcard_dealer_ini			;dealer's first card
    call    Keypad_Input		;detect the key pressing on keypad
    movlb   5
    cpfseq  0x500, BANKED		;check whether is button A being pressed, if not detect again
    goto    drawcard_dealer_ini
    call    counter_pickvalue		;if A is pressed, pick the first value
    movlb   4
    lfsr    FSR2,card_set2
    movwf   POSTINC2			;place dealer's card 1 in cardset2 and move to the next memory location
    
    
    movlw   .255
    call    LCD_delay_ms

hiddencard_dealer			;dealer's hidden card	
    
    call    Keypad_Input
    movlb   5
    cpfseq  0x500, BANKED		;check whether is button A being pressed, if not detect again
    goto    hiddencard_dealer
    

    call    LCD_sq			;hide dealer's card 2

    movlw   .255
    call    LCD_delay_ms
    
    return

drawcard_dealer_after_player		;reveal the hidden card,3rd, 4th... card, called by command make choice
    call    Keypad_Input		;detect the key pressing on keypad
    movlb   5
    cpfseq  0x500, BANKED		;check whether is button A being pressed, if not detect again
    goto    drawcard_dealer_after_player
    
    movlw   .10
    movwf   card_counter
    lfsr    FSR1, 0x410
    lfsr    FSR2, 0x410
loop_write_dealer
    dcfsnz  card_counter		; count down to zero
    return
    
    movlw   0x00
    cpfseq  POSTINC1
    goto    loop_write_dealer
    
    call    counter_pickvalue		;if A is pressed, pick the first value
    movwf   POSTINC2
    return
    
    call    LCD_rightshift
    
    movlw   .255
    call    LCD_delay_ms
    
    call    addition_dealer		;everytime after drawing a card, ask addition fn to place the sum into dealer_sum

    return

ini_cardplayer
    call    Keypad_Input
    movlb   5
    cpfseq  0x500, BANKED		;check whether is button A being pressed, if not detect again
    goto    ini_cardplayer
    
    call    LCD_rightcorner		;start play's card at the down-right corner of the LCD screen   
    call    counter_pickvalue		;pick and display the player's card 1 
    movlb   4
    lfsr    FSR1,card_set1	
    movwf   POSTINC1			;place player's card 1 in cardset1 and move to the next memory location
    call    LCD_leftshift4
    movlw   .255
    call    LCD_delay_ms
    
carddraw_player
    call    Keypad_Input
    movlb   5
    cpfseq  0x500, BANKED		;check whether is button A being pressed, if not detect again
    goto    carddraw_player
    
    lfsr    FSR1, 0x400
    lfsr    FSR2, 0x400
loop_write_player
    dcfsnz  card_counter		; count down to zero
    return
    
    movlw   0x00
    cpfseq  POSTINC1
    goto    loop_write_player
    
    call    counter_pickvalue		
    movwf   POSTINC2
    return
					
    call    LCD_leftshift4
    movlw   .255
    call    LCD_delay_ms
    
    call    addition_player		 ;everytime after drawing a card, ask addition fn to place the sum into player_sum
    
    ;goto    $
    return
    

    
    end