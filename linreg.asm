.MODEL SMALL
.STACK 100h
.DATA
    X DW 2015, 2016, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024
    Y DW 76, 80, 83, 92, 101, 91, 111, 132, 136, 137
    ; Y DW 7664, 8014, 8398, 9251, 10131, 9119, 11115, 13221, 13663, 13752
    n DW 10
    x_mean DW ?
    y_mean DW ?
    num DW 0
    den DW 0
    slope DW ?
    intercept DW ?
    x_pred_input DB 10, 0, 11 DUP("$")
    x_pred DW ?
    y_pred DW ?
    ferrari_title DB "Ferrari Data Linear Regression",10,"$"    
    divider DB "------------------------------",10,"$"
    xmean_msg DB "Mean of X: ", "$"
    ymean_msg DB "Mean of Y: ", "$"
    slope_msg DB "Slope (m): ", "$"
    intercept_msg DB "Intercept (b): ", "$"
    x_pred_msg DB "Enter a year to predict Ferrari sales: $"
    ypred_msg DB "Predicted Ferrari sales (in hundreds) = ", "$"
    nl DB 10, "$"
    overflow_msg DB "Overflow", 10 ,"Exiting$"
    ten DB 10
.CODE
main PROC
    MOV AX, @DATA
    MOV DS, AX

    MOV AH, 09h
    MOV DX, OFFSET ferrari_title
    INT 21h
    MOV DX, OFFSET divider
    INT 21h

    MOV DX, OFFSET xmean_msg
    INT 21h
    MOV SI, OFFSET X
    CALL n_mean
    MOV x_mean, AX
    CALL display_integer
    CALL newline

    MOV DX, OFFSET ymean_msg
    INT 21h
    MOV SI, OFFSET Y
    CALL n_mean
    MOV y_mean, AX
    CALL display_integer
    CALL newline

    MOV DX, OFFSET slope_msg
    INT 21h
    MOV SI, OFFSET X
    MOV DI, OFFSET Y
    MOV CX, [n]
    NUM_LOOP:
        MOV AX, [SI]
        SUB AX, x_mean
        JO OVERFLOW_EXIT
        MOV BX, AX
        MOV DX, [DI]
        SUB DX, y_mean
        JO OVERFLOW_EXIT
        MOV AX, BX
        IMUL DX
        JO OVERFLOW_EXIT
        ADD num, AX
        JO OVERFLOW_EXIT
        MOV AX, BX
        IMUL BX
        JO OVERFLOW_EXIT
        ADD den, AX
        JO OVERFLOW_EXIT
        ADD SI, 2
        ADD DI, 2
        LOOP NUM_LOOP

    MOV AX, num
    IDIV den
    MOV slope, AX
    CALL display_integer
    CALL newline

    MOV DX, OFFSET intercept_msg
    INT 21h
    MOV AX, x_mean
    IMUL slope
    JO  OVERFLOW_EXIT
    MOV BX, AX
    MOV AX, y_mean
    SUB AX, BX
    JO  OVERFLOW_EXIT
    MOV intercept, AX
    CALL display_integer
    CALL newline

    JMP BYPASS_OVERFLOW
    OVERFLOW_EXIT:
        MOV AH, 09h
        MOV DX, OFFSET overflow_msg
        INT 21h
        MOV AX, 4C01h
        INT 21h
    BYPASS_OVERFLOW:

    MOV DX, OFFSET x_pred_msg
    INT 21h
    MOV DX, OFFSET x_pred_input
	MOV AH, 0Ah
	INT 21h
    CALL to_integer
    MOV x_pred, AX

    CALL newline
    MOV DX, OFFSET ypred_msg
    INT 21h
    MOV AX, x_pred
    IMUL slope
    JO  OVERFLOW_EXIT
    ADD AX, intercept
    JO  OVERFLOW_EXIT
    MOV y_pred, AX
    CALL display_integer
    CALL newline

    MOV AX, 4C00h
    INT 21h
main ENDP

n_mean PROC
    MOV AX, 0
    MOV CX, n
    N_SUM:
        ADD AX, [SI]
        JO  OVERFLOW_EXIT
        ADD SI, 2
        LOOP N_SUM
    MOV DX, 0
    MOV BX, n
    IDIV BX
    RET
n_mean ENDP

newline PROC
    MOV AH, 09h
    MOV DX, OFFSET nl
    INT 21h
    RET
newline ENDP

to_integer PROC
	MOV SI, offset x_pred_input[2]
	MOV CL, x_pred_input[1]
	MOV CH, 0
	MOV AX, 0
	TO_INT: 
		MOV BL, [SI]
		SUB BL, 30h
		MOV BH, 0
		MUL ten
		ADD AX, BX
		INC SI
		loop TO_INT
	RET
to_integer ENDP

display_integer proc
    MOV CX, 0
    CMP AX,0
    JGE NO_NEG
    PUSH AX
    MOV DX, "-"
    MOV AH, 02h
    INT 21h
    POP AX
    NEG AX
    NO_NEG:
    FETCH_DIGITS:
        MOV DX, 0
        MOV BX, 10
        DIV BX
        ADD DL, 30h
        PUSH DX
        INC CX
        CMP AX, 0
        JNE FETCH_DIGITS
    PRINT_DIGITS:
        POP DX
        MOV AH, 02h
        INT 21h
        loop PRINT_DIGITS
	RET
display_integer endp
END main