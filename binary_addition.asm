.ORIG x3000
; Reading the first number
JSR READ_BINARY
ST R6, FIRST_NUMBER ; Storing the first number
LD R0, CURRENT_Z ; Increasing Z
ADD R0, R0, #1
ST R0, CURRENT_Z
; Reading the second number
JSR READ_BINARY
ST R6, SECOND_NUMBER ; Storing second number
LD R0, CURRENT_Z ; Increasing Z
ADD R0, R0, #1
ST R0, CURRENT_Z

; Getting the total for the write binary addition
AND R0, R0, #0
LD R0, FIRST_NUMBER
LD R1, SECOND_NUMBER
ADD R0, R0, R1
JSR WRITE_BINARY_ADDITION
;TRAP 0x36
HALT
; R5 -> Be the iterator from 1-16
; R5 -> Be the base that doubles for every iteration
; R6 -> Be the total that is added to calculate the binary
READ_BINARY
    ; Getting Player Position, stored in R0, R1, R2
    TRAP 0x31
    ; Resetting needed regisiters
    AND R6, R6, #0
    ; Setting up iterator
    AND R4, R4, #0
    ADD R4, R4, #1
    LD R5, CURRENT_Z
    ; Adjusting to start reading the binary
    ADD R0, R0, #1
    ADD R2, R2, R5
    ; This should start reading from [player_pos_x + 1, player_pos_y, player_pos_z + current_z]
    ; Resetting R5 so it can be used and setting it up to be doubled
    AND R5, R5, #0
    ADD R5, R5, #1

    read_loop
        AND R3, R3, #0
        ADD R3, R4, #-16
        BRzp EXIT
        TRAP 0x33 ; Stores the block id in R3
        ADD R3, R3, #0 ; enable comparisons
        BRz ISZERO
        ADD R6, R6, R5
        ISZERO
        ADD R5, R5, R5
        ADD R4, R4, #1
        ADD R0, R0, #1
        
        BR read_loop
    EXIT
    RET
            
WRITE_BINARY_ADDITION
    ; Resetting registers
    AND R1, R1, #0
    AND R2, R2, #0
    AND R4, R4, #0
    ; Binary loop for each iteration take the remainder as this is the least bit which we output in minecraft
    LOOP_1 
        ADD R0, R0, #0 ; enable comparisions
        ; calling the subroutine
        ; R1 -> The quotient
        ; R2 -> The remainder
        AND R1, R1, #0 ; prepping quotient
        AND R2, R2, #0 ; prepping remainder
        AND R3, R3, #0 ; prepping temp
        ADD R3, R0, #0 ; setting temp = x
        ; loops until it divides by 2
        div_loop
            ADD R3, R3, #-2 ; dividing by 2
            BRn EXIT_LOOP_2 ; exits if the temp is negative
            ADD R1, R1, #1 ; adding to the quotient
            BRzp div_loop
        EXIT_LOOP_2
        ADD R2, R3, #2 ; fixing up some issues here
        ; Storing temp values for quotient and remainder to work with the traps
        ; Quotient
        AND R5, R5, #0
        ADD R5, R1, #0
        ; Remainder
        AND R6, R6, #0
        ADD R6, R2, #0
        TRAP 0x36
        ; using temp for the iterator
        AND R3, R3, #0
        ADD R3, R4, #-16
        BRz ENDLOOP
        ADD R4, R4, #1
        ; This will reset R0, R1, R2
        AND R0, R0, #0
        AND R1, R1, #0
        AND R2, R2, #0
        ; Getting the players position and storing them in their respective registers
        TRAP 0x31
        ADD R0, R0, R4 ; adding to the players x position 
        LD R3, CURRENT_Z
        ADD R2, R2, R3
        AND R3, R3, #0 ; resetting R3 Value
        ADD R3, R3, R6; Making the block ID whatever the remainder is
        TRAP 0x34 ; Placing the blocks
        ; Resetting and setting values for the loop
        AND R0, R0, #0
        ADD R0, R5, #0 ; setting the current x value to quotient
        BRnzp LOOP_1

    ENDLOOP
    RET

CURRENT_Z .FILL #1
FIRST_NUMBER .FILL #0
SECOND_NUMBER .FILL #0
THIRD_NUMBER .FILL #0
.END
