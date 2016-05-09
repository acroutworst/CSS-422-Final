*-----------------------------------------------------------
* Title      :User input
* Written by :Nguyen
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
START: LEA HELLO,A1     *LOAD Welcome message
       MOVE.B #14,D0    * Moves 14 into data register
       TRAP #15          *Prints out wecome message
            
*ask for starting address
BACK   LEA
       MOVE.B #4, D0 
       TRAP #15         *Read inputinto D1.L
       MOVE.L D0,D2     *transfer start from d1 to d2

       LEA REQEND,A1 *Load end message
       MOVE.B #4,D0
       TRAP #15  *Read input into D1.L
*check address validity
ADDY   CMP.L D1,D2   *Compares The starting address to the ending address
* Put program code here
       BGE BACK     *If D1 (starting) is greater than D2 (end) go back for new addresses
       

       CMP.L D1,#1000    *Compares D1 to initial address
       BLE BACK     *if D1 is less than or equal than $1000 starting addy of the program then must ask for new start
       MOVE.B D1,D3 *move over to keep D1 unchanged
       LSR.L #1, D3
       BCS ODD    
       BRA EVEN
       
ODD
       MOVE.B #4,D0       *takes in new number
       TRAP #15
       BRA ADDY          *uses new address and recheck for errors
* If even check for length of addy*
EVEN 
  

  
  
  
   *goes back to user to reenter

    SIMHALT             ; halt simulator

* Put variables and constants here
CR EQU $0D     *ASCII code for carriage return
LF EQU $0A     *ASCII code for line feed
ADDYLENGTH EQU 8   *need 32 bit address length
HELLO DC.B 'Welcome to Teamy McTeamFaces Disassembler!',CR,LF,0
REQSTART DC.B 'Please enter in the starting location:',CR,LF, 0
REQEND DC.B 'Please enter in the ending location:',CR,LF,0
ODDERR DC>B 'Starting address can't be odd, please reenter:', CR, LF, 0
    END    START        ; last line of source

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~