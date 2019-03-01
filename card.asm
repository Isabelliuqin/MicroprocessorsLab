#include p18f87k22.inc
    
    extern  LCD_delay_x4us, LCD_delay_ms, LCD_rightcorner, LCD_leftshift4,LCD_sq,LCD_rightshift,LCD_Send_Byte_I
    extern  Keypad_Input
    extern  counter_pickvalue
    extern  Command_make_choice
    extern  Drawcard_dealer_LCDwrite
    extern  Change_Ace_dealer, Change_Ace_player
    global  addition_player, addition_dealer,ini_cardplayer, ini_carddealer, carddraw_player, drawcard_dealer_after_player 
   
    
cardset1	udata	0x400	
card_set1	res 10  ;player's cards
	
cardset2	udata	0x410
card_set2	res 10  ;dealer's cards
	
player_sum_	udata	0x420
player_sum		res 1

dealer_sum_	udata	0x430
dealer_sum		res 1
	
Ace_value_check_    udata   0x901
Ace_value_check	    res	1
JQK10_counter_dealer	udata	0x460
J_counter_dealer	res 1
Q_counter_dealer	res 1 
K_counter_dealer	res 1 
ten_counter_dealer	res 1 	

JQK10_counter_player	udata	0x470
J_counter_player	res 1
Q_counter_player	res 1 
K_counter_player	res 1 
ten_counter_player	res 1
	

	
acs0	udata_acs   ; reserve data space in access ram
sum	res 1
card_counter	res 1
additionloop  res 1
addition	
	
card	code
      
    
addition_player				;adding all cards randomly picked and stored them into player_sum
loopnum_ini_player
    movlw   0x02
    movwf   additionloop
    
loop_player    
    movlb   4    
    lfsr    FSR0, card_set1
    movlb   4
    movf    0x400, W, BANKED
    addwf   PREINC0, 0		
    addwf   PREINC0, 0		
    addwf   PREINC0, 0		
    addwf   PREINC0, 0		
    addwf   PREINC0, 0		
    addwf   PREINC0, 0		
    addwf   PREINC0, 0		
    addwf   PREINC0, 0		
    addwf   PREINC0, 0			;sum up the initial player's card values and place it in W
    
    movlb   4
    movwf   player_sum, BANKED
    
    dcfsnz  additionloop
    return
    
    call    Change_Ace_player
    goto    loop_player
    
addition_dealer				;adding all cards randomly picked by dealer and stored them into dealer_sum  
loopnum_ini_dealer
    movlw   0x02
    movwf   additionloop
    
loop_dealer
    movlb   4			   
    lfsr    FSR0, card_set2
    movlb   4
    movf    0x410, W, BANKED
    addwf   PREINC0, 0		
    addwf   PREINC0, 0		
    addwf   PREINC0, 0		
    addwf   PREINC0, 0		
    addwf   PREINC0, 0		
    addwf   PREINC0, 0		
    addwf   PREINC0, 0		
    addwf   PREINC0, 0		
    addwf   PREINC0, 0			;sum up the initial player's card values and place it in W
    
    movlb   4
    movwf   dealer_sum, BANKED
    
    dcfsnz  additionloop
    return
    
    call    Change_Ace_dealer
    goto    loop_dealer
  

ini_carddealer
drawcard_dealer_ini			;dealer's first card
    movlw   0x00			;clear the JQK10 connter for dealer and player for each game, the number of JQK10 are count for recover the card from card value
    movlb   4
    movwf   J_counter_dealer, BANKED
    movlw   0x00
    movwf   Q_counter_dealer, BANKED
    movlw   0x00
    movwf   K_counter_dealer, BANKED
    movlw   0x00
    movwf   ten_counter_dealer, BANKED
    movlw   0x00
    movwf   J_counter_player, BANKED
    movlw   0x00
    movwf   Q_counter_player, BANKED
    movlw   0x00
    movwf   K_counter_player, BANKED
    movlw   0x00
    movwf   ten_counter_player, BANKED
    
    movlw   0xA2    
    movlb   9
    movwf   0x901, BANKED		;if dealer called RNG, 0x901 wrote A1, used to check Aces' value  
    call    counter_pickvalue		;if A is pressed, pick the first value
    movlb   4
    lfsr    FSR2,card_set2
    movwf   POSTINC2			;place dealer's card 1's value in cardset2 and move to the next memory location
    call    JQK10_counter_loop_dealer	;since all JQK10 have card value 0xA, this fn checked whether is JQk or 10 being picked

    
    movlw   .255
    call    LCD_delay_ms

hiddencard_dealer			;dealer's hidden card	
    

    call    LCD_sq			;hide dealer's card 2
    call    LCD_rightcorner		;start play's card at the down-right corner of the LCD screen   
  
    return

drawcard_dealer_after_player		;reveal the hidden card,3rd, 4th... card, called by command make choice
    call    Drawcard_dealer_LCDwrite
    
    movlw   0xA2    
    movlb   9
    movwf   0x901, BANKED		;if dealer called RNG, 0x901 wrote A1, used to check Aces' value 
    call    Keypad_Input		;detect the key pressing on keypad
    movlb   5
    cpfseq  0x500, BANKED		;check whether is button A being pressed, if not detect again
    goto    drawcard_dealer_after_player
    
    movlw   0xA
    movwf   card_counter		;max 10 cards per game
    lfsr    FSR1, 0x410

loop_write_dealer_value
    dcfsnz  card_counter		; count down to zero, return when card_counter = 0
    return
    
    movlw   0x00
    movlb   4
    cpfseq  POSTINC1			;the new value won't be written in any filled card position
    goto    loop_write_dealer_value	;when the memory location is filled, check the next one
    
    MOVLW   0X00
    movlb   4
    movwf   POSTDEC1			;trivial work, ensure the FSR at the right location
    call    counter_pickvalue		;if A is pressed, pick the first value
    movwf   POSTINC1
 

    call    JQK10_counter_loop_dealer	
    
    movlw   .255
    call    LCD_delay_ms
    movlw   .255			; wait 255ms
    call    LCD_delay_ms
    movlw   .255			; wait 255ms
    call    LCD_delay_ms
    movlw   .255			; wait 255ms
    call    LCD_delay_ms
    movlw   .255
    call    LCD_delay_ms
    movlw   .255			; wait 255ms
    call    LCD_delay_ms
    movlw   .255			; wait 255ms
    call    LCD_delay_ms
    movlw   .255			; wait 255ms
    call    LCD_delay_ms
    
    call    addition_dealer		;everytime after drawing a card, ask addition fn to place the sum into dealer_sum

    return

ini_cardplayer
    
    movlw   0xA1    
    movlb   9
    movwf   0x901, BANKED		; if player called RNG, 0x901 wrote A2, used to determine card value for Ace 
    call    Keypad_Input
    movlb   5
    cpfseq  0x500, BANKED		;check whether is button A being pressed, if not detect again
    goto    ini_cardplayer
      
    call    counter_pickvalue		;pick and display the player's card 1 
    movlb   4
    lfsr    FSR1,card_set1	
    movwf   POSTINC1			;place player's card 1 in cardset1 and move to the next memory location
    call    LCD_leftshift4
    call    JQK10_counter_loop_player
    movlw   .255
    call    LCD_delay_ms
    
carddraw_player
    movlw   0xA1    
    movlb   9
    movwf   0x901, BANKED		; if player called RNG, 0x901 wrote A2, used to check Ace's value 
    
    call    Keypad_Input
    movlb   5
    cpfseq  0x500, BANKED		;check whether is button A being pressed, if not detect again
    goto    carddraw_player
    
    movlw   0xA
    movwf   card_counter		; max 10 cards picked
    movlb   4
    lfsr    FSR1, 0x400

loop_write_player			; write card !=0    
    dcfsnz  card_counter		; count down to zero
    return
    
    movlw   0x00
    movlb   4
    cpfseq  POSTINC1			;the new value won't be written in any filled card position
    goto    loop_write_player

    
    MOVLW   0X00
    movlb   4
    movwf   POSTDEC1			;trivial work, ensure the FSR at the right location
    call    counter_pickvalue	
    movwf   POSTINC1			;when A pressed, put the card value into locatiion

    call    JQK10_counter_loop_player
    call    LCD_leftshift4
    movlw   .255
    call    LCD_delay_ms
    movlw   .255
    call    LCD_delay_ms
    movlw   .255			; wait 255ms
    call    LCD_delay_ms
    movlw   .255			; wait 255ms
    call    LCD_delay_ms
    movlw   .255			; wait 255ms
    call    LCD_delay_ms
    movlw   .255
    call    LCD_delay_ms
    movlw   .255			; wait 255ms
    call    LCD_delay_ms
    movlw   .255			; wait 255ms
    call    LCD_delay_ms
    movlw   .255			; wait 255ms
    call    LCD_delay_ms
    
    call    addition_player		 ;everytime after drawing a card, ask addition fn to place the sum into player_sum
    
    return
    
JQK10_counter_loop_dealer		;count the card picked by dealer
     
loop_J
    movlw   0x01
    movlb   4
    cpfseq  0x450, BANKED		;check whether the card J is counted in RNG, 0x450 is the J_counter in RNG, the reason for defining here again is to distinguish the card picked by dealer and player
    goto    loop_Q
    movlw   0x01
    movlb   4
    addwf   J_counter_dealer,BANKED	;J_counter_dealer could be larger than one if more than one J picked per game
    return
loop_Q
    movlw   0x01
    movlb   4
    cpfseq  0x451, BANKED
    goto    loop_K
    movlw   0x01
    movlb   4
    addwf   Q_counter_dealer,BANKED
    return
loop_K
    movlw   0x01
    movlb   4
    cpfseq  0x452, BANKED
    goto    loop_10
    movlw   0x01
    movlb   4
    addwf   K_counter_dealer,BANKED
    return
loop_10    
    movlw   0x01
    movlb   4
    cpfseq  0x453, BANKED
    return
    movlw   0x01
    movlb   4
    addwf   ten_counter_dealer,BANKED
    return
    
JQK10_counter_loop_player
loopJ
    movlw   0x01
    movlb   4
    cpfseq  0x450, BANKED
    goto    loopQ
    movlw   0x01
    movlb   4
    addwf   J_counter_player,BANKED
    return
loopQ
    movlw   0x01
    movlb   4
    cpfseq  0x451, BANKED
    goto    loopK
    movlw   0x01
    movlb   4
    addwf   Q_counter_player,BANKED
    return
loopK
    movlw   0x01
    movlb   4
    cpfseq  0x452, BANKED
    goto    loop10
    movlw   0x01
    movlb   4
    addwf   K_counter_player,BANKED
    return
loop10    
    movlw   0x01
    movlb   4
    cpfseq  0x453, BANKED
    return
    movlw   0x01
    movlb   4
    addwf   ten_counter_player,BANKED
    return
    end