@ Constantes a modificar:
@ @RS1, RS2 => #KEY = cantidad de shifts necesarios (debe ser menor a 8)
@ RA5: Registro de direccion para cargar INPUT, inicio y final de VGA. 
@ SEL: Registro que contiene el estado del switch que controla la seleccion del SELoritmo.
@ PSE: Registro que contiene el estado del switch que indica cuando iniciar el desencriptado.
@ PSE = 1: pausa
@ PSE = 0: continuar

_start:

	LDR RA1, [RA5]      @ RA1 = dirección de PIXELS START - 4
	LDR RA2, [RA5, #4]  @ RA2 = dirección de PIXELS END
	LDR RA3, [RA5, #8]  @ RA3 = dirección de VGA START - 4

	SEL #3, RSA
	SEL #2, ROT128
	SEL #1, CIRCULAR_SHIFT
	SEL #0, XOR

_end:
	NOP
	END


@ ALGORITMO 1: XOR
@ Encriptar y desencriptar imagen usando un XOR de #KEY posiciones
XOR:

	@ ENCRIPTAR
	encrypt_xor:
	@ Cargar valores iniciales
	MOV RS1, #1		  	  @ KEY - Cargar llave
	XOR RV3, RV3, RV3     @ Asegurar el cero        
	ADD RV3, RV3, #8      @ Cargar 8 8 8 8 8 8 en RV3

		encrypt_xor_loop:
		LDR RV1, [RA1, #4]            @ load vector
		NOP
		NOP
		XOR RV2, RV1, RS1		      @ XOR
		NOP
		NOP
		NOP

		@ GUARDAR PIXELES
		STR RV2, [RA3, #4]            @ store vector in VGA + advance pointer
		STR RV2, [RA1, #4]            @ sobreescribir input + advance pointer
		NOP
		NOP
		NOP
		CMP RA1, RA2                  @ Revisar si es el final de la memoria de video
		NOP
		NOP
		NOP
		JEQ pause_xor_loop
		JMP encrypt_xor_loop

	@ PAUSAR
	pause_xor_loop:
	PSE #0, decrypt_xor               @ Revisar si switch de continuar se activa
	NOP
	JMP pause_xor_loop

	@ DESENCRIPTAR
	decrypt_xor:
	LDR RA1, [RA5]      @ RA1 = dirección de PIXELS START - 4
	LDR RA2, [RA5, #4]  @ RA2 = dirección de PIXELS END
	LDR RA3, [RA5, #8]  @ RA3 = dirección de VGA START - 4


		decrypt_xor_loop:
		LDR RV1, [RA1, #4]            @ load vector
		NOP
		NOP
		XOR RV2, RV1, RS1
		NOP
		NOP
		NOP

		@ GUARDAR PIXELES
		STR RV2, [RA3, #4]            @ store vector in VGA + advance pointer
		STR RV2, [RA1, #4]            @ sobreescribir input + advance pointer
		NOP
		NOP
		NOP
		CMP RA1, RA2                  @ Revisar si es el final de la memoria de video
		NOP
		NOP
		NOP
		JEQ _end
		JMP decrypt_xor_loop



@ ALGORITMO 2: ROTATE O CIRCULAR SHIFT 
@ Encriptar y desencriptar imagen usando un circular shift de #KEY posiciones
CIRCULAR_SHIFT:

	@ ENCRIPTAR
	encrypt_circular_shift:
	@ Cargar valores iniciales
	MOV RS1, #1		  	  @ KEY - Cargar llave
	XOR RV3, RV3, RV3     @ Asegurar el cero        
	ADD RV3, RV3, #8      @ Cargar 8 8 8 8 8 8 en RV3

		encrypt_circular_shift_loop:
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
		STR RV2, [RA3, #4]            @ store vector in VGA + advance pointer
		STR RV2, [RA1, #4]            @ sobreescribir input + advance pointer
		NOP
		NOP
		NOP
		CMP RA1, RA2                  @ Revisar si es el final de la memoria de video
		NOP
		NOP
		NOP
		JEQ pause_circular_shift_loop
		JMP encrypt_circular_shift_loop

	@ PAUSAR
	pause_circular_shift_loop:
	PSE #0, decrypt_circular_shift                    	@ Revisar si switch de continuar se activa
	NOP
	JMP pause_circular_shift_loop

	@ DESENCRIPTAR
	decrypt_circular_shift:
	LDR RA1, [RA5]      @ RA1 = dirección de PIXELS START - 4
	LDR RA2, [RA5, #4]  @ RA2 = dirección de PIXELS END
	LDR RA3, [RA5, #8]  @ RA3 = dirección de VGA START - 4

		decrypt_circular_shift_loop:
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
		STR RV2, [RA3, #4]            @ store vector in VGA + advance pointer
		STR RV2, [RA1, #4]            @ sobreescribir input + advance pointer
		NOP
		NOP
		NOP
		CMP RA1, RA2                  @ Revisar si es el final de la memoria de video
		NOP
		NOP
		NOP
		JEQ _end
		JMP decrypt_circular_shift_loop


@ ALGORITMO 3: ROT128
@ Encriptar y desencriptar imagen usando un XOR de #KEY posiciones
ROT128:

	@ ENCRIPTAR
	encrypt_rot:
	@ Cargar valores iniciales
	MOV RS2, #128			@ Guardar 128

		encrypt_rot_loop:
		LDR RV1, [RA1, #4]            @ load vector
		NOP
		NOP
		ADD RV2, RV1, RS2		      @ ROT128
		NOP
		NOP
		NOP

		@ GUARDAR PIXELES
		STR RV2, [RA3, #4]            @ store vector in VGA + advance pointer
		STR RV2, [RA1, #4]            @ sobreescribir input + advance pointer
		NOP
		NOP
		NOP
		CMP RA1, RA2                  @ Revisar si es el final de la memoria de video
		NOP
		NOP
		NOP
		JEQ pause_rot_loop
		JMP encrypt_rot_loop

	@ PAUSAR
	pause_rot_loop:
	PSE #0, decrypt_rot               @ Revisar si switch de continuar se activa
	NOP
	JMP pause_rot_loop

	@ DESENCRIPTAR
	decrypt_rot:
	LDR RA1, [RA5]      @ RA1 = dirección de PIXELS START - 4
	LDR RA2, [RA5, #4]  @ RA2 = dirección de PIXELS END
	LDR RA3, [RA5, #8]  @ RA3 = dirección de VGA START - 4

		decrypt_rot_loop:
		LDR RV1, [RA1, #4]            @ load vector
		NOP
		NOP
		ADD RV2, RV1, RS2		      @ ROT128
		NOP
		NOP
		NOP

		@ GUARDAR PIXELES
		STR RV2, [RA3, #4]            @ store vector in VGA + advance pointer
		STR RV2, [RA1, #4]            @ sobreescribir input + advance pointer
		NOP
		NOP
		NOP
		CMP RA1, RA2                  @ Revisar si es el final de la memoria de video
		NOP
		NOP
		NOP
		JEQ _end
		JMP decrypt_rot_loop



@ ALGORITMO 4: RSA
@ Encriptar y desencriptar imagen usando un XOR de #KEY posiciones
RSA:

	@ @ ENCRIPTAR
	@ encrypt_rsa: