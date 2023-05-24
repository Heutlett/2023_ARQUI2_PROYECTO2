; Encriptar y desencriptar imagen generando una llave usando CHACHA y aplicándola con XOR

; Constantes a modificar:
; #KEY_A = Llave A
; #KEY_B = Llave B
; #KEY_C = Llave C
; #KEY_D = Llave D

; RA5: Registro que tiene dirección donde se encuentran las direcciones de INPUT,
; VGA y final de VGA. 

; RX: registro que contiene el estado del switch que controla
; si mantenerse pausado después de encriptar o si continúa desencriptando
;
; Asumo RX==0: pausa
;       RX==1: continuar

_start:
	; Asegurar registros son 0
	xorv rv7, rv7, rv7
	xorv rv8, rv8, rv8
	xorv rv9, rv9, rv9
	xorv rv10, rv10, rv10

	; Cargar llaves iniciales en registros vectoriales
	movs rs1, #KEY_A
	movs rs2, #KEY_B
	movs rs3, #KEY_C
	movs rs4, #KEY_D

	adds rv7, rv7, rs1   #KEY_A
	adds rv8, rv8, rs2   #KEY_B
	adds rv9, rv9, rs3   #KEY_C
	adds rv10, rv10, rs4 #KEY_D

	; Cargar valores que se van a usar en shifts
	movs rs1, #1
	movs rs2, #2
	movs rs3, #3
	movs rs4, #4

	; Combinar llaves
	addv rv7, rv7, rv8
	xorv rv10, rv7, rv10
	shls rv10, rv10, rs4
	addv rv9, rv9, rv10
	xorv rv8, rv8, rv9
	shls rv8, rv8, rs3
	addv rv7, rv7, rv8
	xorv rv10, rv7, rv10
	shls rv10, rv10, rs2
	addv rv9, rv9, rv10
	xorv rv8, rv8, rv9
	shls rv8, rv8, rs1

encrypt:
	ldrv ra1, [RA5]
	ldrv ra2, [RA5, #4]
	ldrv ra3, [RA5, #8]

encrypt_loop:
; Hace 4 vectores por iteración

	ldrv rv1, [ra1, #4] ; load vector
	xorv rv2, rv1, rv7  ; XOR
	strv rv2, [ra2, #4] ; store vector + advance pointer
	strv rv2, [ra1, #4] ; sobreescribir input + advance pointer

	ldrv rv1, [ra1, #4] ; load vector
	xorv rv2, rv1, rv8  ; XOR
	strv rv2, [ra2, #4] ; store vector + advance pointer
	strv rv2, [ra1, #4] ; sobreescribir input + advance pointer

	ldrv rv1, [ra1, #4] ; load vector
	xorv rv2, rv1, rv9  ; XOR
	strv rv2, [ra2, #4] ; store vector + advance pointer
	strv rv2, [ra1, #4] ; sobreescribir input + advance pointer

	ldrv rv1, [ra1, #4] ; load vector
	xorv rv2, rv1, rv10 ; XOR
	strv rv2, [ra2, #4] ; store vector + advance pointer
	strv rv2, [ra1, #4] ; sobreescribir input + advance pointer

	cmpv ra3, ra2 ; Revisar si ra2 (VGA actual) > ra3 (VGA end)
	jlt pause_loop
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
	xorv rv2, rv1, rv7  ; XOR
	strv rv2, [ra2, #4] ; store vector + advance pointer
	strv rv2, [ra1, #4] ; sobreescribir input + advance pointer

	ldrv rv1, [ra1, #4] ; load vector
	xorv rv2, rv1, rv8  ; XOR
	strv rv2, [ra2, #4] ; store vector + advance pointer
	strv rv2, [ra1, #4] ; sobreescribir input + advance pointer

	ldrv rv1, [ra1, #4] ; load vector
	xorv rv2, rv1, rv9  ; XOR
	strv rv2, [ra2, #4] ; store vector + advance pointer
	strv rv2, [ra1, #4] ; sobreescribir input + advance pointer

	ldrv rv1, [ra1, #4] ; load vector
	xorv rv2, rv1, rv10 ; XOR
	strv rv2, [ra2, #4] ; store vector + advance pointer
	strv rv2, [ra1, #4] ; sobreescribir input + advance pointer

	cmpv ra3, ra2
	jlt finish
	jmp decrypt_loop

finish:
	END
