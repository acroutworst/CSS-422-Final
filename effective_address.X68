*-----------------------------------------------------------
* Title      : Effective Address Decoder
* Written by : Adam Croutworst
* Date       : 05/14/16
* Description:
*-----------------------------------------------------------
EADECODER:

    MOVEM.L     A0-A5/D0-D7,-(SP)   ; move registers to stack to be moved
    LEA         ERROR,A1            ; load error status from Opcode
    CMP.B       #0,(A1)             ; compare error to 0 to check for ok status
    BNE         FINISH_EADECODER
    
    LEA         EA_NEEDED,A1        ; check ea_needed status (1 for needed, 0 for not)
    CMP.B       #0,(A1)
    BEQ         EADECODER_NO
    
    LEA         CURRENT_INSTR,A5
    MOVE.W      (A6)+,(A5)  ; capture current instruction
    BRA         GET_OPERANDS
    
EADECODER_NO:
    LEA         CURRENT_INSTR,A5
    MOVE.W      (A6)+,(A5)  ; capture current instruction
    BRA         FINISH_EADECODER
    
    
    
GET_OPERANDS:
    CLR.L       D0
    LEA         NUM_OPERANDS,A0
    MOVE.B      (A0),D0
    MULU        #8,D0
    LEA         OPERANDS_TABLE,A1
    JSR         0(A1,D0)
    BRA         FINISH_EADECODER
    
    
    
    
OPERANDS_TABLE:
    JSR         NO_OPERANDS
    RTS
    JSR         ONE_OPERAND
    RTS
    JSR         TWO_OPERAND
    RTS
    
    
NO_OPERANDS:
    RTS
    
ONE_OPERAND:
    
    JSR         GET_DEST
    
    RTS
    
TWO_OPERAND:
    
    
    JSR         GET_SOURCE
    
    LEA         COMMA,A0
    MOVE.B      #2,D0
    JSR         PUSHBUFFER
    
    JSR         GET_DEST
    
    RTS
    
    
GET_SOURCE:
    LEA         EA_SRC_TYPE,A5
    MOVE.B      (A5),D0
    MULU        #8,D0

    LEA         SOURCE_TABLE,A0
    JSR         0(A0,D0)
    RTS

GET_DEST:
    LEA         EA_DST_TYPE,A5
    MOVE.B      (A5),D0
    MULU        #8,D0
    
    LEA         DEST_TABLE,A0
    JSR         0(A0,D0)
    RTS
    
SOURCE_TABLE:
    JSR         EASRC00
    RTS
    JSR         EASRC01
    RTS
    JSR         EASRC02
    RTS
    JSR         EASRC03
    RTS
    JSR         EASRC04
    RTS
    JSR         EASRC05
    RTS
    JSR         EASRC06
    RTS
    JSR         EASRC07
    RTS
    
    
****************************************
*  MOVE,MOVEA,ADD,ADDA,SUB,SUBA,OR,AND *
****************************************
EASRC00:
    MOVE.B      #5,D4               ; choose bitmask routine
    MOVE.W      CURRENT_INSTR,D5             ; move instruction in
    JSR         BITMASKER
    
    MOVE.L      D5,D3               ; store the mode
    
    MOVE.W      CURRENT_INSTR,D5
    MOVE.L      #4,D4               ; store reg info
    JSR         BITMASKER
    
    MOVE.L      D5,D4
    
    MULU        #8,D3               ; offset for jump table
    
    LEA         EA_TABLE,A0         ; load the effective address jump table
    JSR         0(A0,D3)            ; call jump table
    RTS

**************
*  ADDQ,SUBQ *
**************
EASRC01:
    MOVE.B      #$A,D4
    MOVE.W      CURRENT_INSTR,D5
    JSR         BITMASKER
    
    MOVE.L      D5,D3               ; store data
    
    MULU        #8,D3               ; offset for jump table
    
    LEA         EA_TABLE,A0         ; load the effective address jump table
    JSR         0(A0,D3)            ; call jump table         
    
    RTS
    
****************************
*  LSL,LSR,ASR,ASL,ROL,ROR *
****************************
EASRC02:
    MOVE.B      #5,D4               ; choose bitmask routine
    MOVE.W      CURRENT_INSTR,D5             ; move instruction in
    JSR         BITMASKER
    
    MOVE.L      D5,D3               ; store the mode
    
    MOVE.W      CURRENT_INSTR,D5
    MOVE.L      #4,D4               ; store reg info
    JSR         BITMASKER
    
    MOVE.L      D5,D4
    
    MULU        #8,D3               ; offset for jump table
    
    LEA         EA_TABLE,A0         ; load the effective address jump table
    JSR         0(A0,D3)            ; call jump table

    RTS
    
***************
*  MULU,DIVU  *
***************
EASRC03:
    MOVE.B      #5,D4               ; choose bitmask routine
    MOVE.W      CURRENT_INSTR,D5             ; move instruction in
    JSR         BITMASKER
    
    MOVE.L      D5,D3               ; store the mode
    
    MOVE.W      CURRENT_INSTR,D5
    MOVE.L      #4,D4               ; store reg info
    JSR         BITMASKER
    
    MOVE.L      D5,D4
    
    MULU        #8,D3               ; offset for jump table
    
    LEA         EA_TABLE,A0         ; load the effective address jump table
    JSR         0(A0,D3)            ; call jump table
    
    RTS
    
*********
*  CMP  *
*********
EASRC04:
    MOVE.B      #5,D4               ; choose bitmask routine
    MOVE.W      CURRENT_INSTR,D5             ; move instruction in
    JSR         BITMASKER
    
    MOVE.L      D5,D3               ; store the mode
    
    MOVE.W      CURRENT_INSTR,D5
    MOVE.L      #4,D4               ; store reg info
    JSR         BITMASKER
    
    MOVE.L      D5,D4
    
    MULU        #8,D3               ; offset for jump table
    
    LEA         EA_TABLE,A0         ; load the effective address jump table
    JSR         0(A0,D3)            ; call jump table
    
    RTS
    
*********
*  LEA  *
*********   
EASRC05:
    MOVE.B      #5,D4               ; choose bitmask routine
    MOVE.W      CURRENT_INSTR,D5             ; move instruction in
    JSR         BITMASKER
    
    MOVE.L      D5,D3               ; store the mode
    
    MOVE.W      CURRENT_INSTR,D5
    MOVE.L      #4,D4               ; store reg info
    JSR         BITMASKER
    
    MOVE.L      D5,D4
    
    MULU        #8,D3               ; offset for jump table
    
    LEA         EA_TABLE,A0         ; load the effective address jump table
    JSR         0(A0,D3)            ; call jump table    

    RTS
    
**********
*  MOVEM *
**********
EASRC06:
    MOVE.B      #5,D4               ; choose bitmask routine
    MOVE.W      CURRENT_INSTR,D5             ; move instruction in
    JSR         BITMASKER
    
    MOVE.L      D5,D3               ; store the mode
    
    MOVE.W      CURRENT_INSTR,D5
    MOVE.L      #4,D4               ; store reg info
    JSR         BITMASKER
    
    MOVE.L      D5,D4
    
    MULU        #8,D3               ; offset for jump table
    
    LEA         EA_TABLE,A0         ; load the effective address jump table
    JSR         0(A0,D3)            ; call jump table
    
    RTS
    
EASRC07:
    RTS
    

DEST_TABLE:
    JSR         EADST00
    RTS
    JSR         EADST01
    RTS
    JSR         EADST02
    RTS
    JSR         EADST03
    RTS
    JSR         EADST04
    RTS
    JSR         EADST05
    RTS
    JSR         EADST06
    RTS
    JSR         EADST07
    RTS
    JSR         EADST08 
    RTS
    JSR         EADST09
    RTS
    JSR         EADST10
    RTS
    JSR         EADST11
    RTS
    
**********************************
*  MOVE,ADD,ADDA,SUB,SUBA,OR,AND *
**********************************
EADST00:
    MOVE.B      #6,D4                   ; choose bitmask routine (8-6)
    MOVE.W      CURRENT_INSTR,D5        ; move instruction in
    JSR         BITMASKER               ; jump to bitmasker
    
    MOVE.B      D5,D3                   ; store the mode
    
    MOVE.W      CURRENT_INSTR,D5        ; get instruction
    MOVE.B      #$A,D4                  ; mask 11-9
    JSR         BITMASKER
    
    MOVE.B      D5,D4                   ; store the register
    
    
    * jump to the mode in D3
    MULU        #8,D3
    
    LEA         EA_TABLE,A0
    JSR         0(A0,D3)
    
    RTS
    
************
*  MOVE/?  *
************ 
EADST01:
    MOVE.W      CURRENT_INSTR,D5        ; get current instruction
    MOVE.B      #5,D4                   ; mask for 3-5
    JSR         BITMASKER
    
    MOVE.B      D5,D3                   ; store the mode
    
    MOVE.W      CURRENT_INSTR,D5        ; get instruction again
    MOVE.B      #4,D4                   ; mask for 0-2
    JSR         BITMASKER
    
    MOVE.B      D5,D4                   ; store reg info
    
    MULU        #8,D3                   ; get offset
    
    LEA         EA_TABLE,A0             ; load ea table
    JSR         0(A0,D3)
    
    RTS
    
***********
*  MOVEA  *
***********
EADST02:
    MOVE.W      CURRENT_INSTR,D5        ; get current instruction
    MOVE.B      #9,D4                   ; mask for 3 & 4
    JSR         BITMASKER
    
    MOVE.B      D5,D4                   ; store the reg
    
    MULU        #8,D4                   ; get offset
    
    LEA         EA_TABLE,A0             ; load ea table
    JSR         0(A0,D4)

    RTS
    
*****************
*   ADDQ,SUBQ   *
*****************
EADST03:
    MOVE.B      #5,D4               ; choose bitmask routine
    MOVE.W      CURRENT_INSTR,D5             ; move instruction in
    JSR         BITMASKER
    
    MOVE.L      D5,D3               ; store the mode
    
    MOVE.W      CURRENT_INSTR,D5
    MOVE.L      #4,D4               ; store reg info
    JSR         BITMASKER
    
    MOVE.L      D5,D4
    
    MULU        #8,D3               ; offset for jump table
    
    LEA         EA_TABLE,A0         ; load the effective address jump table
    JSR         0(A0,D3)            ; call jump table
    
    RTS
    
****************************
*  LSL,LSR,ASR,ASL,ROL,ROR *
****************************
EADST04:    
    MOVE.B      #5,D4               ; choose bitmask routine
    MOVE.W      CURRENT_INSTR,D5             ; move instruction in
    JSR         BITMASKER
    
    MOVE.L      D5,D3               ; store the mode
    
    MOVE.W      CURRENT_INSTR,D5
    MOVE.L      #4,D4               ; store reg info
    JSR         BITMASKER
    
    MOVE.L      D5,D4
    
    MULU        #8,D3               ; offset for jump table
    
    LEA         EA_TABLE,A0         ; load the effective address jump table
    JSR         0(A0,D3)            ; call jump table
    
    RTS
    
**************
*  MULU,DIVU *
**************
EADST05:
    MOVE.B      #$A,D0               ; choose mask 11-9
    MOVE.W      CURRENT_INSTR,D5     ; move instruction in
    JSR         BITMASKER      

    MOVE.L      D5,D3
    
    MULU        #8,D3
    
    LEA         EA_TABLE,A0         ; load the effective address jump table
    JSR         0(A0,D3)            ; call jump table   

    RTS
    
*********
*  CMP  *
*********
EADST06:
    MOVE.B      #6,D4                   ; choose bitmask routine (8-6)
    MOVE.W      CURRENT_INSTR,D5        ; move instruction in
    JSR         BITMASKER               ; jump to bitmasker
    
    MOVE.B      D5,D3                   ; store the mode
    
    MOVE.W      CURRENT_INSTR,D5        ; get instruction
    MOVE.B      #$A,D4                  ; mask 11-9
    JSR         BITMASKER
    
    MOVE.B      D5,D4                   ; store the register
    
    
    * jump to the mode in D3
    MULU        #8,D3
    
    LEA         EA_TABLE,A0
    JSR         0(A0,D3)

    RTS
   
*********
*  LEA  *
*********
EADST07:
    MOVE.B      #$A,D0               ; choose mask 11-9
    MOVE.W      CURRENT_INSTR,D5     ; move instruction in
    JSR         BITMASKER      

    MOVE.L      D5,D3
    
    MULU        #8,D3
    
    LEA         EA_TABLE,A0         ; load the effective address jump table
    JSR         0(A0,D3)            ; call jump table  

    RTS
    
*********
*  CLR  *
*********
EADST08:
    MOVE.W      CURRENT_INSTR,D5        ; get current instruction
    MOVE.B      #5,D4                   ; mask for 3-5
    JSR         BITMASKER
    
    MOVE.B      D5,D3                   ; store the mode
    
    MOVE.W      CURRENT_INSTR,D5        ; get instruction again
    MOVE.B      #4,D4                   ; mask for 0-2
    JSR         BITMASKER
    
    MOVE.B      D5,D4                   ; store reg info
    
    MULU        #8,D3                   ; get offset
    
    LEA         EA_TABLE,A0             ; load ea table
    JSR         0(A0,D3)    
    
    RTS
    
***********
*  MOVEM  *
***********
EADST09:
    MOVE.B      #5,D4               ; choose bitmask routine
    MOVE.W      CURRENT_INSTR,D5             ; move instruction in
    JSR         BITMASKER
    
    MOVE.L      D5,D3               ; store the mode
    
    MOVE.W      CURRENT_INSTR,D5
    MOVE.L      #4,D4               ; store reg info
    JSR         BITMASKER
    
    MOVE.L      D5,D4
    
    MULU        #8,D3               ; offset for jump table
    
    LEA         EA_TABLE,A0         ; load the effective address jump table
    JSR         0(A0,D3)            ; call jump table
 
    RTS
    
***********
*   JSR   *
***********
EADST10:
    MOVE.W      CURRENT_INSTR,D5        ; get current instruction
    MOVE.B      #5,D4                   ; mask for 3-5
    JSR         BITMASKER
    
    MOVE.B      D5,D3                   ; store the mode
    
    MOVE.W      CURRENT_INSTR,D5        ; get instruction again
    MOVE.B      #4,D4                   ; mask for 0-2
    JSR         BITMASKER
    
    MOVE.B      D5,D4                   ; store reg info
    
    MULU        #8,D3                   ; get offset
    
    LEA         EA_TABLE,A0             ; load ea table
    JSR         0(A0,D3)
    
    RTS   
 
***********
*   BRA   *
***********
EADST11:
    MOVE.W      CURRENT_INSTR,D5
    MOVE.B      #3,D4
    JSR         BITMASKER

    MOVE.B      #2,D4
    JSR         BITMASKER

    MULU        #8,D3
       
    LEA         EA_TABLE,A0             ; load ea table
    JSR         0(A0,D3) 

    RTS

FINISH_EADECODER:
    MOVEM.L     (SP)+,A0-A5/D0-D7   ; move registers back from stack
    RTS                             ; exit subroutine

    INCLUDE 'eamodes/ea_table.x68'

















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
