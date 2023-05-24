_start:
	nop
	nop
	nop
	nop
	nop
	ldr ra1, [RA5]
	ldr ra2, [RA5, #4]
	ldr ra3, [RA5, #8]
	nop
	nop
	nop

loop:
	ldr rv1, [ra1, #4] @ load vector
	nop
	nop
	nop
	str rv1, [ra3, #4] @ store vector + advance pointer
	str rv1, [ra1, #4] @ sobreescribir input + advance pointer

	cmp ra2, ra1 @ Revisar si terminó
	nop
	nop
	nop
	jeq finish
	jmp loop

finish:
	END
