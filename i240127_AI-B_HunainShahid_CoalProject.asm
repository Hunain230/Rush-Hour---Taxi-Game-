INCLUDE Irvine32.inc

.stack 100h 

.data

;===================== title page ==========================

titleMsg BYTE "R U S H   H O U R ",0
pressKeyMsg BYTE "Press any key to continue...",0
borderLine BYTE "==============================================",0
borderLine2 BYTE "=======================================================",0
borderLine3 BYTE "=====================================",0


;======================== menu declarations =============================

menuTitle BYTE "MAIN MENU",0
menu1 BYTE "1. Start New Game",0
menu2 BYTE "2. Select Taxi Color",0
menu3 BYTE "3. View Leader Board",0
menu4 BYTE "4. Read Instructions",0
menu5 BYTE "5. CHange Mode" ,0 
menu6 BYTE "6. Exit",0
menuPrompt BYTE "Use W/S to navigate, ENTER to select",0
selected BYTE ">",0
notSelected BYTE " ",0

;=========================== Taxi color selection =======================

taxiColorTitle BYTE "SELECT TAXI COLOR",0
taxiColor1 BYTE "1. Red Taxi ",0
taxiColor2 BYTE "2. Yellow Taxi ",0
taxiColorPrompt BYTE "Enter to select ",0
selectedTaxiColor BYTE 2                      ; yellow as default 
taxiColorMsg BYTE "Selected: ",0
redTaxiMsg BYTE "Red Taxi",0
yellowTaxiMsg BYTE "Yellow Taxi",0

;======================= Player name ===============================

playerName BYTE 30 DUP(0)
namePrompt BYTE "Enter your name: ",0
nameLength DWORD 0

;========================== Instructions ============================

instructionsTitle BYTE "GAME INSTRUCTIONS",0
instruction1 BYTE "Objective: Pick up passengers and drop them",0
instruction2 BYTE "          at their destinations to earn points",0
instruction3 BYTE "Controls: Use Arrow Keys to move the taxi",0
instruction4 BYTE "          Press SPACEBAR to pick up/drop passengers",0
instruction5 BYTE "          Press ESC to return to menu",0
instruction6 BYTE "Scoring: +10 points for each successful delivery",0
instruction7 BYTE "Red Taxi: -2 obstacle, -3 car, -5 person hit",0
instruction8 BYTE "Yellow Taxi: -4 obstacle, -2 car, -5 person hit",0
instruction9 BYTE "Tips: Yellow taxi is faster than red taxi",0
instruction10 BYTE "      Pick up passengers (P) when adjacent",0
instruction11 BYTE "      Navigate to GREEN destination carefully",0
backPrompt BYTE "Press B to go back to Main Menu",0

difficultyCurrentSelection DWORD 1
taxiColorCurrentSelection DWORD 1

;============================= Leaderboard data ================================

leaderboardTitle BYTE "TOP 5 HIGH SCORES",0
leaderboardFile BYTE "Leaderboard.txt",0
fileHandle DWORD ?
leaderboardPrompt BYTE "Press B to go back",0
noScoresMsg BYTE "No high scores yet ",0

;========================== Leaderboard structures =============================

MAX_LEADERBOARD EQU 5
leaderboardNames BYTE MAX_LEADERBOARD * 30 DUP(0)   ; 30 chars 
leaderboardScores DWORD MAX_LEADERBOARD DUP(0)
leaderboardCount DWORD 0

;========================= exit command ===============================

goodbyeMsg BYTE "GOOD BYE! Hope to see you again soon!",0


;===================== Grid Data with boundary ===========================

GRID_WIDTH EQU 22
GRID_HEIGHT EQU 22

taxiX BYTE 1
taxiY BYTE 1
hasPassenger BYTE 0                                 
currentPassengerIndex BYTE 0

;============================= NPC Cars data ========================

MAX_CARS EQU 4
carX BYTE MAX_CARS DUP(5, 10, 15, 8)
carY BYTE MAX_CARS DUP(5, 10, 8, 15)
carDirX BYTE MAX_CARS DUP(1, -1, 0, 1)
carDirY BYTE MAX_CARS DUP(0, 0, 1, -1)
carSpeed DWORD 3                         ; change speed
passengersDelivered DWORD 0

;============================ Passenger data =======================

MAX_PASSENGERS EQU 5
passengerX BYTE MAX_PASSENGERS DUP(3, 18, 12, 6, 16)
passengerY BYTE MAX_PASSENGERS DUP(3, 18, 10, 15, 5)
passengerActive BYTE MAX_PASSENGERS DUP(1, 1, 1, 1, 1)
destX BYTE MAX_PASSENGERS DUP(0, 0, 0, 0, 0)
destY BYTE MAX_PASSENGERS DUP(0, 0, 0, 0, 0)

; 0 = boundary, 1 = road, 2 = barrier

grid BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0    
     BYTE 0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0    
     BYTE 0,1,1,1,2,2,2,1,1,1,1,1,1,2,2,2,2,2,2,2,1,0    
     BYTE 0,1,1,1,1,1,2,1,1,1,2,1,1,1,1,1,1,1,1,1,1,0    
     BYTE 0,2,2,1,1,1,2,2,1,1,2,1,1,2,2,2,1,1,1,2,2,0    
     BYTE 0,1,1,1,1,1,1,1,1,1,2,1,1,1,1,1,1,1,1,1,1,0    
     BYTE 0,1,1,2,2,2,1,1,1,1,2,2,2,1,1,1,1,2,2,2,1,0    
     BYTE 0,1,1,1,1,2,1,1,2,1,1,1,1,1,1,1,1,2,1,1,1,0    
     BYTE 0,1,2,2,2,2,2,1,2,1,1,2,2,2,2,1,1,2,1,1,1,0    
     BYTE 0,1,1,1,1,1,1,1,2,1,1,1,1,1,1,1,1,2,1,1,1,0    
     BYTE 0,1,1,1,2,1,1,1,2,2,1,1,1,1,2,1,1,2,2,2,1,0    
     BYTE 0,1,1,1,2,1,1,1,1,1,1,2,2,1,2,1,1,1,1,1,1,0    
     BYTE 0,2,2,2,2,1,1,2,2,2,1,1,1,1,2,1,1,1,1,1,1,0    
     BYTE 0,1,1,1,1,1,1,1,1,1,1,1,2,2,2,1,1,2,2,2,1,0    
     BYTE 0,1,1,1,1,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,1,0    
     BYTE 0,1,2,1,1,1,1,1,1,1,1,2,2,1,1,2,2,2,1,1,1,0    
     BYTE 0,1,2,1,1,1,2,2,2,2,1,1,1,1,1,1,1,1,1,1,1,0    
     BYTE 0,1,2,2,2,1,1,1,1,1,1,1,2,2,2,1,1,1,2,2,2,0    
     BYTE 0,1,1,1,1,1,1,1,2,2,1,1,1,1,1,1,1,1,1,1,1,0    
     BYTE 0,1,1,1,2,2,2,1,1,1,1,2,1,1,1,1,2,2,2,1,1,0    
     BYTE 0,1,1,1,1,1,1,1,1,1,1,2,1,1,1,1,1,1,1,1,1,0    
     BYTE 0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0    


score DWORD 0
moveCounter DWORD 0
firstDraw BYTE 1 

gameTitle BYTE "          === RUSH HOUR || TAXI GAME ===",0
scoreMsg BYTE "Score: ",0
passengerMsg BYTE "Passenger: ",0
pickedUpMsg BYTE "YES",0
waitingMsg BYTE "NO ",0

currentSelection DWORD 1  

;============================= Game Modes =============================

difficultyTitle BYTE "SELECT GAME MODE",0
difficulty1 BYTE "1. Career Mode",0
difficulty2 BYTE "2. Endless Mode",0
difficulty3 BYTE "3. Timed Mode",0
difficultyPrompt BYTE "Enter to select",0
currentDifficultymsg BYTE "Current Mode: ",0
difficultySetMsg BYTE "Mode set to: ",0

difficultySelection DWORD 1

;===================== Game mode variables ================

gameTime DWORD 120              ; 2 minutes
timeRemaining DWORD 120
careerLevel DWORD 1
careerTargetDeliveries DWORD 5  ; deliver 5 passengers 
careerDeliveriesMade DWORD 0
timedTargetDeliveries DWORD 2   ; deliver 2 passngers timed
timedDeliveriesMade DWORD 0

;======================= Messages ======================

timerMsg BYTE "Time: ",0
timeUpMsg BYTE "TIME'S UP! Game Over!",0
careerMissionMsg BYTE "Mission: Deliver 5 passengers",0
careerSuccessMsg BYTE "MISSION COMPLETE! ",0
timedMissionMsg BYTE "Mission: Deliver 2 passengers in 30 sec",0
timedSuccessMsg BYTE "SUCCESS! Passengers delivered !",0
timedFailMsg BYTE "FAILED! ",0
endlessMsg BYTE "Endless Mode: Deliver as many as possible",0
gameOverPrompt BYTE "Press any key to return to Main Menu",0

;===================== Obstacles data ====================

MAX_OBSTACLES EQU 3
obstacleX BYTE MAX_OBSTACLES DUP(5, 15, 10)
obstacleY BYTE MAX_OBSTACLES DUP(8, 12, 18)

pauseTitle BYTE "GAME PAUSED",0
pauseMsg1 BYTE "Game is currently paused",0
pauseMsg2 BYTE "Press P to resume playing",0
pauseMsg3 BYTE "Press ESC to return to Main Menu",0

; ====================== Timer Variables ======================
timerCounter DWORD 0   

; ============================= MAIN PROC  =============================
.code
main PROC

    call Display
    call GetPlayerName
    call MainMenu
    exit
main ENDP


; ====================================================================================================================

; ================================= Get Player Name ===========================

GetPlayerName PROC

    call Clrscr
    
    mov dh, 10
    mov dl, 30

    call Gotoxy

    mov eax, yellow + (black * 16)
    call SetTextColor

    mov edx, OFFSET namePrompt
    call WriteString
    
    mov edx, OFFSET playerName
    mov ecx, 29                 ; Max 29 char
    call ReadString
    mov nameLength, eax
    
    ret
GetPlayerName ENDP

; ================================= Display Function ==========================

Display PROC
    call Clrscr
  
    mov eax, lightRed + (black * 16)
    call SetTextColor
    
    mov dh, 5       
    mov dl, 20      
    call Gotoxy

    mov edx, OFFSET borderLine
    call WriteString
   
    mov ecx, 8     
    mov ebx, 6      
    
drawBox:
    mov dh, bl
    mov dl, 20

    call Gotoxy
    mov al, '|'
    call WriteChar
    
    mov dh, bl
    mov dl, 65

    call Gotoxy
    mov al, '|'
    call WriteChar
    
    inc bl
    loop drawBox
    
    mov dh, 14     
    mov dl, 20      

    call Gotoxy
    mov edx, OFFSET borderLine
    call WriteString
  
    mov dh, 8       
    mov dl, 28      
    call Gotoxy
    
    mov eax, yellow
    call SetTextColor

    mov edx, OFFSET titleMsg
    call WriteString
    
    mov dh, 11      
    mov dl, 28      
    call Gotoxy
    
    mov eax, lightGreen
    call SetTextColor

    mov edx, OFFSET pressKeyMsg
    call WriteString
    
    mov dh, 19     
    mov dl, 30      
    call Gotoxy
    
    mov eax, white
    call SetTextColor

    call WaitMsg
    
    ret
Display ENDP


; ================================= Taxi Color Selection ======================

SelectTaxiColor PROC
colorLoop:
    call Clrscr

    mov eax, lightCyan + (black * 16)
    call SetTextColor
    
    mov dh, 5       
    mov dl, 20      
    call Gotoxy

    mov edx, OFFSET borderLine
    call WriteString
   
    mov ecx, 10     
    mov ebx, 6      
    
colorDrawBox:
    mov dh, bl
    mov dl, 20

    call Gotoxy
    mov al, '|'
    call WriteChar
    
    mov dh, bl
    mov dl, 65

    call Gotoxy
    mov al, '|'
    call WriteChar
    
    inc bl
    loop colorDrawBox
    
    mov dh, 16     
    mov dl, 20
    
    call Gotoxy
    mov edx, OFFSET borderLine
    call WriteString
    
    mov dh, 7       
    mov dl, 28  
    
    call Gotoxy
    mov eax, yellow + (black * 16)
    call SetTextColor

    mov edx, OFFSET taxiColorTitle
    call WriteString
    
    mov dh, 14      
    mov dl, 22      
    call Gotoxy

    mov eax, lightGreen + (black * 16)
    call SetTextColor

    mov edx, OFFSET taxiColorPrompt
    call WriteString
    
    mov dh, 15      
    mov dl, 30      
    call Gotoxy

    mov edx, OFFSET backPrompt
    call WriteString
    
    ; Reset color selection if out of bounds

    cmp taxiColorCurrentSelection, 1
    jl resetTaxiSelection

    cmp taxiColorCurrentSelection, 2
    jg resetTaxiSelection

    jmp displayTaxiOptions
    
resetTaxiSelection:
    mov taxiColorCurrentSelection, 1
    
displayTaxiOptions:
    mov esi, 1
    
displayColor1:
    mov dh, 10      
    mov dl, 25      
    call Gotoxy
    
    mov eax, taxiColorCurrentSelection  
    cmp eax, esi

    jne notColorSel1
    
    ; Yellow color

    mov eax, yellow + (black * 16)
    call SetTextColor

    mov edx, OFFSET selected
    call WriteString

    jmp afterColorSel1
    
notColorSel1:
    ; NOT SELECTED 

    mov eax, white + (black * 16)
    call SetTextColor

    mov edx, OFFSET notSelected
    call WriteString
    
afterColorSel1:
    mov edx, OFFSET taxiColor1
    call WriteString

    inc esi

displayColor2:
    mov dh, 11      
    mov dl, 25      
    call Gotoxy
    
    mov eax, taxiColorCurrentSelection  
    cmp eax, esi
    jne notColorSel2
    
    ; Yellow color
    mov eax, yellow + (black * 16)
    call SetTextColor

    mov edx, OFFSET selected
    call WriteString

    jmp afterColorSel2
    
notColorSel2:
   
    mov eax, white + (black * 16)
    call SetTextColor

    mov edx, OFFSET notSelected
    call WriteString
    
afterColorSel2:
    mov edx, OFFSET taxiColor2
    call WriteString

    call ReadChar
    
    cmp al, 'w'
    je ColorMoveUp
    cmp al, 'W'
    je ColorMoveUp
    
    cmp al, 's'
    je ColorMoveDown
    cmp al, 'S'
    je ColorMoveDown
    
    cmp al, 13
    je ColorSelected
    
    cmp al, 'b'
    je ColorGoBack
    cmp al, 'B'
    je ColorGoBack
    
    jmp colorLoop

ColorMoveUp:
    cmp taxiColorCurrentSelection, 1  
    jle colorLoop

    dec taxiColorCurrentSelection  
    
    jmp colorLoop

ColorMoveDown:
    cmp taxiColorCurrentSelection, 2  
    jge colorLoop

    inc taxiColorCurrentSelection     

    jmp colorLoop

ColorSelected:

    mov eax, taxiColorCurrentSelection  
    mov selectedTaxiColor, al
    
    mov dh, 17      
    mov dl, 25      
    call Gotoxy

    mov eax, lightGreen + (black * 16)
    call SetTextColor
    
    mov edx, OFFSET taxiColorMsg
    call WriteString
    
    cmp selectedTaxiColor, 1
    je showRed

    mov edx, OFFSET yellowTaxiMsg
    jmp showColor

showRed:
    mov edx, OFFSET redTaxiMsg
    
showColor:

    call WriteString
    mov al, '!'

    call WriteChar
    
    mov eax, 1000
    call Delay
    
    ; Reset selection to match the actual selected taxi color

    mov al, selectedTaxiColor
    movzx eax, al
    mov taxiColorCurrentSelection, eax
    
    jmp ColorGoBack

ColorGoBack:

    ; Reset selection when leaving

    mov al, selectedTaxiColor
    movzx eax, al

    mov taxiColorCurrentSelection, eax

    ret
SelectTaxiColor ENDP

; ================================= Initialize Passengers =====================

InitializePassengers PROC
    push eax
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    ; Initialize all passengers as inactive first

    mov ecx, MAX_PASSENGERS
    mov esi, 0

InitInactive:

    mov passengerActive[esi], 0
    mov destX[esi], 0
    mov destY[esi], 0

    inc esi
    loop InitInactive
    
    ; Spawn  3 random passengers on the given map 

    mov ecx, 3  
    mov esi, 0
    
SpawnPassengerLoop:
    push ecx
    
    mov ecx, MAX_PASSENGERS

    mov edi, 0

FindSlot:
    cmp passengerActive[edi], 0
    je FoundSlot

    inc edi

    loop FindSlot

    jmp NoSlotAvailable  
    
FoundSlot:


    call GenerateRandomRoadPosition 
    mov passengerX[edi], al
    mov passengerY[edi], ah

    mov passengerActive[edi], 1
    
NoSlotAvailable:

    pop ecx
    loop SpawnPassengerLoop
    
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
InitializePassengers ENDP


; ================================= Generate Destination ======================

GenerateDestination PROC

    ; Generates a destination different from pickup location , border and obstacles 

    push eax
    push ebx
    push ecx
    push edx
    
    movzx ebx, passengerX[esi]
    movzx ecx, passengerY[esi]
    
TryNewDest:
    call GenerateRandomRoadPosition
    
    cmp al, bl
    jne DestOK
    cmp ah, cl
    je TryNewDest
    
DestOK:
    mov destX[esi], al
    mov destY[esi], ah
    
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
GenerateDestination ENDP


; ================================= Spawn New Passenger =======================

SpawnNewPassenger PROC
   
    push eax
    
    call GenerateRandomRoadPosition

    mov passengerX[esi], al
    mov passengerY[esi], ah

    mov passengerActive[esi], 1

    mov destX[esi], 0
    mov destY[esi], 0
    
    pop eax

    ret
SpawnNewPassenger ENDP


; ================================= Initialize Grid ===========================
InitializeGrid PROC

    ; always start at top left corner 

    mov taxiX, 1
    mov taxiY, 1

    mov hasPassenger, 0
    mov score, 0

    mov firstDraw, 1
    mov passengersDelivered, 0
    mov carSpeed, 3
    
    call InitializePassengers
    
    ; randimly assign fixed slots for the obstacls on the grid - red color ones

    mov obstacleX[0], 5
    mov obstacleY[0], 8
    mov obstacleX[1], 15
    mov obstacleY[1], 12
    mov obstacleX[2], 10
    mov obstacleY[2], 18
    
; now the npc cars on the map 

    mov ecx, MAX_CARS
    mov esi, 0
    
InitCarsLoop:
    push ecx
    push esi
    
    mov ebx, 0  
    
FindValidCarPosition:
    inc ebx
    cmp ebx, 50  

    jg UseFallbackPosition
    
    ; random road position for car

    call GenerateRandomRoadPosition

    mov carX[esi], al
    mov carY[esi], ah
    
    ; check if pos is valid 

    mov ecx, MAX_OBSTACLES
    mov edi, 0

CheckObstacleOverlap:

    movzx edx, obstacleX[edi]
    cmp al, dl

    jne NextObstacleCheckInit
    movzx edx, obstacleY[edi]

    cmp ah, dl
    je FindValidCarPosition  ; Overlaps - try again

NextObstacleCheckInit:

    inc edi
    dec ecx
    jnz CheckObstacleOverlap
    
    ; Check if this position is too close to other cars 

    mov ecx, esi 
    cmp ecx, 0

    je NoCarOverlap 
    
    mov edi, 0

CheckCarDistance:
    cmp edi, esi  

    je NextCarDistanceCheck
    
    movzx ebx, carX[edi]
    sub al, bl

    jns XDistPositive1
    neg al

XDistPositive1:

    mov dl, al 
    
    movzx ebx, carY[edi]
    sub ah, bl

    jns YDistPositive1
    neg ah

YDistPositive1:

    mov dh, ah  
    
    ; If both distances are less than 5, they're too close

    cmp dl, 5

    jl FindValidCarPosition
    cmp dh, 5

    jl FindValidCarPosition
    
NextCarDistanceCheck:

    inc edi
    dec ecx

    jnz CheckCarDistance
    
    jmp NoCarOverlap

UseFallbackPosition:

   ; here i have used the random if it falis to make the random positions ofr the cars 
   ; it was not spawning before 

    cmp esi, 0
    je Car1Pos

    cmp esi, 1
    je Car2Pos

    cmp esi, 2
    je Car3Pos

    
Car1Pos:

    mov carX[esi], 3
    mov carY[esi], 3
    jmp NoCarOverlap

Car2Pos:

    mov carX[esi], 18
    mov carY[esi], 18
    jmp NoCarOverlap

Car3Pos:

    mov carX[esi], 3
    mov carY[esi], 18
    jmp NoCarOverlap

Car4Pos:

    mov carX[esi], 18
    mov carY[esi], 3

NoCarOverlap:

    ; Random direction - set a random number between 1 and 4 and then it will
    ; decide the postion based on the number 

    call Randomize
    mov eax, 4

    call RandomRange
    
    cmp eax, 0
    je SetRight

    cmp eax, 1
    je SetLeft

    cmp eax, 2
    je SetDown

    ; else it will SetUp
    
SetUp:
    mov carDirX[esi], 0
    mov carDirY[esi], -1
    jmp DirectionSet
    
SetDown:
    mov carDirX[esi], 0
    mov carDirY[esi], 1
    jmp DirectionSet
    
SetLeft:
    mov carDirX[esi], -1
    mov carDirY[esi], 0
    jmp DirectionSet
    
SetRight:
    mov carDirX[esi], 1    
    mov carDirY[esi], 0

DirectionSet:
    pop esi
    pop ecx
    inc esi
    dec ecx
    jnz InitCarsLoop
    
    ret
InitializeGrid ENDP


; ================================= Check Collision ===========================

CheckCollisions PROC

    push eax
    push ebx
    push ecx
    push esi
    
    movzx eax, taxiX
    movzx ebx, taxiY
    
    ; for the obstacles 

    mov ecx, MAX_OBSTACLES
    mov esi, 0
    
CheckObstacleLoop:

    movzx edx, obstacleX[esi]
    cmp eax, edx

    jne NextObstacleCheck
    
    movzx edx, obstacleY[esi]
    cmp ebx, edx

    jne NextObstacleCheck

    jmp CollisionDone
    
NextObstacleCheck:
    inc esi
    loop CheckObstacleLoop
    
    ; check collision with the cars 

    mov ecx, MAX_CARS
    mov esi, 0
    mov edi, 0  ; check if the car collsion appplied 
    
CheckCarLoop:

    movzx edx, carX[esi]
    cmp eax, edx

    jne NextCarCheck
    
    movzx edx, carY[esi]
    cmp ebx, edx

    jne NextCarCheck
    
    ; Collision with car aply once used a flag before it was negating the score consectively fpr every frame 

    cmp edi, 0
    jne NextCarCheck  
    
    mov edi, 1  ; flag for the collosion set 


    
    cmp selectedTaxiColor, 1
    je RedCarCollision
    
    ; -2 for car yellow 

    sub score, 2
    jmp NextCarCheck
    
RedCarCollision:
    ; -3 for car red 

    sub score, 3
    
NextCarCheck:

    inc esi
    loop CheckCarLoop
    
    ; Check collision with the persons P 

    mov ecx, MAX_PASSENGERS
    mov esi, 0
    mov edi, 0  ; samer use the flag 
    
CheckPersonLoop:

    cmp passengerActive[esi], 0
    je NextPersonCheck
    
    movzx edx, passengerX[esi]
    cmp eax, edx
    jne NextPersonCheck
    
    movzx edx, passengerY[esi]
    cmp ebx, edx
    jne NextPersonCheck
    
    cmp edi, 0
    jne NextPersonCheck
    
    mov edi, 1  

    sub score, 5
    jmp CollisionDone
    
NextPersonCheck:
    inc esi
    loop CheckPersonLoop
    
CollisionDone:
    pop esi
    pop ecx
    pop ebx
    pop eax
    ret
CheckCollisions ENDP


; ================================= Move NPCs =================================
MoveNPCCars PROC
    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    mov ecx, MAX_CARS
    xor esi, esi
    
moveCarLoop:
    push ecx
    
    ; 30% chance to change direction randomly 

    call Randomize
    mov eax, 10

    call RandomRange

    cmp eax, 3               ; 3 out of 10 chance 
    jge NoDirectionChange

    call Randomize

    mov eax, 4
    call RandomRange
    
    cmp eax, 0
    je ChangeToRight

    cmp eax, 1
    je ChangeToLeft

    cmp eax, 2
    je ChangeToDown

    ; else simply ChangeToUp
    
ChangeToUp:
    mov carDirX[esi], 0
    mov carDirY[esi], -1

    jmp TryMove

ChangeToDown:
    mov carDirX[esi], 0
    mov carDirY[esi], 1

    jmp TryMove

ChangeToLeft:
    mov carDirX[esi], -1
    mov carDirY[esi], 0

    jmp TryMove

ChangeToRight:
    mov carDirX[esi], 1
    mov carDirY[esi], 0

NoDirectionChange:
    ; continue no direction change 

TryMove:

    ;  crrent position and direction

    movzx eax, carX[esi]
    movzx ebx, carY[esi]

    movsx ecx, carDirX[esi]
    movsx edx, carDirY[esi]
    
    ; calculate new pos

    add eax, ecx
    add ebx, edx
    
    ; Check for the boundaries and then simply change the direction 

    cmp eax, 1
    jl ChangeDirection

    cmp eax, 20
    jg ChangeDirection

    cmp ebx, 1
    jl ChangeDirection

    cmp ebx, 20
    jg ChangeDirection
    
    ; Check for the outliers the obstacles 

    push esi
    movzx esi, bl           ; Y position
    mov edi, GRID_WIDTH

    imul esi, edi
    movzx edi, al           ; X position
    add esi, edi
    
    mov edi, OFFSET grid
    movzx edx, BYTE PTR [edi + esi]

    pop esi
    
    cmp edx, 1
    jne ChangeDirection  ; cantmove there is an obstacle placed 

    
    ; same Check for the new position 

    push eax
    push ebx
    push ecx

    mov ecx, MAX_OBSTACLES
    mov edi, 0

CheckObstacleCollision:

    movzx edx, obstacleX[edi]
    cmp al, dl

    jne NextObstacleCar

    movzx edx, obstacleY[edi]
    cmp bl, dl

    je ChangeDirectionPop  ; obstacle 

NextObstacleCar:

    inc edi
    loop CheckObstacleCollision

    pop ecx
    pop ebx
    pop eax
    
    ; Check wehter the  new position has another car so dont move upon it 

    push eax
    push ebx
    push ecx

    mov ecx, MAX_CARS
    mov edi, 0

CheckCarCollision:

    cmp edi, esi  
    je NextCarCar

    movzx edx, carX[edi]
    cmp al, dl

    jne NextCarCar

    movzx edx, carY[edi]
    cmp bl, dl

    je ChangeDirectionPop  ; check for the cars ownslef se they dont interfare eacvh other

NextCarCar:
    inc edi
    loop CheckCarCollision

    pop ecx
    pop ebx
    pop eax
    
; updte the car pos

    mov carX[esi], al
    mov carY[esi], bl
    jmp NextCar

ChangeDirectionPop:

    pop ecx
    pop ebx
    pop eax

ChangeDirection:

    ; if hit then simply change the direction 

    call Randomize
    mov eax, 4
    call RandomRange
    
    cmp eax, 0
    je NewRight

    cmp eax, 1
    je NewLeft

    cmp eax, 2
    je NewDown

    ; else NewUp
    
NewUp:
    mov carDirX[esi], 0
    mov carDirY[esi], -1

    jmp NextCar

NewDown:
    mov carDirX[esi], 0
    mov carDirY[esi], 1

    jmp NextCar

NewLeft:
    mov carDirX[esi], -1
    mov carDirY[esi], 0

    jmp NextCar

NewRight:
    mov carDirX[esi], 1
    mov carDirY[esi], 0

NextCar:
    inc esi
    pop ecx
    dec ecx

    jnz moveCarLoop
    
    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx

    ret
MoveNPCCars ENDP


; ================================= Check Passenger Pickup =======================

CheckPassengerPickup PROC

    push eax
    push ebx
    push ecx
    push esi
    
    cmp hasPassenger, 1
    je AlreadyHasPassenger
    
    mov ecx, MAX_PASSENGERS
    mov esi, 0
    
checkPassLoop:
    push ecx
    
    cmp passengerActive[esi], 0
    je skipPassenger
    
    movzx eax, taxiX
    movzx ebx, passengerX[esi]
    
    sub eax, ebx
    cmp eax, -1
    jl skipPassenger

    cmp eax, 1
    jg skipPassenger
    
    movzx eax, taxiY
    movzx ebx, passengerY[esi]

    sub eax, ebx

    cmp eax, -1
    jl skipPassenger

    cmp eax, 1
    jg skipPassenger
    
    ; Pick the passenger 

    mov passengerActive[esi], 0
    mov hasPassenger, 1

    mov eax, esi
    mov currentPassengerIndex, al
    
    ; and if the passenger is picked up then generate the desitnation on the grid 

    call GenerateDestination
    
    pop ecx
    jmp pickupDone
    
skipPassenger:

    inc esi
    pop ecx

    loop checkPassLoop
    
AlreadyHasPassenger:

; if there is already a pasenger then move on 

pickupDone:
    pop esi
    pop ecx
    pop ebx
    pop eax
    ret
CheckPassengerPickup ENDP


; ================================= Check Passenger Dropoff ===================

CheckPassengerDropoff PROC

    push eax
    push ebx
    push esi
    
    cmp hasPassenger, 0
    je NoPassenger
    
    ; check if it is at the destiation 

    movzx esi, currentPassengerIndex
    
    movzx eax, taxiX
    movzx ebx, destX[esi]

    cmp eax, ebx
    jne NotAtDest
    
    movzx eax, taxiY
    movzx ebx, destY[esi]

    cmp eax, ebx
    jne NotAtDest
    

    ; driop the passenegr and then update the score accordingly 

    add score, 10
    mov hasPassenger, 0
    inc passengersDelivered
    
    ;and then spawn new one 

    call SpawnNewPassenger
    
    ; Increase car speed ie after 2 delieveries 

    mov eax, passengersDelivered
    test eax, 1

    jnz NoSpeedIncrease
    
    cmp carSpeed, 1
    jle NoSpeedIncrease

    dec carSpeed
    
NoSpeedIncrease:

NotAtDest:

NoPassenger:

    pop esi
    pop ebx
    pop eax
    ret
CheckPassengerDropoff ENDP


; ================================= Display Grid ==============================

DisplayGrid PROC
   
    cmp firstDraw, 1
    jne skipClear

    call Clrscr
    mov firstDraw, 0
    
skipClear:
 
    mov dh, 0
    mov dl, 15
    call Gotoxy

    mov eax, yellow + (black * 16)
    call SetTextColor

    mov edx, OFFSET gameTitle
    call WriteString
    
    
    ; Draw  grid

    mov ebx, 0
    
drawRowLoop:
    mov ebp, 0
    
drawColLoop:
    mov dh, bl

    add dh, 2  
    
    mov eax, ebp
    shl eax, 1

    add al, 18
    mov dl, al
    
    call Gotoxy
 
    movzx eax, bl
    mov ecx, GRID_WIDTH

    mul ecx

    movzx ecx, bp
    add eax, ecx
    
    ; get the value of the grid 

    mov esi, OFFSET grid
    add esi, eax

    movzx edx, byte ptr [esi]
    
    ; Check for the taxi

    movzx eax, taxiY
    cmp ebx, eax
    jne checkDest

    movzx eax, taxiX
    cmp ebp, eax

    jne checkDest
    
    ; Draw taxi based on the given color

    cmp selectedTaxiColor, 1
    je DrawRedTaxi
    
    mov eax, black + (yellow * 16)
    call SetTextColor

    mov al, 'T'
    call WriteChar

    mov al, ' '
    call WriteChar

    jmp nextGridCell
    
DrawRedTaxi:

    mov eax, black + (lightRed * 16)
    call SetTextColor

    mov al, 'T'
    call WriteChar

    mov al, ' '
    call WriteChar

    jmp nextGridCell
    
checkDest:

    ; Check for destination 

    cmp hasPassenger, 1
    jne checkCar
    
    movzx esi, currentPassengerIndex
    movzx eax, destY[esi]

    cmp ebx, eax

    jne checkCar

    movzx eax, destX[esi]
    cmp ebp, eax
    jne checkCar
    
    ; Draw destination and set the color as green 

    mov eax, black + (lightGreen * 16)
    call SetTextColor

    mov al, 'D'
    call WriteChar

    mov al, ' '
    call WriteChar

    jmp nextGridCell
    
checkCar:

    ; Check for NPC cars
    push ebx
    push ebp

    mov ecx, MAX_CARS
    mov esi, 0
    
checkCarLoop:
    movzx eax, carY[esi]
    cmp ebx, eax
    jne notThisCar

    movzx eax, carX[esi]
    cmp ebp, eax

    jne notThisCar
    
    pop ebp
    pop ebx
    mov eax, white + (lightMagenta * 16)

    call SetTextColor
    mov al, 'C'

    call WriteChar
    mov al, ' '

    call WriteChar

    jmp nextGridCell
    
notThisCar:
    inc esi
    loop checkCarLoop
    
    pop ebp
    pop ebx
    
checkPassenger:
    ; Check for the passengers

    push ebx
    push ebp

    mov ecx, MAX_PASSENGERS
    mov esi, 0
    
checkPassLoop:
    cmp passengerActive[esi], 0
    je notThisPass
    
    movzx eax, passengerY[esi]
    cmp ebx, eax
    jne notThisPass

    movzx eax, passengerX[esi]
    cmp ebp, eax
    jne notThisPass
    
    pop ebp
    pop ebx

    mov eax, black + (lightCyan * 16)
    call SetTextColor

    mov al, 'P'
    call WriteChar

    mov al, ' '
    call WriteChar
    jmp nextGridCell
    
notThisPass:
    inc esi
    loop checkPassLoop
    
    pop ebp
    pop ebx
    
checkObstacle:
 
    push ebx
    push ebp

    mov ecx, MAX_OBSTACLES
    mov esi, 0
    
checkObstacleLoop:
    movzx eax, obstacleY[esi]
    cmp ebx, eax
    jne notThisObstacle

    movzx eax, obstacleX[esi]
    cmp ebp, eax
    jne notThisObstacle
    
    pop ebp
    pop ebx

    mov eax, white + (red * 16)
    call SetTextColor
    mov al, 'X'          ; red color obstacle 

    call WriteChar
    mov al, ' '

    call WriteChar
    jmp nextGridCell
    
notThisObstacle:
    inc esi
    loop checkObstacleLoop
    
    pop ebp
    pop ebx

drawCell:
    cmp edx, 0
    je drawBoundary

    cmp edx, 2
    je drawBarrier
    
    ; Draw road with the whote background 

    mov eax, lightGray + (white * 16)
    call SetTextColor

    mov al, ' '
    call WriteChar
    call WriteChar

    jmp nextGridCell
    
drawBoundary:
    mov eax, yellow + (blue * 16)
    call SetTextColor

    mov al, 219

    call WriteChar
    call WriteChar
    jmp nextGridCell
    
drawBarrier:
    ; Draw obstacles in with the light gray color 

    mov eax, lightGray + (black * 16)
    call SetTextColor

    mov al, 219

    call WriteChar
    call WriteChar
    
nextGridCell:

    inc ebp
    cmp ebp, GRID_WIDTH
    jl drawColLoop
    
    inc ebx
    cmp ebx, GRID_HEIGHT

    jl drawRowLoop
    
    ; Display score and other things 

    mov dh, 25 
    mov dl, 10
    call Gotoxy

    mov eax, cyan + (black * 16)
    call SetTextColor

    mov edx, OFFSET scoreMsg
    call WriteString
    mov eax, score
    call WriteInt
    
    mov al, ' '

    call WriteChar

    call WriteChar
    call WriteChar
    
    ; Display passenger status as yes or no under the grid 

    mov dh, 25  
    mov dl, 30

    call Gotoxy
    mov edx, OFFSET passengerMsg

    call WriteString
    
    cmp hasPassenger, 1
    je showPickedUp

    mov eax, lightRed + (black * 16)
    call SetTextColor

    mov edx, OFFSET waitingMsg
    call WriteString

    jmp endDisplay
    
showPickedUp:

    mov eax, lightGreen + (black * 16)
    call SetTextColor

    mov edx, OFFSET pickedUpMsg
    call WriteString
    
    
endDisplay:

    call DisplayModeInfo
    
    ret
DisplayGrid ENDP

; ================================= Game Loop =================================

GameLoop PROC

    call InitializeGrid

    mov careerDeliveriesMade, 0
    mov timedDeliveriesMade, 0

    mov timeRemaining, 30  ; can be changesd any for instace it is 30 sec 

    mov moveCounter, 0
    mov timerCounter, 0  

    mov firstDraw, 1
    
mainGameLoop:

    inc moveCounter
    mov eax, moveCounter

    cmp eax, carSpeed
    jl skipNPCMove

    mov moveCounter, 0
    call MoveNPCCars
    
skipNPCMove:
    
   ; check the time for the time mode 

    call CheckTimedMode
    cmp eax, 1

    je ExitGameLoop 

skipTimerUpdate:

    cmp firstDraw, 1
    jne noClear

    call Clrscr
    mov firstDraw, 0
    
noClear:
    call DisplayGrid
   
    call DisplayModeInfo 

    cmp selectedTaxiColor, 1
    je RedTaxiDelay
    

    mov eax, 100
    jmp ApplyDelay
    
RedTaxiDelay:
    mov eax, 150
    
ApplyDelay:
    call Delay
    
    
    call ReadKey
    jz mainGameLoop
    
    
    cmp dx, VK_UP
    je MoveTaxiUp

    cmp dx, VK_DOWN
    je MoveTaxiDown

    cmp dx, VK_LEFT
    je MoveTaxiLeft

    cmp dx, VK_RIGHT
    je MoveTaxiRight
    
    cmp al, 32
    je TryPickupOrDrop
    
    cmp al, 27
    je ExitGameLoop

    cmp al, 'p'
    je PauseTheGame
    cmp al, 'P'
    je PauseTheGame
    
    jmp mainGameLoop

PauseTheGame:
    call PauseGame
    
    cmp eax, 1
    je ExitGameLoop
   
    jmp mainGameLoop

MoveTaxiUp:

    movzx eax, taxiY
    cmp eax, 1
    jle mainGameLoop  
    
    dec eax
    mov bl, al  ; new Y position
    
    ; Check if the target position is a road 

    movzx eax, bl      ; Y position
    mov edx, GRID_WIDTH
    mul edx

    movzx edx, taxiX   ; X position
    add eax, edx
    
    mov esi, OFFSET grid
    add esi, eax

    movzx eax, byte ptr [esi]
    
    cmp eax, 1
    jne CheckObstacleUp  ; If not road then check wether there any obstacle 

    
    ; if it is a road then move the taxi

    mov taxiY, bl
    jmp AfterMove
    
CheckObstacleUp:
    cmp eax, 2
    jne mainGameLoop  ; If not obstacle either dont move 

    
    ; Hit obstacle apply the penalty based on taxi color

    cmp selectedTaxiColor, 1
    je RedObstacleUp

    sub score, 4  ; -4 for obstacle yellow car 

    jmp mainGameLoop

RedObstacleUp:

    sub score, 2  ; -2 for obstacle red car 

    jmp mainGameLoop

MoveTaxiDown:

; similar to the mov taxi up 

    movzx eax, taxiY
    cmp eax, 20

    jge mainGameLoop  ; boundry checks 
    
    inc eax
    mov bl, al  ; y pos 

    
    ; Check if the target position is a road 

    movzx eax, bl      ; Y position
    mov edx, GRID_WIDTH
    mul edx
    movzx edx, taxiX   ; X position
    add eax, edx
    
    mov esi, OFFSET grid
    add esi, eax
    movzx eax, byte ptr [esi]
    
    cmp eax, 1
    jne CheckObstacleDown  
    
    mov taxiY, bl
    jmp AfterMove
    
CheckObstacleDown:
    cmp eax, 2
    jne mainGameLoop 
    

    cmp selectedTaxiColor, 1
    je RedObstacleDown

    sub score, 4  
    jmp mainGameLoop

RedObstacleDown:

    sub score, 2
    jmp mainGameLoop

MoveTaxiLeft:

    movzx eax, taxiX
    cmp eax, 1
    jle mainGameLoop  
    
    dec eax
    mov bl, al  
    
   
    movzx eax, taxiY   
    mov edx, GRID_WIDTH

    mul edx
    movzx edx, bl      

    add eax, edx
    
    mov esi, OFFSET grid
    add esi, eax

    movzx eax, byte ptr [esi]
    
    cmp eax, 1
    jne CheckObstacleLeft  
    

    mov taxiX, bl
    jmp AfterMove
    
CheckObstacleLeft:
    cmp eax, 2
    jne mainGameLoop  
    
    
    cmp selectedTaxiColor, 1
    je RedObstacleLeft

    sub score, 4  
    jmp mainGameLoop

RedObstacleLeft:

    sub score, 2  
    jmp mainGameLoop

MoveTaxiRight:

    movzx eax, taxiX
    cmp eax, 20
    jge mainGameLoop 
    
    inc eax
    mov bl, al  
    

    movzx eax, taxiY   
    mov edx, GRID_WIDTH
    mul edx
    movzx edx, bl      
    add eax, edx
    
    mov esi, OFFSET grid
    add esi, eax
    movzx eax, byte ptr [esi]
    
    cmp eax, 1
    jne CheckObstacleRight 
    
    mov taxiX, bl
    jmp AfterMove
    
CheckObstacleRight:
    cmp eax, 2
    jne mainGameLoop  
    
    
    cmp selectedTaxiColor, 1
    je RedObstacleRight
    sub score, 4  
    jmp mainGameLoop
RedObstacleRight:
    sub score, 2  
    jmp mainGameLoop

AfterMove:
    
    cmp difficultySelection, 1  ; Career mode
    jne ContinueAfterMove
    
    movzx eax, taxiX
    movzx ebx, taxiY
    
    ; Check if on boundary 

    movzx ecx, bl      
    mov edx, GRID_WIDTH

    imul ecx, edx
    movzx edx, al      

    add ecx, edx
    
    mov esi, OFFSET grid
    add esi, ecx

    movzx edx, byte ptr [esi]
    
    cmp edx, 0
  
    
ContinueAfterMove:
    call CheckCollisions

    jmp mainGameLoop


TryPickupOrDrop:
    cmp hasPassenger, 0
    je TryPickup

    call CheckPassengerDropoff
    
    cmp hasPassenger, 0
    jne mainGameLoop
    
  
    cmp difficultySelection, 1  ; Career mode
    je UpdateCareerDeliveries

    cmp difficultySelection, 3  ; Timed mode
    je UpdateTimedDeliveries
    jmp mainGameLoop

UpdateCareerDeliveries:

    inc careerDeliveriesMade
    mov eax, careerDeliveriesMade

    cmp eax, careerTargetDeliveries
    jge CareerModeSuccess

    jmp mainGameLoop

UpdateTimedDeliveries:

    inc timedDeliveriesMade
    mov eax, timedDeliveriesMade

    cmp eax, timedTargetDeliveries
    jge TimedModeSuccess

    jmp mainGameLoop

CareerModeSuccess:

    call DisplayGameOverScreen
    mov edx, OFFSET careerSuccessMsg

    call WriteString
    jmp WaitAndExit

TimedModeSuccess:
    call DisplayGameOverScreen

    mov edx, OFFSET timedSuccessMsg
    call WriteString

    jmp WaitAndExit

TryPickup:

    call CheckPassengerPickup
    jmp mainGameLoop

WaitAndExit:

    ; wait for the key 

    mov dh, 14
    mov dl, 25
    call Gotoxy

    mov eax, lightGreen + (black * 16)
    call SetTextColor

    mov edx, OFFSET gameOverPrompt
    call WriteString

    call ReadChar
    
ExitGameLoop:

    call UpdateLeaderboard

    call SaveLeaderboard

    ret
GameLoop ENDP


; ================================= Display Mode Info =========================
DisplayModeInfo PROC
 
    mov ecx, 3  
    mov ebx, 26 ; start at the row 

    
ClearMissionArea:
    mov dh, bl
    mov dl, 10
    call Gotoxy
    push ecx
    mov ecx, 60  ; 60 chars 

ClearLine:

    mov al, ' '
    call WriteChar

    loop ClearLine

    pop ecx
    inc ebx

    loop ClearMissionArea
    

    cmp difficultySelection, 1  ; Career mode
    je ShowCareerInfo

    cmp difficultySelection, 2  ; Endless mode
    je ShowEndlessInfo

    cmp difficultySelection, 3  ; Timed mode
    je ShowTimedInfo

    ret

ShowCareerInfo:

    mov dh, 26
    mov dl, 10
    call Gotoxy

    mov eax, lightCyan + (black * 16)
    call SetTextColor

    mov edx, OFFSET careerMissionMsg
    call WriteString
    
    mov dh, 27
    mov dl, 10
    call Gotoxy

    mov edx, OFFSET scoreMsg
    call WriteString

    mov eax, careerDeliveriesMade
    call WriteDec

    mov al, '/'
    call WriteChar

    mov eax, careerTargetDeliveries
    call WriteDec

    mov al, ' '
    call WriteChar

    mov edx, OFFSET passengerMsg
    call WriteString
    
    ; show the passenger count for the differnt modes under the gird 

    mov eax, passengersDelivered
    call WriteDec

    ret

ShowEndlessInfo:

    mov dh, 26
    mov dl, 10
    call Gotoxy

    mov eax, lightGreen + (black * 16)
    call SetTextColor

    mov edx, OFFSET endlessMsg
    call WriteString
    
    mov dh, 27
    mov dl, 10
    call Gotoxy

    mov edx, OFFSET scoreMsg
    call WriteString

    mov eax, passengersDelivered
    call WriteDec

    mov al, ' '
    call WriteChar

    mov edx, OFFSET passengerMsg
    call WriteString

    mov eax, passengersDelivered
    call WriteDec

    ret

ShowTimedInfo:

    mov dh, 26
    mov dl, 10
    call Gotoxy

    mov eax, yellow + (black * 16)
    call SetTextColor

    mov edx, OFFSET timedMissionMsg
    call WriteString
    
    mov dh, 27
    mov dl, 10
    call Gotoxy

    mov edx, OFFSET timerMsg
    call WriteString

    mov eax, timeRemaining
    call WriteDec

    mov al, 's'
    call WriteChar
    
    mov dh, 27
    mov dl, 25
    call Gotoxy

    mov edx, OFFSET scoreMsg
    call WriteString

    mov eax, timedDeliveriesMade
    call WriteDec

    mov al, '/'
    call WriteChar

    mov eax, timedTargetDeliveries
    call WriteDec

    mov al, ' '
    call WriteChar

    mov edx, OFFSET passengerMsg
    call WriteString
    
    ; Show current passenger count similarky 

    mov eax, passengersDelivered
    call WriteDec

    ret
DisplayModeInfo ENDP


; ================================= Display Game Over Screen ==================

DisplayGameOverScreen PROC

    call Clrscr
    
    ; box 

    mov eax, lightRed + (black * 16)
    call SetTextColor
    
    mov dh, 8
    mov dl, 20
    call Gotoxy

    mov edx, OFFSET borderLine
    call WriteString
    
    mov ecx, 8
    mov ebx, 9

GameOverDrawBox:

    mov dh, bl
    mov dl, 20
    call Gotoxy

    mov al, '|'
    call WriteChar
    
    mov dh, bl
    mov dl, 65
    call Gotoxy

    mov al, '|'
    call WriteChar

    inc bl
    loop GameOverDrawBox
    
    mov dh, 17
    mov dl, 20
    call Gotoxy

    mov edx, OFFSET borderLine
    call WriteString
    
    ; Display the score at the end of the game 

    mov dh, 11
    mov dl, 30
    call Gotoxy

    mov eax, yellow + (black * 16)
    call SetTextColor

    mov edx, OFFSET scoreMsg
    call WriteString

    mov eax, score
    call WriteInt
    
    ; Display message at desired psoition in the middle of the screen 

    mov dh, 12
    mov dl, 25
    call Gotoxy

    mov eax, white + (black * 16)
    call SetTextColor

    ret
DisplayGameOverScreen ENDP


; ================================= Change Game Mode ===========================

ChangeDifficulty PROC

difficultyLoop:

    call Clrscr

    mov eax, lightMagenta + (black * 16)
    call SetTextColor
    
    mov dh, 5       
    mov dl, 20      
    call Gotoxy

    mov edx, OFFSET borderLine
    call WriteString
   
    mov ecx, 10     
    mov ebx, 6      
    
difficultyDrawBox:

    mov dh, bl
    mov dl, 20
    call Gotoxy

    mov al, '|'
    call WriteChar
    
    mov dh, bl
    mov dl, 65
    call Gotoxy

    mov al, '|'
    call WriteChar
    
    inc bl
    loop difficultyDrawBox
    
    mov dh, 16     
    mov dl, 20      
    call Gotoxy

    mov edx, OFFSET borderLine
    call WriteString
    
    ; Display game mode title

    mov dh, 7       
    mov dl, 30      
    call Gotoxy

    mov eax, yellow
    call SetTextColor

    mov edx, OFFSET difficultyTitle
    call WriteString
    
    ; Display current game mode

    mov dh, 9       
    mov dl, 25      
    call Gotoxy

    mov eax, lightCyan
    call SetTextColor

    mov edx, OFFSET currentDifficultymsg
    call WriteString
    
    ; Show current game mode selection 


    cmp difficultySelection, 1
    je showCareerCurrent

    cmp difficultySelection, 2
    je showEndlessCurrent

    cmp difficultySelection, 3
    je showTimedCurrent
    
showCareerCurrent:

    mov edx, OFFSET difficulty1 + 3  
    jmp displayCurrentDone

showEndlessCurrent:

    mov edx, OFFSET difficulty2 + 3  
    jmp displayCurrentDone

showTimedCurrent:

    mov edx, OFFSET difficulty3 + 3  
    
displayCurrentDone:

    call WriteString


    mov dh, 14      
    mov dl, 22      
    call Gotoxy

    mov eax, lightGreen
    call SetTextColor

    mov edx, OFFSET difficultyPrompt
    call WriteString
    
    mov dh, 15      
    mov dl, 30      
    call Gotoxy

    mov edx, OFFSET backPrompt
    call WriteString

    ; slection counter 

    mov esi, 1
    
displayDiff1:

    mov dh, 10      
    mov dl, 25      
    call Gotoxy
    
    mov eax, difficultyCurrentSelection  
    cmp eax, esi
    jne notDiffSel1
    
    mov eax, yellow
    call SetTextColor

    mov edx, OFFSET selected
    call WriteString
    jmp afterDiffSel1
    
notDiffSel1:

    mov eax, white
    call SetTextColor

    mov edx, OFFSET notSelected
    call WriteString
    
afterDiffSel1:

    mov edx, OFFSET difficulty1
    call WriteString

    inc esi

displayDiff2:
    mov dh, 11      
    mov dl, 25      
    call Gotoxy
    
    mov eax, difficultyCurrentSelection  
    cmp eax, esi

    jne notDiffSel2
    mov eax, yellow
    call SetTextColor

    mov edx, OFFSET selected
    call WriteString
    jmp afterDiffSel2

notDiffSel2:
    mov eax, white
    call SetTextColor

    mov edx, OFFSET notSelected
    call WriteString

afterDiffSel2:
    mov edx, OFFSET difficulty2
    call WriteString

    inc esi

displayDiff3:
    mov dh, 12      
    mov dl, 25      
    call Gotoxy
    
    mov eax, difficultyCurrentSelection  
    cmp eax, esi

    jne notDiffSel3
    mov eax, yellow

    call SetTextColor

    mov edx, OFFSET selected
    call WriteString

    jmp afterDiffSel3

notDiffSel3:

    mov eax, white
    call SetTextColor

    mov edx, OFFSET notSelected
    call WriteString

afterDiffSel3:

    mov edx, OFFSET difficulty3
    call WriteString

    call ReadChar
    
    cmp al, 'w'
    je DiffMoveUp

    cmp al, 'W'
    je DiffMoveUp
    
    cmp al, 's'
    je DiffMoveDown

    cmp al, 'S'
    je DiffMoveDown
    
    cmp al, 13
    je DiffOptionSelected
    
    cmp al, 'b'
    je DiffGoBack

    cmp al, 'B'
    je DiffGoBack
    
    jmp difficultyLoop

DiffMoveUp:

    cmp difficultyCurrentSelection, 1  
    jle difficultyLoop

    dec difficultyCurrentSelection     
    jmp difficultyLoop

DiffMoveDown:

    cmp difficultyCurrentSelection, 3  
    jge difficultyLoop

    inc difficultyCurrentSelection     
    jmp difficultyLoop

DiffOptionSelected:
    
    mov eax, difficultyCurrentSelection  
    mov difficultySelection, eax

    mov dh, 17      
    mov dl, 25      
    call Gotoxy

    mov eax, lightGreen
    call SetTextColor
    
    mov edx, OFFSET difficultySetMsg
    call WriteString
    
    cmp difficultyCurrentSelection, 1  
    je setCareer

    cmp difficultyCurrentSelection, 2  
    je setEndless

    cmp difficultyCurrentSelection, 3  
    je setTimed
    
setCareer:

    mov edx, OFFSET difficulty1 + 3
    jmp showSet

setEndless:

    mov edx, OFFSET difficulty2 + 3
    jmp showSet

setTimed:

    mov edx, OFFSET difficulty3 + 3
    
showSet:

    call WriteString
    mov al, '!'
    call WriteChar
    
    mov eax, 1000
    call Delay
    
    mov eax, difficultySelection
    mov difficultyCurrentSelection, eax
    
    jmp DiffGoBack

DiffGoBack:
    mov eax, difficultySelection
    mov difficultyCurrentSelection, eax
    ret
ChangeDifficulty ENDP


; ================================= Main Menu Function ========================

MainMenu PROC
menuStart:

    call Clrscr
    
    mov eax, lightBlue + (black * 16)
    call SetTextColor
    
    mov dh, 5       
    mov dl, 20      
    call Gotoxy

    mov edx, OFFSET borderLine
    call WriteString
   
    mov ecx, 12     
    mov ebx, 6      
    
menuDrawBox:
    mov dh, bl
    mov dl, 20
    call Gotoxy

    mov al, '|'
    call WriteChar
    
    mov dh, bl
    mov dl, 65
    call Gotoxy

    mov al, '|'
    call WriteChar
    
    inc bl
    loop menuDrawBox
    
    mov dh, 18     
    mov dl, 20      
    call Gotoxy

    mov edx, OFFSET borderLine
    call WriteString
    
menuLoop:
    ; Reset currentSelection to 1 if it's out of bounds


    cmp currentSelection, 1
    jl resetSelection

    cmp currentSelection, 6  
    jg resetSelection

    jmp displayMenu
    
resetSelection:

    mov currentSelection, 1
    
displayMenu:
    mov dh, 7       
    mov dl, 35      
    call Gotoxy

    mov eax, yellow
    call SetTextColor

    mov edx, OFFSET menuTitle
    call WriteString
    
    mov dh, 16      
    mov dl, 25      
    call Gotoxy

    mov eax, lightGreen
    call SetTextColor

    mov edx, OFFSET menuPrompt
    call WriteString
    
    mov esi, 1
    
displayOption1:
    mov dh, 9       
    mov dl, 25      
    call Gotoxy
    
    mov eax, currentSelection
    cmp eax, esi
    jne notSel1
    
    ; show the selected with the yellow color 

    mov eax, yellow + (black * 16)
    call SetTextColor

    mov edx, OFFSET selected
    call WriteString

    jmp afterSel1
    
notSel1:
    
    mov eax, white + (black * 16)
    call SetTextColor

    mov edx, OFFSET notSelected
    call WriteString
    
afterSel1:

    mov edx, OFFSET menu1
    call WriteString

    inc esi

displayOption2:

    mov dh, 10      
    mov dl, 25      
    call Gotoxy
    
    mov eax, currentSelection
    cmp eax, esi
    jne notSel2

    mov eax, yellow + (black * 16)
    call SetTextColor

    mov edx, OFFSET selected
    call WriteString

    jmp afterSel2
    
notSel2:
    mov eax, white + (black * 16)
    call SetTextColor

    mov edx, OFFSET notSelected
    call WriteString
    
afterSel2:
    mov edx, OFFSET menu2
    call WriteString

    inc esi

displayOption3:
    mov dh, 11      
    mov dl, 25      
    call Gotoxy
    
    mov eax, currentSelection
    cmp eax, esi

    jne notSel3
    

    mov eax, yellow + (black * 16)
    call SetTextColor

    mov edx, OFFSET selected
    call WriteString
    jmp afterSel3
    
notSel3:

    mov eax, white + (black * 16)
    call SetTextColor

    mov edx, OFFSET notSelected
    call WriteString
    
afterSel3:
    mov edx, OFFSET menu3
    call WriteString

    inc esi

displayOption4:
    mov dh, 12      
    mov dl, 25      
    call Gotoxy
    
    mov eax, currentSelection
    cmp eax, esi
    jne notSel4
    
    
    mov eax, yellow + (black * 16)
    call SetTextColor

    mov edx, OFFSET selected
    call WriteString
    jmp afterSel4
    
notSel4:
   
    mov eax, white + (black * 16)
    call SetTextColor

    mov edx, OFFSET notSelected
    call WriteString
    
afterSel4:
    mov edx, OFFSET menu4
    call WriteString

    inc esi

displayOption5:
    mov dh, 13      
    mov dl, 25      
    call Gotoxy
    
    mov eax, currentSelection
    cmp eax, esi
    jne notSel5

    mov eax, yellow + (black * 16)
    call SetTextColor

    mov edx, OFFSET selected
    call WriteString
    jmp afterSel5
    
notSel5:

    mov eax, white + (black * 16)
    call SetTextColor

    mov edx, OFFSET notSelected
    call WriteString
    
afterSel5:

    mov edx, OFFSET menu5
    call WriteString
    inc esi

displayOption6:

    mov dh, 14      
    mov dl, 25      
    call Gotoxy
    
    mov eax, currentSelection
    cmp eax, esi

    jne notSel6

    mov eax, yellow + (black * 16)
    call SetTextColor

    mov edx, OFFSET selected
    call WriteString
    jmp afterSel6
    
notSel6:

    mov eax, white + (black * 16)
    call SetTextColor

    mov edx, OFFSET notSelected
    call WriteString
    
afterSel6:
    mov edx, OFFSET menu6
    call WriteString



    ; Get user input

    call ReadChar
    
    cmp al, 'w'
    je MoveUp

    cmp al, 'W'
    je MoveUp
    
    cmp al, 's'
    je MoveDown

    cmp al, 'S'
    je MoveDown
    
    cmp al, 13
    je OptionSelected
    
    jmp menuLoop

MoveUp:
    
    cmp currentSelection, 1
    jle menuLoop
    dec currentSelection
    
    jmp menuLoop

MoveDown:
    
    cmp currentSelection, 6 
    jge menuLoop
    inc currentSelection

    jmp menuLoop

OptionSelected:
  
    mov eax, currentSelection
    
    cmp currentSelection, 2  
    je ShowTaxiColor

    cmp currentSelection, 4  
    je ShowInstructions

    cmp currentSelection, 6  
    je ExitGame

    cmp currentSelection, 3  
    je ShowLeaderboard

    cmp currentSelection, 1  
    je StartNewGame

    cmp currentSelection, 5  
    je ShowDifficulty

ShowTaxiColor:

    call SelectTaxiColor
    jmp menuStart

ShowInstructions:

    call DisplayInstructions
    jmp menuStart

ShowLeaderboard:

    call DisplayLeaderboard
    jmp menuStart

StartNewGame:

    call GameLoop
    jmp menuStart

ShowDifficulty:

    call ChangeDifficulty
    jmp menuStart

ExitGame:

    call Clrscr
    mov dh, 10
    mov dl, 30
    call Gotoxy

    mov eax, black + (green * 16)
    call SetTextColor
    
    mov edx, OFFSET goodbyeMsg
    call WriteString
    
    mov eax, 2000
    call Delay

    ret

MainMenu ENDP


; ================================= Instructions Function ============================

DisplayInstructions PROC

instructionsLoop:

    call Clrscr

    mov eax, lightGreen + (black * 16)
    call SetTextColor
    
    mov dh, 3       
    mov dl, 15      
    call Gotoxy

    mov edx, OFFSET borderLine2
    call WriteString
   
    mov ecx, 20     
    mov ebx, 4      
    
instructionsDrawBox:

    mov dh, bl
    mov dl, 15
    call Gotoxy

    mov al, '|'
    call WriteChar
    
    mov dh, bl
    mov dl, 70
    call Gotoxy

    mov al, '|'
    call WriteChar
    
    inc bl
    loop instructionsDrawBox
    
    mov dh, 24     
    mov dl, 15      
    call Gotoxy

    mov edx, OFFSET borderLine2
    call WriteString
    
    mov dh, 5       
    mov dl, 32      
    call Gotoxy

    mov eax, yellow
    call SetTextColor

    mov edx, OFFSET instructionsTitle
    call WriteString
    
    mov eax, white
    call SetTextColor
    
    mov dh, 7       
    mov dl, 18      
    call Gotoxy

    mov edx, OFFSET instruction1
    call WriteString
    
    mov dh, 8       
    mov dl, 18      
    call Gotoxy

    mov edx, OFFSET instruction2
    call WriteString
    
    mov dh, 10      
    mov dl, 18      
    call Gotoxy

    mov edx, OFFSET instruction3
    call WriteString
    
    mov dh, 11      
    mov dl, 18      
    call Gotoxy

    mov edx, OFFSET instruction4
    call WriteString
    
    mov dh, 12      
    mov dl, 18      
    call Gotoxy

    mov edx, OFFSET instruction5
    call WriteString
    
    mov dh, 14      
    mov dl, 18      
    call Gotoxy

    mov edx, OFFSET instruction6
    call WriteString
    
    mov dh, 15      
    mov dl, 18      
    call Gotoxy

    mov edx, OFFSET instruction7
    call WriteString
    
    mov dh, 16      
    mov dl, 18  
    call gotoxy

    mov edx, OFFSET instruction8
    call WriteString
    
    mov dh, 18      
    mov dl, 18      
    call Gotoxy

    mov edx, OFFSET instruction9
    call WriteString
    
    mov dh, 19      
    mov dl, 18      
    call Gotoxy

    mov edx, OFFSET instruction10
    call WriteString
    
    mov dh, 20      
    mov dl, 18      
    call Gotoxy

    mov edx, OFFSET instruction11
    call WriteString
    
    mov dh, 22      
    mov dl, 25      
    call Gotoxy

    mov eax, lightGreen
    call SetTextColor
    mov edx, OFFSET backPrompt
    call WriteString
    
waitForB:

    call ReadChar

    cmp al, 'b'
    je goBack

    cmp al, 'B'
    je goBack

    jmp waitForB
    
goBack:
    ret

DisplayInstructions ENDP


; ================================= Load Leaderboard ==============================

LoadLeaderboard PROC

    push eax
    push ebx
    push ecx
    push edx
    push esi
    

    mov leaderboardCount, 0
    
    mov edx, OFFSET leaderboardFile
    call OpenInputFile
    
    cmp eax, INVALID_HANDLE_VALUE
    je LoadDone
    
    mov fileHandle, eax
    mov ebx, 0 
    
ReadLoop:
    cmp ebx, MAX_LEADERBOARD
    jge CloseAndExit
    
    mov eax, ebx
    mov ecx, 30
    mul ecx

    lea edx, leaderboardNames
    add edx, eax
    
    mov ecx, 30
    mov eax, fileHandle
    call ReadFromFile
    
  
    jc CloseAndExit
    cmp eax, 0
    je CloseAndExit
    
    
    mov eax, ebx
    mov ecx, 4
    mul ecx

    lea edx, leaderboardScores
    add edx, eax
    
    
    mov ecx, 4
    mov eax, fileHandle
    call ReadFromFile
    
    
    jc CloseAndExit
    cmp eax, 0

    je CloseAndExit
    

    inc ebx
    jmp ReadLoop
    
CloseAndExit:

    mov leaderboardCount, ebx
    mov eax, fileHandle

    call CloseFile
    
    ; sort the leaderboard based on the scroeds of the diff players 


    call SortLeaderboard
    
LoadDone:
    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
LoadLeaderboard ENDP


; ================================= Sort Leaderboard =============================

SortLeaderboard PROC
    pushad
    
; used the logic of the bubble sort from the lab tasks 


    mov ecx, leaderboardCount
    cmp ecx, 1
    jle SortDone  ; No need to sort if 0 or 1 players 
    
    dec ecx  
    
OuterLoop:
    mov ebx, ecx  
    mov esi, 0    
    mov edi, 0    
    
InnerLoop:
    mov eax, [leaderboardScores + esi*4]
    mov edx, [leaderboardScores + esi*4 + 4]
    
    cmp eax, edx
    jge NoSwap
  
    mov [leaderboardScores + esi*4], edx
    mov [leaderboardScores + esi*4 + 4], eax
    
   
    push esi
    push ecx
    
    mov eax, esi
    mov ecx, 30
    mul ecx

    lea edi, leaderboardNames
    add edi, eax
    
    mov eax, esi
    inc eax

    mov ecx, 30
    mul ecx

    lea esi, leaderboardNames
    add esi, eax
    
    ; Swap the names whaic are 30 bytes each 

    mov ecx, 30

SwapNames:

    mov al, [edi]
    mov ah, [esi]

    mov [edi], ah
    mov [esi], al

    inc edi
    inc esi

    loop SwapNames
    
    pop ecx
    pop esi
    mov edi, 1  
    
NoSwap:

    inc esi
    dec ebx
    jnz InnerLoop
    
    ; no swaps means the early stoping condition 

    cmp edi, 0
    je SortDone
    
    loop OuterLoop
    
SortDone:

    popad
    ret
SortLeaderboard ENDP


; ================================= Save Leaderboard ==========================

SaveLeaderboard PROC

    push eax
    push ebx
    push ecx
    push edx
    push esi
    
    call SortLeaderboard
    
    mov edx, OFFSET leaderboardFile
    call CreateOutputFile
    
    cmp eax, INVALID_HANDLE_VALUE
    je SaveDone
    
    mov fileHandle, eax
    mov ebx, 0
    
WriteLoop:

    cmp ebx, leaderboardCount
    jge CloseAndExitSave
    
    mov eax, ebx
    mov ecx, 30
    mul ecx

    lea edx, leaderboardNames
    add edx, eax
    mov ecx, 30

    mov eax, fileHandle
    call WriteToFile
    

    mov eax, ebx
    mov ecx, 4
    mul ecx

    lea edx, leaderboardScores
    add edx, eax
    mov ecx, 4

    mov eax, fileHandle
    call WriteToFile
    
    inc ebx
    jmp WriteLoop
    
CloseAndExitSave:

    mov eax, fileHandle
    call CloseFile
    
SaveDone:

    pop esi
    pop edx
    pop ecx
    pop ebx
    pop eax
    ret
SaveLeaderboard ENDP


; ================================= Update Leaderboard ==========================

UpdateLeaderboard PROC
    pushad
    

    mov eax, score
    cmp eax, 0
    jle UpdateDone
    
    ; Load curent one 

    call LoadLeaderboard
    

    mov esi, leaderboardCount  
    
    mov ecx, leaderboardCount
    mov edi, 0  
    
FindInsertPosition:

    cmp edi, ecx
    jge CheckFull
    
    mov eax, [leaderboardScores + edi*4]

    cmp score, eax
    jg FoundPosition  
    
    inc edi
    jmp FindInsertPosition

FoundPosition:
    mov esi, edi
    jmp InsertScore

CheckFull:
  
    cmp leaderboardCount, MAX_LEADERBOARD
    jl InsertScore
    

    mov eax, [leaderboardScores + (MAX_LEADERBOARD-1)*4]
    cmp score, eax
    jle UpdateDone 
    
 
    mov esi, MAX_LEADERBOARD - 1
    jmp InsertScore

InsertScore:

    cmp esi, leaderboardCount
    jne ShiftEntries

    cmp leaderboardCount, MAX_LEADERBOARD
    jge ShiftEntries

    inc leaderboardCount

ShiftEntries:
    
    mov ecx, leaderboardCount
    cmp ecx, MAX_LEADERBOARD

    jl NoTruncate

    mov ecx, MAX_LEADERBOARD - 1  
    
NoTruncate:

    mov edi, ecx

    dec edi  
    
ShiftLoop:

    cmp edi, esi
    jl CopyNewEntry
    
   
    mov eax, [leaderboardScores + edi*4]
    mov [leaderboardScores + edi*4 + 4], eax
    
    
    push esi
    push edi
    
    
    mov eax, edi
    mov ecx, 30
    mul ecx
    lea esi, leaderboardNames
    add esi, eax
    
   
    mov eax, edi
    inc eax
    mov ecx, 30
    mul ecx

    lea edi, leaderboardNames
    add edi, eax
    
   
    mov ecx, 30
    rep movsb
    
    pop edi
    pop esi
    
    dec edi
    jmp ShiftLoop

CopyNewEntry:
    
    mov eax, esi
    shl eax, 2  

    mov edx, score
    mov [leaderboardScores + eax], edx
    
    
    mov eax, esi
    mov ecx, 30
    mul ecx

    lea edi, leaderboardNames
    add edi, eax

    lea esi, playerName
    mov ecx, 30

    rep movsb

UpdateDone:
   
    call SaveLeaderboard
    popad
    ret
UpdateLeaderboard ENDP



; ================================= Display Leaderboard ==========================


DisplayLeaderboard PROC

    call LoadLeaderboard
    
    call Clrscr

    mov eax, lightCyan + (black * 16)
    call SetTextColor
    
    mov dh, 5
    mov dl, 20
    call Gotoxy

    mov edx, OFFSET borderLine
    call WriteString
    

    mov ecx, 12
    mov ebx, 6
    
DrawBox:

    mov dh, bl
    mov dl, 20
    call Gotoxy

    mov al, '|'
    call WriteChar
    
    mov dh, bl
    mov dl, 65
    call Gotoxy

    mov al, '|'
    call WriteChar

    inc bl
    loop DrawBox
    
    mov dh, 18
    mov dl, 20
    call Gotoxy

    mov edx, OFFSET borderLine
    call WriteString

    mov dh, 7
    mov dl, 30
    call Gotoxy

    mov eax, yellow
    call SetTextColor

    mov edx, OFFSET leaderboardTitle
    call WriteString
    
    cmp leaderboardCount, 0
    je NoScores
    

    mov eax, white
    call SetTextColor

    mov ebx, 0
    
DisplayLoop:

    cmp ebx, leaderboardCount
    jge DisplayBackPrompt

    cmp ebx, MAX_LEADERBOARD
    jge DisplayBackPrompt
    

    mov dh, 9
    add dh, bl
    mov dl, 22
    call Gotoxy

    mov eax, ebx
    inc eax

    call WriteDec
    mov al, '.'

    call WriteChar
    mov al, ' '

    call WriteChar
    
    
    push ebx
    mov eax, ebx
    mov ecx, 30

    mul ecx

    lea edx, leaderboardNames
    add edx, eax

    pop ebx

    call WriteString

    mov dl, 50
    call Gotoxy

    mov al, '-'
    call WriteChar

    mov al, ' '
    call WriteChar
    
    push ebx
    mov eax, ebx
    shl eax, 2  

    mov eax, [leaderboardScores + eax]
    pop ebx

    call WriteDec
    
    inc ebx
    jmp DisplayLoop

NoScores:

    mov dh, 10
    mov dl, 28
    call Gotoxy

    mov eax, lightRed
    call SetTextColor

    mov edx, OFFSET noScoresMsg
    call WriteString

DisplayBackPrompt:
    mov dh, 16
    mov dl, 30
    call Gotoxy

    mov eax, lightGreen
    call SetTextColor

    mov edx, OFFSET leaderboardPrompt
    call WriteString

WaitForBack:

    call ReadChar
    cmp al, 'b'

    je LeaderboardBack
    cmp al, 'B'

    je LeaderboardBack

    jmp WaitForBack

LeaderboardBack:
    ret
DisplayLeaderboard ENDP



; ================================= Generate Random Position =========================

GenerateRandomRoadPosition PROC

    ; used i the game loop returns the dh and the dl 

    push ebx
    push ecx
    push edx
    push esi
    push edi
    
    mov ecx, 50  
    
TryAgain:

    call Randomize
    mov eax, 20
    call RandomRange

    inc eax
    mov bl, al   
    
    call Randomize
    mov eax, 20

    call RandomRange
    inc eax
    mov bh, al   


    movzx eax, bh      
    mov edx, GRID_WIDTH
    mul edx

    movzx edx, bl      
    add eax, edx
    
    mov esi, OFFSET grid
    add esi, eax

    movzx eax, byte ptr [esi]
    
    cmp eax, 1
    jne NotRoad
    
    mov ecx, MAX_PASSENGERS
    mov edi, 0

CheckOccupied:

    cmp passengerActive[edi], 1
    jne SkipCheck
    
    movzx eax, passengerX[edi]
    cmp al, bl
    jne SkipCheck

    movzx eax, passengerY[edi]  
    cmp al, bh
    je TryAgain 
    
SkipCheck:

    inc edi
    loop CheckOccupied
   
    mov al, bl   
    mov ah, bh   
    jmp Done
    
NotRoad:
    loop TryAgain

    mov al, 2    
    mov ah, 2    
    
Done:

    pop edi
    pop esi
    pop edx
    pop ecx
    pop ebx

    ret
GenerateRandomRoadPosition ENDP

; ================================= Pause Game Function =========================

PauseGame PROC
    pushad

    call Clrscr
    
    mov eax, lightMagenta + (black * 16)
    call SetTextColor
    
    mov dh, 8
    mov dl, 25
    call Gotoxy

    mov edx, OFFSET borderLine3
    call WriteString

    mov ecx, 8
    mov ebx, 9
    
PauseDrawBox:

    mov dh, bl
    mov dl, 25
    call Gotoxy

    mov al, '|'
    call WriteChar
    
    mov dh, bl
    mov dl, 61
    call Gotoxy

    mov al, '|'
    call WriteChar

    inc bl
    loop PauseDrawBox
    
    
    mov dh, 17
    mov dl, 25
    call Gotoxy

    mov edx, OFFSET borderLine3
    call WriteString
    

    mov dh, 10
    mov dl, 35
    call Gotoxy

    mov eax, yellow + (black * 16)
    call SetTextColor

    mov edx, OFFSET pauseTitle
    call WriteString
    
    
    mov dh, 12
    mov dl, 30
    call Gotoxy

    mov eax, lightGreen + (black * 16)
    call SetTextColor

    mov edx, OFFSET pauseMsg1
    call WriteString
    
    mov dh, 13
    mov dl, 30
    call Gotoxy

    mov edx, OFFSET pauseMsg2
    call WriteString
    
    mov dh, 14
    mov dl, 30
    call Gotoxy
    mov edx, OFFSET pauseMsg3
    call WriteString
    
PauseLoop:
    
    call ReadChar
    
    cmp al, 'p'
    je ResumeGame

    cmp al, 'P'
    je ResumeGame
    
    cmp al, 27
    je ExitToMenu
    
    jmp PauseLoop

ResumeGame:
 
    popad

    mov eax, 0  
    ret

ExitToMenu:
    popad
    mov eax, 1      ; Return 1 = exit to menu
    ret

PauseGame ENDP


; ================================= Check Timed Mode =========================

CheckTimedMode PROC

    
    cmp difficultySelection, 3  
    jne NotTimedMode
    
    
    inc timerCounter

    mov eax, timerCounter
    cmp eax, 5  ; used 5 for the faster 

    jl NotTimeUp

    mov timerCounter, 0
    
    ; Decrement 

    cmp timeRemaining, 0
    jle TimeIsUp  
    
    dec timeRemaining
    
    ; Check if time has reached 0

    cmp timeRemaining, 0
    jg NotTimeUp

TimeIsUp:

    ; Time up 

    call DisplayGameOverScreen
    

    mov dh, 12
    mov dl, 25
    call Gotoxy

    mov eax, lightRed + (black * 16)
    call SetTextColor

    mov edx, OFFSET timeUpMsg

    call WriteString
    

    mov dh, 13
    mov dl, 25
    call Gotoxy

    mov eax, yellow + (black * 16)
    call SetTextColor

    mov edx, OFFSET scoreMsg
    call WriteString

    mov eax, score

    call WriteInt
    

    mov dh, 14
    mov dl, 25
    call Gotoxy

    mov edx, OFFSET passengerMsg
    call WriteString

    mov eax, timedDeliveriesMade
    call WriteDec
    mov al, '/'
    call WriteChar

    mov eax, timedTargetDeliveries
    call WriteDec
    
    
    mov dh, 16
    mov dl, 25
    call Gotoxy

    mov eax, lightGreen + (black * 16)
    call SetTextColor

    mov edx, OFFSET gameOverPrompt
    call WriteString
    
    
    call ReadChar
    
    
    call UpdateLeaderboard
    call SaveLeaderboard
    
    mov eax, 1  ; Signal for the time over 
    ret
    
NotTimedMode:

NotTimeUp:
    mov eax, 0  
    ret

CheckTimedMode ENDP

END main