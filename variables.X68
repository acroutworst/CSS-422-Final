* this file contains the variables that should be used throughout the course
* of execution

****************
* GLOBAL STUFF *
****************

* Buffer, storage, and error status
MEM_BUFFER          DS.B    10
OPCODE_BUFFER       DS.B    8
EA_BUFFER           DS.B    26
MEM_BUFFER_POS      DS.B    2
OP_BUFFER_POS       DS.B    2
EA_BUFFER_POS       DS.B    2
ERROR               DS.W    1
OPCODE              DS.B    6
SIZE                DS.B    1
EA_NEEDED           DS.B    1       ; 1 for needed, 0 otherwise
NUM_OPERANDS        DS.B    1
EA_SRC_TYPE         DS.B    1       ; need to list these out
EA_DST_TYPE         DS.B    1       ; need these listed as well

CURRENT_INSTR       DS.W    1
INSTR_ADDR          DS.L    1

CR          EQU     $0D         ; carriage return
LF          EQU     $0A         ; line feed
         
NEWLINE     DC.B    CR,LF,0     ; new line

************
* IO STUFF *
************
ADDYLENGTH  EQU     8   *need 32 bit address length
CKLENGTH    EQU     6   *24 bit address 00007000-00FFFFFF
LINECOUNTER EQU     20

HELLO       DC.B    'Welcome to Teamy McTeamFaces 68k Disassembler!',CR,LF,0
REQSTART    DC.B    'Please enter in the starting location, must be no more than 24 bit:',CR,LF,0
REQEND      DC.B    'Please enter in the ending location, must be no more than 24 bit:',CR,LF,0
LENGTHERR   DC.B    'ERROR: The address contains more than 24 bits. Try again.',CR,LF,0
BADADDY     DC.B    'ERROR: This is a bad address. Try again.',CR,LF,0
SAME	    DC.B 'ERROR:Starting and ending are the same',CR,LF,0
ODDERR      DC.B    'ERROR: Starting address can not be odd, please reenter:',CR,LF,0
BIGEND      DC.B    'ERROR: The ending address is less than the starting address',CR,LF,0
HEADER      DC.B    'MEM LOCATION   OP_CODE    OPERAND   ',CR,LF,0
CLEARQ		DC.B    'Please press enter to clear the screen and continue...', CR,LF,0
RANGE		DC.B 	'This is not within the acceptable address range',CR,LF,0
ASKREPEAT 	DC.B    'Would you like to repeat the program?',CR,LF
			DC.B    'Enter y for yes and press enter to exit',CR,LF,CR,LF,0
GOODBYEM 	DC.B 	'Thank you for trying out Teamy McTeamFace Disassembler!',CR,LF,0       
ERRADD      EQU     $00000000
MINADDY 	EQU     $007000
MAXADDY		EQU		$00FFFFFF
SETLENGTH   DS.B    16
STRING2HEX  DS.B    32
DECIDINGERR DS.B    1


* storage for the start and end address
START_ADDR  DS.L    1
END_ADDR    DS.L    1

* punctuation

SPACE       DC.B    ' ',0
PERIOD      DC.B    '.',0
COMMA       DC.B    ',',0

* number types
POUND       DC.B    '#',0
DOLLAR      DC.B    '$',0
MOD         DC.B    '%',0

* for printing indirect addressing stuff
O_PAREN     DC.B    '(',0
C_PAREN     DC.B    ')',0
PLUS        DC.B    '+',0
MINUS       DC.B    '-',0

* for printing data and address registers
D           DC.B    'D',0
A           DC.B    'A',0

* for printing hex addresses
TXT_0       DC.B    '0',0
TXT_1       DC.B    '1',0
TXT_2       DC.B    '2',0
TXT_3       DC.B    '3',0
TXT_4       DC.B    '4',0
TXT_5       DC.B    '5',0
TXT_6       DC.B    '6',0
TXT_7       DC.B    '7',0
TXT_8       DC.B    '8',0
TXT_9       DC.B    '9',0
TXT_C       DC.B    'C',0
TXT_E       DC.B    'E',0
TXT_F       DC.B    'F',0



****************
* OPCODE STUFF *
****************
* BIT MASKS
* 
* groupings of 4
FIRST4MASK  EQU     $F000
SECON4MASK  EQU     $0F00
THIRD4MASK  EQU     $00F0
LAST_4MASK  EQU     $000F

* ea masks
B0TO2MASK   EQU     $0007
B3TO5MASK   EQU     $0038
B6TO8MASK   EQU     $01C0
B9TO11MASK  EQU     $0E00

* size mask
B6TO7MASK   EQU     $00C0
B9TO10MASK  EQU     $0600
B3TO4MASK   EQU     $0018


* SIZE MODIFIERS
B           DC.B    'B',0
W           DC.B    'W',0
L           DC.B    'L',0

* OPCODES
MOVE_TXT    DC.B    'MOVE',0
MOVEA_TXT   DC.B    'MOVEA',0
MOVEQ_TXT   DC.B    'MOVEQ',0
MOVEM_TXT   DC.B    'MOVEM',0
NOP_TXT     DC.B    'NOP',0
JSR_TXT     DC.B    'JSR',0
ADD_TXT     DC.B    'ADD',0
ADDI_TXT    DC.B    'ADDI',0
ADDA_TXT    DC.B    'ADDA',0
ADDQ_TXT    DC.B    'ADDQ',0
RTS_TXT     DC.B    'RTS',0
LEA_TXT     DC.B    'LEA',0
CLR_TXT     DC.B    'CLR',0
DIVU_TXT    DC.B    'DIVU',0
DIVS_TXT    DC.B    'DIVS',0
OR_TXT      DC.B    'OR',0
SUB_TXT     DC.B    'SUB',0
SUBA_TXT    DC.B    'SUBA',0
SUBQ_TXT    DC.B    'SUBQ',0
CMP_TXT     DC.B    'CMP',0
CMPA_TXT    DC.B    'CMPA',0
MULS_TXT    DC.B    'MULS',0
MULU_TXT    DC.B    'MULU',0
AND_TXT     DC.B    'AND',0
LSL_TXT     DC.B    'LSL',0
LSR_TXT     DC.B    'LSR',0
ASL_TXT     DC.B    'ASL',0
ASR_TXT     DC.B    'ASR',0
ROL_TXT     DC.B    'ROL',0
ROR_TXT     DC.B    'ROR',0
ROXL_TXT    DC.B    'ROXL',0
ROXR_TXT    DC.B    'ROXR',0
DATA_TXT    DC.B    'DATA',0
ERR_TXT     DC.B    'ERROR',0


**************
*  EA Error  *
**************
ADDR_TXT    DC.B    'FFFF',0 

* Bcc SPECIFIC TEXT
BRA_TXT      DC.B    'BRA',0
BSR_TXT      DC.B    'BSR',0
BHI_TXT      DC.B    'BHI',0
BLS_TXT      DC.B    'BLS',0
BCC_TXT      DC.B    'BCC',0
BCS_TXT      DC.B    'BCS',0
BNE_TXT      DC.B    'BNE',0
BEQ_TXT      DC.B    'BEQ',0
BVC_TXT      DC.B    'BVC',0
BVS_TXT      DC.B    'BVS',0
BPL_TXT      DC.B    'BPL',0
BMI_TXT      DC.B    'BMI',0
BGE_TXT      DC.B    'BGE',0
BLT_TXT      DC.B    'BLT',0
BGT_TXT      DC.B    'BGT',0
BLE_TXT      DC.B    'BLE',0




























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
