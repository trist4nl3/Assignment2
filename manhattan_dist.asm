.ORIG x3000
TRAP 0x31 ; stores x, y, z into R0, R1, R2
;TRAP 0x36 ; log
; Formula dmanhattan = |(playerPos.x - G_x)|
; loading G values and making them negative

LD R3, G_X
NOT R3, R3
ADD R3, R3, #1

LD R4, G_Y
NOT R4, R4
ADD R4, R4, #1

LD R5, G_Z
NOT R5, R5
ADD R5, R5, #1

; getting the absolute of X - G_X
ADD R0, R0, R3
BRzp ABSOLUTEX
NOT R0, R0
ADD R0, R0, #1
ABSOLUTEX ADD R0, R0, #0
;TRAP 0x36
; getting the absoluet of Y - G_Y

ADD R1, R1, R4
BRzp ABSOLUTEY
NOT R1, R1
ADD R1, R1, #1
ABSOLUTEY ADD R1, R1, #0
;TRAP 0x36

; getting the absolute of Z - G_Z
ADD R2, R2, R5
BRzp ABSOLUTEZ
NOT R2, R2
ADD R2, R2, #1
;TRAP 0x36;
ABSOLUTEZ ADD R2, R2, #0

; calculating the value
AND R6, R6, #0; resetting r6 as the actual value
ADD R6, R6, R0
ADD R6, R6, R1
ADD R6, R6, R2
TRAP 0x36

; comparing playing position and distance by doing distance - goal
LD R7, GOAL_DIST
NOT R7, R7
ADD R7, R7, #1
ADD R6, R6, R7
BRnz INDISTANCE
LEA R0, OUTBOUND_MSG
TRAP 0x30
TRAP 0x36
HALT
INDISTANCE
    LEA R0, INBOUND_MSG
    TRAP 0x30

HALT
; Note: Please do not change the names of the constants below
G_X .FILL #7 ; x coordinate of goal
G_Y .FILL #-8 ; y coordinate of goal
G_Z .FILL #5 ; z coordinate of goal
GOAL_DIST .FILL #10 ; the distance bound to be checked.
INBOUND_MSG .STRINGZ "The player is within Manhattan distance of the goal"
OUTBOUND_MSG .STRINGZ "The player is outside the goal bounds"
.END