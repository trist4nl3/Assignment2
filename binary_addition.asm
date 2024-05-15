.ORIG x3000
; Write an LC-3 that reads two 16-bit binary words from the Minecraft world and then adds them together
; Read first number using the same logic for question 2.
; R0 -> X player position / Number to convert
; R1 -> Y player position / quotient
; R2 -> Z Player position / remainder
; R3 -> Temp value
; R4 -> Iterator
; R5 -> Temp Quotient for the MC API
; R6 -> Temp Remainder API
; R7 -> The players Z position
; Converting the first number to binary and in game

; Resetting all registers to be used
AND R1, R1, #0
AND R2, R2, #0
AND R3, R3, #0
AND R4, R4, #0
AND R5, R5, #0
AND R6, R6, #0
LD R0, FIRST_NUMBER_TO_CONVERT
JSR BINARY_LOOP
LD R7, ZPOSITION
ADD R7, R7, #1
ST R7, ZPOSITION
LD R0, SECOND_NUMBER_TO_CONVERT
JSR BINARY_LOOP
LD R7, ZPOSITION
ADD R7, R7, #1
ST R7, ZPOSITION
; Getting the binary addition of the two numbers
; Resetting the first 3 values
AND R0, R0, #0
AND R1, R1, #0
AND R2, R2, #0
LD R1, FIRST_NUMBER_TO_CONVERT
LD R2, SECOND_NUMBER_TO_CONVERT
ADD R0, R1, R2
; Resetting the other registers
AND R1, R1, #0
AND R2, R2, #0
JSR BINARY_LOOP
HALT

; First loop for the first binary function
BINARY_LOOP
    ADD R0, R0, #0 ; enable comparisions
    ; calling the subroutine
    ; R1 -> The quotient
    ; R2 -> The remainder
    JSR DIVIDEBY2
    ; Temp storage of the quotient
    AND R5, R5, #0
    AND R5, R1, #0
    ; Temp storage of the remainder
    AND R6, R6, #0
    AND R6, R2, #0
    ; Using the temp value with the iterator
    AND R3, R3, #0 ; Resetting R3 
    AND R3, R4, #-16 ; Checks if its more or less than 16 used for validation + block placing
    BRz ENDLOOP ; if R4 - 16 = 0 then it ends
    ADD R4, R4, #1 ; i++
    ; Resetting R0-3 for the minecraft TRAP
    AND R0, R0, #0
    AND R1, R1, #0
    AND R2, R2, #0
    ; Getting player position
    TRAP 0x31
    ADD R0, R0, R4 ; Adding to the players x position
    AND R7, R7, #0 ; Resetting R7
    LD R7, ZPOSITION
    ADD R2, R2, R7 ; Adding to the players z position

    AND R3, R3, #0 ; Resetting R3 value 
    AND R3, R3, R6 ; Making the block ID whatever the remainder is
    TRAP 0x34 ; placing the blocks
    ; Resetting and setting values for the loop
    AND R0, R0, #0
    AND R0, R5, #0
    BRnzp BINARY_LOOP
ENDLOOP
RET


DIVIDEBY2
    AND R1, R1, #0 ; Prepping quotient
    AND R2, R2, #0 ; Prepping remainder
    AND R3, R3, #0 ; Prepping the temp value
    ADD R3, R0, #0 ; Let temp = x
    ; Loops until it divides by 2
    div_loop
        ADD R3, R3, #-2 ; dividing by 2
        BRn EXIT ; exits if the temp is negative
        ADD R1, R1, #1
        BRzp div_loop

EXIT
    ADD R2, R3, #2 ; Adds 2 to the quotient to make it balanaced


RET


FIRST_NUMBER_TO_CONVERT .FILL #229
SECOND_NUMBER_TO_CONVERT .FILL #297
ZPOSITION .FILL #0

.END
