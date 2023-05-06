encrypt:
    mov r6, #0 ;Op selector
    mov r7, #8 ; msg start
    mov r8, #0 ; set espace for public key exp

encrypt_loop:
    nop
    nop
    ldr r3, [r7]
    nop
    nop
    nop
    ldr r4, [r8]
    ldr r5, [r8, #4]
    jmp exp
encrypt_store:
    str r1, [r7]
    cmp r7, #404 ; Limit msg mem space
    nop
    nop
    nop
    jeq finish
    add r7, r7, #4
    jmp encrypt_loop

exp:
    mov r1, #1 ; Op result
    mov r2, #0 ; Iter counter
exp_loop:
    cmp r3, #0
    jeq zero_except
    nop
    nop
    nop
    cmp r2, r4
    nop
    nop
    nop
    jeq exp_return
    nop
    nop
    nop
    mul r1, r1, r3
    jmp mod
exp_add:
    add r2, r2, #1
    jmp exp_loop
mod:
    nop
    nop
    nop
    cmp r1, r5
    nop
    nop
    nop
    jlt exp_add
    nop
    nop
    nop
    sub r1, r1, r5
    jmp mod
exp_return:
    cmp r6, #0
    nop
    nop
    nop
    jeq encrypt_store
zero_except:
    mov r1, r3
    nop
    nop
    jmp encrypt_store

finish:
	com

	mov r1,#0
	mov r0, #8
	NOP
	NOP
	NOP

loop:

	cmp		r1, #100
	NOP
	NOP
	NOP
	jeq		fin2
	LDR		r2,[r0]
	ADD		r1, r1, #1
	ADD		r0, r0, #4
	NOP
	NOP
	NOP
	JMP		loop

fin2:

	NOP
	NOP
	NOP
	END