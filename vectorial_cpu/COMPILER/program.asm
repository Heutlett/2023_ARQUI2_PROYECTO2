@ Constantes a modificar:
@ #KEY = cantidad de shifts necesarios (debe ser menor a 8)

@ RA5: Registro de direccion para cargar INPUT, inicio y final de VGA. 
@ SEL: Registro que contiene el estado del switch que controla la seleccion del SELoritmo.
@ PSE: Registro que contiene el estado del switch que indica cuando iniciar el desencriptado.
@ PSE = 1: pausa
@ PSE = 0: continuar

_start:
	LDR RA1, [RA5]      @ RA1 = dirección de INPUT START - 4
	LDR RA2, [RA5, #4]  @ RA2 = dirección de VGA START - 4
	LDR RA3, [RA5, #8]  @ RA3 = dirección de VGA END

	SEL #3, _end
	SEL #2, _end
	SEL #1, _end
	SEL #0, ROTATE

_end:
	NOP
	END



@ ALGORITMO 1: ROTATE O CIRCULAR SHIFT 
@ Encriptar y desencriptar imagen usando un circular shift de #KEY posiciones
ROTATE:

	@ ENCRIPTAR
	encrypt:
	@ Cargar valores iniciales
	MOV RS1, #1		  	@ KEY - Cargar llave
	XOR RV3, RV3, RV3     @ Asegurar el cero        
	ADD RV3, RV3, #8      @ Cargar 8 8 8 8 8 8 en RV3

		encrypt_loop:
		LDR RV1, [RA1, #4]            @ load vector
		NOP
		NOP

		@ CIRCULAR SHIFT RIGHT
		@ RV1 -> vector a aplicar shift
		@ RS1 -> #KEY
		@ RV3 -> vector que tiene 8 8 8 8 8 8
		@ RV2 -> vector con shift aplicado
		@ Modifica registros RV2, RV4, RV5, RV6
		SUB RV4, RV3, RS1
		SHR RV6, RV1, RS1
		NOP
		NOP
		NOP
		SHL RV5, RV1, RV4
		NOP
		NOP
		NOP
		OR  RV2, RV6, RV5
		NOP
		NOP
		NOP

		@ GUARDAR PIXELES
		STR RV2, [RA2, #4]            @ store vector + advance pointer
		STR RV2, [RA1, #4]            @ sobreescribir input + advance pointer
		NOP
		NOP
		NOP
		CMP RA2, RA3                  @ Revisar si es el final de la memoria de video
		NOP
		NOP
		NOP
		JEQ pause_loop
		JMP encrypt_loop

	@ PAUSAR
	pause_loop:
	PSE #0, decrypt                    	@ Revisar si switch de continuar se activa
	NOP
	JMP pause_loop

	@ DESENCRIPTAR
	decrypt:
	LDR RA1, [RA5]      @ RA1 = dirección de INPUT START - 4
	LDR RA2, [RA5, #4]  @ RA2 = dirección de VGA START - 4
	LDR RA3, [RA5, #8]  @ RA3 = dirección de VGA END

		decrypt_loop:
		LDR RV1, [RA1, #4]            @ load vector
		NOP
		NOP

		@ CIRCULAR SHIFT LEFT
		@ RV1 -> vector a aplicar shift
		@ RS1 -> #KEY
		@ RV3 -> vector que tiene 8 8 8 8 8 8
		@ RV2 -> vector con shift aplicado
		@ Modifica registros RV2, RV4, RV5, RV6
		SUB RV4, RV3, RS1
		SHL RV6, RV1, RS1
		NOP
		NOP
		NOP
		SHR RV5, RV1, RV4
		NOP
		NOP
		NOP
		OR  RV2, RV6, RV5
		NOP
		NOP
		NOP

		@ GUARDAR PIXELES
		STR RV2, [RA2, #4]            @ store vector + advance pointer
		STR RV2, [RA1, #4]            @ sobreescribir input + advance pointer
		NOP
		NOP
		NOP
		CMP RA2, RA3                  @ Revisar si es el final de la memoria de video
		NOP
		NOP
		NOP
		JEQ _end
		JMP decrypt_loop