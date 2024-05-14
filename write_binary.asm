.ORIG x3000

; convert to binary
; R0 -> Number to convert
; R1 -> quotient
; R2 -> remainder
; R3 -> temp value
; R4 -> Iterator
; R5 -> Quotient API
; R6 -> Remainder API
; To convert to binary
; Divide Number by 2
; Write down the remainder (this will be the least significant bit)
; Replace the original number with the quotient
; Repeat until quotient is 0
LD R0, NUMBER_TO_CONVERT
AND R1, R1, #0
AND R2, R2, #0
AND R4, R4, #0

LOOP_1 
    ADD R0, R0, #0 ; enable comparisions
    JSR DIVIDEBY2
    ;TRAP 0x36
    ; Storing temp values for quotient and remainder
    ; Quotient
    AND R5, R5, #0
    ADD R5, R1, #0
    ; Remainder
    AND R6, R6, #0
    ADD R6, R2, #0
    ;TRAP 0x36
    ; using temp for the iterator
    AND R3, R3, #0
    ADD R3, R4, #-16
    BRz ENDLOOP
    ADD R4, R4, #1
    
    ; This will reset R0, R1, R2
    AND R0, R0, #0
    AND R1, R1, #0
    AND R2, R2, #0
    TRAP 0x31
    ADD R0, R0, R4
    AND R3, R3, #0
    ADD R3, R3, R6; Making the block ID whatever the remainder is
    TRAP 0x34
    ;TRAP 0x36
    
    ; Resetting and setting values for the loop
    AND R0, R0, #0
    ADD R0, R5, #0 ; setting the current x value to quotient
    BRnzp LOOP_1

ENDLOOP
;TRAP 0x36
HALT


DIVIDEBY2
    AND R1, R1, #0 ; prepping quotient
    AND R2, R2, #0 ; prepping remainder
    AND R3, R3, #0 ; prepping temp
    ADD R3, R0, #0 ; setting temp = x
    div_loop
        ADD R3, R3, #-2
        BRn EXIT
        ADD R1, R1, #1
        BRzp div_loop

EXIT
    ADD R2, R3, #2
    TRAP 0x36

RET
    



NUMBER_TO_CONVERT .FILL #229 ; Note: Please do not change the name of this constant
.END 