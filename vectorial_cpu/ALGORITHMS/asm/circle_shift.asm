; Encriptar y desencriptar imagen usando un circular shift de #KEY posiciones

; Constantes a modificar:
; #KEY = cantidad de shifts necesarios (debe ser menor a 8)

; RA5: Registro que tiene dirección donde se encuentran las direcciones de INPUT,
; VGA y final de VGA. 

; RX: registro que contiene el estado del switch que controla
; si mantenerse pausado después de encriptar o si continúa desencriptando
;
; Asumo RX==0: pausa
;       RX==1: continuar

_start:
	xorv rv3, rv3, rv3 ; Asegurar 0
	movs rs1, #KEY		 ; Cargar llave
	movs rs2, #8
	adds rv3, rv3, rs2 ; Cargar 8 en rv3

encrypt:
	ldrv ra1, [RA5]
	ldrv ra2, [RA5, #4]
	ldrv ra3, [RA5, #8]

encrypt_loop:
	ldrv rv1, [ra1, #4] ; load vector
	jmp circular_right_shift ; apply circular shift
	circular_right_shift_return:
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
	jmp circular_left_shift ; apply circular shift
	circular_left_shift_return:
	strv rv2, [ra2, #4] ; store vector + advance pointer
	strv rv2, [ra1, #4] ; sobreescribir input + advance pointer

	cmpv ra2, ra3
	jeq finish
	jmp decrypt_loop

finish:
	END


; PARAM: rv1 -> vector a aplicar shift
; PARAM: rs1 -> #KEY
; PARAM: rv3 -> vector que traiga 8 cargado
; RETURN: rv2 -> vector con shift aplicado
; Modifica registros rv2, rv4, rv7, rv8
circular_right_shift:

	subs rv4, rv3, rs1
	
	shrs rv8, rv1, rs1
	shlv rv7, rv1, rv4

	orv rv2, rv8, rv7

	jmp circular_right_shift_return

; PARAM: rv1 -> vector a aplicar shift
; PARAM: rs1 -> #KEY
; PARAM: rv3 -> vector que traiga 8 cargado
; RETURN: rv2 -> vector con shift aplicado
; Modifica registros rv2, rv4, rv7, rv8
circular_left_shift:

	subs rv4, rv3, rs1
	
	shls rv8, rv1, rs1
	shrv rv7, rv1, rv4

	orv rv2, rv8, rv7

	jmp circular_left_shift_return
