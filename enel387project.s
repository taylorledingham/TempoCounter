;ENEL 387 - Design Project
;Tempo Counter
;Taylor Ledingham
;200-218-633

;Some code has been used from Dave Duguid Lab code

; Directives
                        PRESERVE8
                        THUMB
; Vector Table Mapped to Address 0 at Reset, Linker requires __Vectors to be exported

INTIAL_MSP EQU          0X20001000      ;Initalize the main stack pointer Value

;The onboard LEDs are on port A bits 8 and 9
;PORT C GPIO - Base Addr: 0x40010800
GPIOA_CRL       EQU             0X40010800              ;(0x00) Port Config. Register for Px7 -> Px0
GPIOA_CRH       EQU             0X40010804              ;(0x04) Port Config. Register for Px15 -> Px8
GPIOA_IDR       EQU             0X40010808              ;(0x08) Port Input Data Register
GPIOA_ODR       EQU             0X4001080C              ;(0x0C) Port Output Data Register
GPIOA_BSRR      EQU             0X40010810              ;(0x10) Port Bit Set/Reset Data Register
GPIOA_BRR       EQU             0X40010814              ;(0x14) Port Bit Reset Register
GPIOA_LCKR      EQU             0X40010818              ;(0x18) Port Config. Lock Register

;The onboard LEDs are on port B bits 8 and 9
;PORT C GPIO - Base Addr: 0x40010C00
GPIOB_CRL       EQU             0X40010C00              ;(0x00) Port Config. Register for Px7 -> Px0
GPIOB_CRH       EQU             0X40010C04              ;(0x04) Port Config. Register for Px15 -> Px8
GPIOB_IDR       EQU             0X40010C08              ;(0x08) Port Input Data Register
GPIOB_ODR       EQU             0X40010C0C              ;(0x0C) Port Output Data Register
GPIOB_BSRR      EQU             0X40010C10              ;(0x10) Port Bit Set/Reset Data Register
GPIOB_BRR       EQU             0X40010C14              ;(0x14) Port Bit Reset Register
GPIOB_LCKR      EQU             0X40010C18              ;(0x18) Port Config. Lock Register

;The onboard LEDs are on port C bits 8 and 9
;PORT C GPIO - Base Addr: 0x40011000
GPIOC_CRL       EQU             0X40011000              ;(0x00) Port Config. Register for Px7 -> Px0
GPIOC_CRH       EQU             0X40011004              ;(0x04) Port Config. Register for Px15 -> Px8
GPIOC_IDR       EQU             0X40011008              ;(0x08) Port Input Data Register
GPIOC_ODR       EQU             0X4001100C              ;(0x0C) Port Output Data Register
GPIOC_BSRR      EQU             0X40011010              ;(0x10) Port Bit Set/Reset Data Register
GPIOC_BRR       EQU             0X40011014              ;(0x14) Port Bit Reset Register
GPIOC_LCKR      EQU             0X40011018              ;(0x18) Port Config. Lock Register

;;LCD control Bit Patterns

LCD_8B2L        EQU                     0x38                    ;enable 8 bit data, 2 display lines
LCD_DCB         EQU                     0x0F                    ;enable display, cursor, blink
LCD_MCR         EQU                     0x06                    ;set move cursor right
LCD_CLR         EQU                     0x01                    ;home and clear LCD
LCD_LN1     	EQU                 	0x80
LCD_LN1_13      EQU                     0x90                    ;Move to line 1, pos 13
LCD_LN2         EQU                     0xC0                    ;set DDRAM to start of line 2
LCD_LN2_13      EQU                     0xD0                    ;Move to line 2, pos 13
LCD_LN3         EQU                     0x94
LCD_LN3_13      EQU                     0xA4                    ;Move to line 3, pos 13
LCD_LN4         EQU                     0xD4
LCD_LN4_13      EQU                     0xE4                    ;Move to line 4, pos 13
LCD_CM_ENA      EQU                     0x00010002              ;RS LOW, E high
LCD_CM_DIS      EQU                     0x00030000              ;RS LOW, E LOW
LCD_DM_ENA      EQU                     0x00000003              ;RS HIGH, E high
LCD_DM_DIS      EQU                     0x00020001              ;RS high, E low

;;ADC and other associated registers
ADC_SR          EQU                     0x40012400              ;ADC Status Register
ADC_CR1         EQU                     0x40012404              ;ADC Control Register 1
ADC_CR2         EQU                     0x40012408              ;ADC Control Register 2
ADC_SMPR1       EQU                     0x4001240C              ;ADC Sample time Register 1
ADC_SMPR2       EQU                     0x40012410              ;ADC Sample time Register 2
ADC_LTR         EQU                     0x40012428              ;ADC Watchdog low threshold Register
ADC_SQR1        EQU                     0x4001242C              ;ADC regular sequence Register 1
ADC_SQR2        EQU                     0x40012430              ;ADC regular sequence Register 2
ADC_SQR3        EQU                     0x40012434              ;ADC regular sequence Register 3
ADC_DR          EQU                     0x4001244C              ;ADC Data Register

;Timer 6 register addresses
;base address = 0x4000 1000
TIM6_CR1        EQU                     0x40001000              ;Timer 6 control register 1
TIM6_CR2        EQU                     0x40001004              ;Timer 6 control register 2
TIM6_SR         EQU                     0x40001010              ;Timer 6 status register
TIM6_CNT        EQU                     0x40001024              ;Timer 6 counter register
TIM6_PSC        EQU                     0x40001028              ;Timer 6 prescaler register
TIM6_ARR        EQU                     0x4000102C              ;Timer 6 auto-reload register



;Registers for configuring and enabling the clocks
;RCC Registers - Base Addr: 0x40021000
RCC_APB2ENR     EQU                 0x40021018
RCC_APB1ENR     EQU                 0x4002101C

;Times for delay routines

DELAYTIME       EQU                             16000000                ;(ABOUT 600 MS USING 8MHz clock)
DELAY1m         EQU                             30000           ;(ABOUT 1 MS USING 8MHz clock)
DELAY100u       EQU                             1500            ;(ABOUT 100 uS USING 8MHz clock)
DELAY15m        EQU                             420000  ;about 15ms
DELAY5m         EQU                             140000  ;about  5ms
DELAYTIMEL      EQU                             3000000000



                AREA RESET, Data, READONLY
                        EXPORT __Vectors
__Vectors

                DCD     INTIAL_MSP ; stack pointer value when stack is empty
                DCD     Reset_Handler ; reset vector
                DCD     nmi_ISR
                DCD     h_fault_ISR
                DCD     m_fault_ISR
                DCD     b_fault_ISR
                DCD     u_fault_ISR


                AREA MYCODE, CODE, READONLY
                        EXPORT Reset_Handler
                        ENTRY


Reset_Handler   PROC

clock_init
                                        ;Enable peripheral clocks for various ports and subsystems
                                        ;Bit 4: Port C, Bit 3: Port B, Bit 2: Port A

                LDR             R6, = RCC_APB2ENR       ;load the clock register address
                MOV             R0, #0x0021C                ;for GPIO and ADC
                STR             R0,[R6]
                
                LDR             R6, = RCC_APB1ENR       ;load the clock register address
                MOV             R0, #0x10                ;for timer 6
                STR             R0,[R6]

gpio_init

                ;set the config and move bits for Port C bit 9/8 so they will be push-pull
                ;outputs(up to 50 MHz)

                LDR             R6,=GPIOC_CRH		;initialize GPIO C Register High port 
                LDR             R0,=0x44434444          
                STR             R0,[R6]
				
                LDR             R6, = GPIOC_CRL		;initialize GPIO C Register Low ports
                LDR             R0, = 0x33333333       
                STR             R0,[R6]

                LDR             R6, = GPIOB_CRH		;initialize GPIO B Register High ports
                LDR             R0, = 0x33334444        
                STR             R0,[R6]

                LDR             R6, = GPIOB_CRL		;initialize GPIO B Register Low ports
                LDR             R0, = 0x44344433        
                STR             R0,[R6]

                LDR             R6, = GPIOA_CRL         ;initialize PA0
                LDR             R0, = 0x44444440        
                STR             R0,[R6]

                LDR             R6,=  GPIOB_BSRR
                LDR             R0,= 0x00200000
                STR             R0,[R6]

				

                ALIGN
                ENDP
				
				LTORG
				
				


main    PROC
                        BL      init_LCD                             ;initialize the LCD
                        BL      init_ADC                             ;initialize the A to D converter
                        BL      init_timer                           ;Initialize timer 6
                        BL      Reset								 ;Reset the values
						BL		output_titles						 ;output the titles on the LCD

loop
                        ;system off
                        LDR             R6,=GPIOC_IDR                           ;Get the address of the GPIO C input data register address
                        LDR             R5,[R6]                                 ;Get the value stored at that address
                        ands            R5,#0x00000100                          ; check if system off switch is open
                        CMP             R5,#0x00                                ; if not high branch to SystemOff
                        BEQ             SystemOff

                       
                        ;switch register sw2
                        LDR             R6,=GPIOB_IDR
                        LDR             R5,[R6]
                        ands            R5,#0x00000100                          ; check reset button is pressed
                        CMP             R5,#0x00                                        ; if pressed branch to reset
                        BEQ             Reset


                       BL              outputValues		;branch with link register to output the values

                        ; ;check to see if touchpad has been touched

						 
						BL                      read_ADC                ;read the value in the ADC

                       CMP                     R0,#0xFA0				;if the value is less than FA0 then
                       BLE                     isTouched				;that means the touch pad has been touched
																		;branch to isTouched
  
                        b                       loop					;keep looping

;When the touchpad is tapped get the time of the tap and calculate the BPM
isTouched
                                BL		     get_time
                                BL                   calcBPM
				   
				   
				
                                b	loop		;return to main loop
                        

                        ALIGN
                        ENDP
						
						LTORG


Avg                     DCB "Average BPM:", 00
Last                    DCB "Last BPM Value:", 00
Taps                    DCB "Number of Taps:",00
SOff                    DCB "      SYSTEM OFF", 00
calc                    DCB "Calculating.....", 00
done			DCB "    Done  ", 00

                        ALIGN
		
			

SystemOff       PROC



                        LDR                     R0, = LCD_CLR		;clear the LCD screen
                        BL                      cmd2lcd

                        LDR                     R0, =LCD_LN1		;go to line 1 of the LCD screen
                        BL                      cmd2lcd

                        ;output off
                        LDR R2,=SOff					;output "SYSTEM OFF" tp LCD screen
                        BL Puts

                        ;LDR R2,=Spaces
                        ;BL Puts


StillOff

                                        ;check if still off
                        LDR             R6,=GPIOC_IDR
                        LDR             R5,[R6]
                        ands            R5,#0x00000100                 ; check PC8 if high
                        CMP             R5,#0x00                       ; if high go to clear_our
                        BNE             clear_out									
                        B               StillOff    ;if not high loop in stillOff till the switch is flipped	

clear_out
                        bl		output_titles		;output the titles
                        B               loop					;return to main loop
                        


                        ALIGN
                        ENDP
						

		

Reset           PROC

                        LDR             R6, = TAP_COUNT
                        MOV             R5, #0x0000             ;reset the tap count to zero
                        STR             R5,[R6]

                        LDR             R6, = LAST_BPM
                        MOV             R5, #0x00000000         ;reset the last BPM to zero
                        STR             R5,[R6]

                        LDR             R6, = AVG_BPM
                        MOV             R5, #0x00000000         ;reset the average BPM to zero
                        STR             R5,[R6]

                        LDR             R6, = START_TIME
                        MOV             R5, #0x00000000         ;reset the start time to zero
                        STR             R5,[R6]

                        LDR             R6, = PREV_TIME
                        MOV             R5, #0x00000000         ;reset the previous time to zero
                        STR             R5,[R6]

                        LDR             R6, = FIRST_TIME
                        MOV             R5, #0x00000000         ;reset the first time to zero
                        STR             R5,[R6]
						
                        LDR             R6, = TIM6_CR2
                        MOV             R5, #0x000              ;reset the counter enable signal
                        STR             R5,[R6]
                        
                        LDR             R6, = TIM6_CR2
                        MOV             R5, #0x001              ;enable the counter enable signal
                        STR             R5,[R6]
                        
                        LDR             R6, = TIM6_PSC			;initialize the timer pre scaler value           
                        MOV             R5, #0xFFFFFFF          
                        STR             R5,[R6]

                        LDR             R6, = TIM6_ARR			;initialize the auto reload register 
                        MOV             R5, #0xFFFF          
                        STR             R5,[R6]
                        
                                                        
                        LDR             R6, = DIFF_TIME
                        MOV             R5, #0x00000000         ;reset the first time to zero
                        STR             R5, [R6]

                        LDR             R6, = PREV_COUNT
                        MOV             R5, #0x00000000         ;reset the first time to zero
                        STR             R5, [R6]
                        


                        LDR             R6, = COUNT_TIME
                        MOV             R5, #0x00000000         ;reset the first time to zero
                        STR             R5, [R6]

                        bl		output_titles		;output the titles to the LCD

                        b		loop				;return to main loop

						

                        ALIGN
                        ENDP
						
						LTORG
						
;this procedure will initialize the LCD screen so it can output values
init_LCD        PROC

                PUSH {LR}
                ldr            R1, = DELAY15m
                bl             delay

                LDR     		R6, = GPIOB_BSRR
                LDR             R0, = LCD_CM_DIS
                STR             R0,[R6]

                LDR     		R0, = LCD_8B2L
                bl              cmd2lcd

                ldr             R1, = DELAY15m
                bl              delay

                LDR     		R0, = LCD_8B2L
                bl              cmd2lcd

                ldr             R1, = DELAY15m
                bl              delay

                LDR     		R0, = LCD_8B2L
                bl              cmd2lcd

                ldr             R1, = DELAY15m
                bl              delay

                LDR     		R0, = LCD_8B2L
                bl              cmd2lcd

                ldr             R1, = DELAY15m
                bl              delay

                LDR     		R0, = LCD_DCB
                bl              cmd2lcd

                ldr             R1, = DELAY15m
                bl              delay

                LDR     		R0, = LCD_CLR
                bl              cmd2lcd

                ldr             R1, = DELAY15m
                bl              delay


                LDR             R0, = 0x06
                bl              cmd2lcd

                ldr             R1, = DELAY15m
                bl              delay



                POP{PC}

                        ALIGN
                        ENDP

;this procedure initializes  timer 6
init_timer      PROC


                LDR             R6, = TIM6_CR1
                MOV             R5, #0x01               ;turn on the first bit to enable the timer
                STR             R5,[R6]

                LDR             R6, = TIM6_CR2
                MOV             R5, #0x001              ;enable the counter enable signal
                STR             R5,[R6]

                LDR             R6, = TIM6_PSC			;initialize the timer pre scaler value           
                MOV             R5, #0xFFFFFFF           
				STR             R5,[R6]

                LDR             R6, = TIM6_ARR			;initialize the auto reload register 
                MOV             R5, #0xFFFF           
                STR             R5,[R6]

                BX              LR
                
                        ALIGN
                        ENDP

get_time        PROC
;This procedure gets the timer count in Timer 6 and sets it to START_TIME
;It also keeps track of how many times it rolls back to zero and increments COUNT_TIME
;by the Auto reload register (FFF) every time the timer rolls back to zero

                PUSH {LR}

                LDR             R6, = TIM6_CNT			;get the time in the timer counter register
                LDR             R9, [R6]

                LDR             R6, = START_TIME		;get the time in START_TIME
                LDR             R5, [R6]
                                        
                LDR             R6, = PREV_TIME		    ;get the time in START_TIME	
                LDR             R8, [R6]
                                        
                LDR             R6, = PREV_COUNT       ;get the time that was in PREV_COUNT
                LDR             R4, [R6]	;PREV_COUNT is the last time that was in TIM6_CNT
                
                LDR             R6, = COUNT_TIME      ;get the time in COUNT_TIME
                LDR             R11, [R6]
                
                
                MOV				R0, #0xFFFF 		;Auto Reload Register Value
                MOV				R2, #0x00			;Clear the register
                MOV				R3, #0x00			;Clear the register
                
                CMP				R9, R4				;Is the value in TIM6_CNT less than the previous value is
                                                                                        ;TIM6_CNT?
                
                IT		LE
                BLE		lessthan   ;if it's less than then that means the timer has rolled back
                                           ;to zero so branch to less than
                
                
                CMP		R9, R4	 ;Is the value in TIM6_CNT greater than the previous value in
                                        ;TIM6_CNT?
IT				GT
BGT				biggerthan			;if true, branch to biggerthan

lessthan
                ADD				R11, R11, R0	;Increment the COUNT_TIME value by the ARR

                SUB				R1, R11, R8	;subtract the COUNT_TIME value by PREV_TIME and store in R1
                ADD				R3, R9, R1	;Add R1 to the  TIM6_CNT value and store in R3

                ADD				R2, R5, R3	;Add R5 (START_TIME) to R3 and store in R2

                b				exit_time			;exit the procedure

biggerthan
                ADD				R2, R11, R9		;If the timer hasn't rolled back than 
                                                ;just add the TIM6_CNT value to the total time (START_TIME)

                b				exit_time

exit_time
						
                LDR             R6, = PREV_COUNT	;store the current TIM6_CNT value to PREV_COUNT
                STR             R9, [R6]
                                        
                LDR             R6, = START_TIME		;set R2 to the start time 
                STR             R2, [R6]
                                        
                LDR             R6, = COUNT_TIME		;keep track of the amount ot increment the time 
                STR             R11, [R6]				;each time its rolls back to zero


                POP {PC}

                ALIGN
                ENDP


init_ADC        PROC


                LDR             R6, = ADC_CR2
                MOV             R5, #0x01               ;turn on the first bit
                STR             R5,[R6]


                LDR             R6, = ADC_SMPR2		
                MOV             R5, #0x00000007
                STR             R5, [R6]


                LDR             R6, = ADC_SQR3
                MOV             R5, #0x00             ;channel 0
                STR             R5, [R6]


                bx              LR

                ALIGN
                ENDP
                
                

read_ADC        PROC

                LDR                 R6, = ADC_CR2
                MOV             R0, #0x01
                STR             R0,[R6]

checkSR

                ;Look at value SR check EOC, until high
                 LDR            R6, = ADC_SR
                 LDR            R0, [R6]                        ;load value stored in address R6 to register R0
                 AND            R7, R0, #0x00000002     ; and R0 to check wheter EOC is high, and store in R7
                 CMP            R7,#0x00000002
                 BNE            checkSR

                ;read value from DR
                LDR     R6, = ADC_DR
                LDR     R0, [R6]                        ;load value stored in address R6 to register R0

                BX              LR

                ALIGN
                ENDP




calcBPM         PROC

                 push {LR}
				 
		;;R0 = tap count
                 ; ;R1 = firstTime
                 ; ;R9 = prevTime
                 ; ;R3 = startTime
                 ; ;R4 = AvgBPM
                 ; ;R5 = lastBPM

				;Load all the values into registers to calculate BPM 
                LDR     R6, = TAP_COUNT
                LDR             R0, [R6]

                LDR     R6, = FIRST_TIME
                LDR             R1, [R6]

                LDR     R6, = PREV_TIME
                LDR             R9, [R6]

                LDR     R6, = START_TIME
                LDR             R3, [R6]

                LDR     R6, = AVG_BPM
                LDR             R4, [R6]

                LDR     R6, = LAST_BPM
                LDR             R5, [R6]
				
				LDR             R6, = DIFF_TIME
                LDR             R10, [R6]

				
				

                CMP R0, #0x00                   ;compare count to zero
                BEQ     countIsZero

                CMP R0, #0x00                   ;compare count to zero
                IT      GT                       ;if count is greater than zero
                BGT countIsntZero               ;branch to countisntzero


countIsZero
                MOV R1, R3                      ;if equal, set the first time (R1) to the start time (R2)
                MOV R0, #0x1                    ;if equal, set the count (R0) to 1
                b       store_values

countIsntZero
				
                MOV R8, #0x2710		;10000 decimal			
				
          
		SUB R10, R3, R1          ;subtract first time from start time

                MOV R5, R4               ; set LastBPM (R5) to AvgBPM (R4)
                MUL R6, R0, R8          ;multiply the count by 1000
                UDIV R4, R6, R10         ;divide R6 by R10 and store it into R4
				
                ADD R0, #0x1            ;if not equal, increment the count (R0) by 1
                
                
                ;this makes the result more accurate
                MOV R8, #0x22
                MOV R7, #0x14
                
                CMP R4, #0x64		;if the BPM is less than 100, subtract 20
                ITE  LE				;if the BPM is greater than 100, subtract 34
                SUBLE R4, R4, R7
                SUBGT R4, R4, R8
                

                 b       store_values
			
	

store_values
;Store the values into the memory addresses
                MOV 	R9, R3                      ;set prevTime to start time

	
                LDR     R6, = TAP_COUNT
                STR             R0, [R6]

                LDR     R6, = FIRST_TIME
                STR             R1, [R6]
				
		LDR      R6, = DIFF_TIME
                STR      R10, [R6]

                LDR     R6, = PREV_TIME
                STR             R9, [R6]

                LDR     R6, = START_TIME
                STR             R3, [R6]

                LDR     R6, = AVG_BPM
                STR             R4, [R6]

                LDR     R6, = LAST_BPM
                STR             R5, [R6]
				


                BL outputValues

                        POP{PC}

                        ALIGN
                        ENDP

;this routine output just the titles onto the LCD
output_titles			PROC

                        push {LR}
						
                        LDR     R0, = LCD_CLR
                        BL      cmd2lcd

                        LDR R0, = LCD_LN1
                        bl      cmd2lcd

                        LDR R2,=Avg
                        BL Puts


                        LDR R0, = LCD_LN2
                        bl      cmd2lcd

                        LDR R2,= Last
                        BL Puts


                        LDR R0, = LCD_LN3
                        bl      cmd2lcd

                        LDR R2,= Taps
                        BL Puts
						
						POP{PC}

                        ALIGN
                        ENDP

;This procedure outputs the tap count, average BPM, and last BPM value on line 1,2,3, position 13
outputValues            PROC

                        push {LR} 
						


                        LDR     R0, = LCD_LN1_13		;go to line 1, position 13
                        BL      cmd2lcd


                        LDR     R6, = AVG_BPM           ;output the avergae BPM to the screen
                        LDR     R0, [R6]                ;load value stored in address R6 to register R0

                        BL PutDec


                        LDR     R0, =LCD_LN2_13			;go to line 2, position 13
						;LDR R0, = LCD_LN2
                        BL      cmd2lcd

                        LDR     R6, = LAST_BPM          ;output the last BPM to the screen
                        LDR     R0, [R6]                ;load value stored in address R6 to register R0
   
                        BL PutDec

                        LDR     R0, =LCD_LN3_13			;;go to line 3, position 13
                                                                ;LDR R0, = LCD_LN3
                        BL      cmd2lcd

                        LDR     R6, = TAP_COUNT             ;output the number of taps to the screen
                        LDR      R0, [R6]                   ;load value stored in address R6 to register R0

                        BL PutDec

                        
                        pop {PC}


                        ALIGN
                        ENDP



PutDec                PROC
;Output register value in decimal format
;Input R0 = value to be displayed
;This procedure is taken from the ARM cortex reference manual
                PUSH        {R0-R5, LR}
                
                MOV            R3, SP
                ;Save register value to R3 because R0 is used
                
                SUB            SP, SP, #12
                MOV            R1, #0
                STRB        	R1, [R3, #-1]!
                MOV            R5, #10
				


PutDecLoop

                UDIV           R4, R0, R5        ;R4 =R0/10
                MUL            R1, R4, R5
                SUB            R2, R0, R1
                ADD            R2, #48
                STRB           R2, [R3, #-1]!
                
                MOVS        R0, R4
                ;if R4=0
                BNE            PutDecLoop
                
                MOV            R0, R3
                
                BL             PutS
                
                ADD            SP, SP, #12
                
                POP            {R0-R5, PC}

                ALIGN
                ENDP
				
PutS
;This procedure is taken from the ARM cortex reference manual
                PUSH{R0-R6,LR}
				MOV R1, R0


putSLoop
                LDRB R0,[R1],#1
                CBZ R0,PutSExitLoop

                BL data2lcd
                b putSLoop

PutSExitLoop
                POP{R0-R6,PC}

;------------------------------write to screen------------------
Puts
                PUSH{R0-R6,LR}




OutputLoop
                LDRB R0,[R2],#1
                CBZ R0,ExitLoop

                BL data2lcd
                b OutputLoop

ExitLoop
                POP{R0-R6,PC}
;-------------------------------------------------------------------

cmd2lcd  PROC ;; this routine holds RS low, and toggles E high and low, 
;presents data from R0, to LCD data lines

                push {R0,R1,R6,LR}

                ldr     		R6, = GPIOB_BSRR
                ldr             R0, = LCD_CM_ENA
                str             R0,[R6]

                ldr             R1, = DELAY100u
                bl              delay

                pop             {R0}
                ldr             R6, = GPIOC_ODR
                str             R0,[R6]

                ldr             R1, = DELAY100u
                bl              delay

                ldr             R6, = GPIOB_BSRR
                ldr             R0, = LCD_CM_DIS
                str             R0,[R6]

                ldr             R1,= DELAY1m
                bl              delay

                pop             {R1, R6, PC}


                ALIGN
                ENDP

data2lcd         PROC ;; this routine holds RS low, and toggles E high and low, 
;presents data from R0, to LCD data lines

                push {R0,R1,R6,LR}

                ldr             R6, = GPIOB_BSRR
                ldr             R0, = LCD_DM_ENA
                str             R0,[R6]

                pop             {R0}
                ldr             R6, = GPIOC_ODR
                str             R0,[R6]

                ldr             R1, = DELAY100u
                bl              delay
 
                ldr             R6, = GPIOB_BSRR
                ldr             R0, = LCD_DM_DIS
                str             R0,[R6]

                ldr             R1,= DELAY1m
                bl              delay

                pop             {R1, R6, PC}


                ALIGN
                ENDP

delay           PROC

                subs    R1,#1
                bne             delay
                bx              LR

                ALIGN
                ENDP

Exit            
                B Exit

                ALIGN
                
        
                
        AREA    HANDLERS, CODE, READONLY
        ;Default handlers for NMI and faults

nmi_ISR
                        b       .
u_fault_ISR
                        b        .
h_fault_ISR
                        b         .
m_fault_ISR
                        b          .
b_fault_ISR
                        b          .
                        
                        ALIGN
                        
        AREA    VARIABLES, DATA, READWRITE                        

;Data Structure for the Tap count, Average BPM, Last BPM, Time, Previous Time
TAP_COUNT       SPACE    4			;number of times the user taps the touch pad
AVG_BPM         SPACE    4			;The average Beats per Minute
LAST_BPM        SPACE    4			;The last BPM value
START_TIME      SPACE    8			;The total time of the running timer
PREV_TIME       SPACE    8			;Previous total time
FIRST_TIME      SPACE    4			;The time the user first taps
DIFF_TIME	SPACE    4                      ;The difference between start and previous time
PREV_COUNT	SPACE	 4                      ;the previous value in timer 6 count register
COUNT_TIME	SPACE	 8                      ;this variable is incremented by the auto reload
                                                ;register of timer 6 everytime the timer rolls back to zero

                END


