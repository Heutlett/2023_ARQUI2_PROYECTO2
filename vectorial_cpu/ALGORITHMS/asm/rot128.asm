; Encriptar y desencriptar imagen usando sumas de 128

; RA5: Registro que tiene dirección donde se encuentran las direcciones de INPUT,
; VGA y final de VGA. 

; RX: registro que contiene el estado del switch que controla
; si mantenerse pausado después de encriptar o si continúa desencriptando
;
; Asumo RX==0: pausa
;       RX==1: continuar

_start:
	xorv rv3, rv3, rv3 ; Asegurar 0
	movs rs2, #128
	adds rv3, rv3, rs2 ; Cargar 128 en rv3

encrypt:
	ldrv ra1, [RA5]
	ldrv ra2, [RA5, #4]
	ldrv ra3, [RA5, #8]

encrypt_loop:
	ldrv rv1, [ra1, #4] ; load vector
	addv rv2, rv1, rv3; ROT128
	strv rv2, [ra2, #4] ; store vector + advance pointer
	strv rv2, [ra1, #4] ; sobreescribir input + advance pointer

	cmpv ra2, ra3 ; Revisar si terminó
	jeq pause_loop
	jmp encrypt_loop

pause_loop:
	cmps RX, #1 ; Revisar si switch de continuar se activa
	jeq decrypt
	jmp pause_loop

decrypt:
	; Resetear direcciones
	ldrv ra1, [RA5]
	ldrv ra2, [RA5, #4]
	ldrv ra3, [RA5, #8]

decrypt_loop:
	ldrv rv1, [ra1, #4] ; load vector
	addv rv2, rv1, rv3; ROT128
	strv rv2, [ra2, #4] ; store vector + advance pointer
	strv rv2, [ra1, #4] ; sobreescribir input + advance pointer

	cmpv ra2, ra3
	jeq finish
	jmp decrypt_loop

finish:
	END
