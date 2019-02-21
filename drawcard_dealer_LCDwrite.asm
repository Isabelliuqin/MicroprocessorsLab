#include p18f87k22.inc
 
	global	    Drawcard_dealer_LCDwrite
	extern	    LCD_Send_Byte_I
lalala	    code
Drawcard_dealer_LCDwrite
loop2nd 
    movlw   0x00
    movlb   4
    lfsr    FSR0, 0x411
    cpfseq  POSTINC0
    goto    loop3rd
    movlw   b'10000010'			;after recovery, the cursor is at the player's side, move it to the dealer's side
    call    LCD_Send_Byte_I
    return
loop3rd
    movlw   0x00
    movlb   4
    cpfseq  POSTINC0
    goto    loop4th
    movlw   b'10000100'			;after recovery, the cursor is at the player's side, move it to the dealer's side
    call    LCD_Send_Byte_I
    return
loop4th
    movlw   0x00
    movlb   4
    cpfseq  POSTINC0
    goto    loop5th
    movlw   b'10000110'			;after recovery, the cursor is at the player's side, move it to the dealer's side
    call    LCD_Send_Byte_I
    return
    
loop5th
    movlw   0x00
    movlb   4
    cpfseq  POSTINC0
    goto    loop6th
    movlw   b'10001000'			;after recovery, the cursor is at the player's side, move it to the dealer's side
    call    LCD_Send_Byte_I
    return
loop6th
   

    movlw   b'10001010'			;after recovery, the cursor is at the player's side, move it to the dealer's side
    call    LCD_Send_Byte_I
    return
    
    end