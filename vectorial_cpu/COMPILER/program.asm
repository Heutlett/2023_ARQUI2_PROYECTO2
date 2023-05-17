@ Los registros estan inicializados de la siguiente manera:

@ Registros vectoriales:
@ RV9 = {05, 04, 03, 02, 01, 00}
@ RV8 = {01, 03, 04, 05, 05, 06}
@ RV7 = {00, 00, 00, 00, 00, 00}
@ RV6 = {01, 00, 01, 00, 01, 00}
@ RV5 = {00, 01, 00, 01, 00, 01}
@ RV4 = {20, 10, 08, 04, 02, 01}
@ RV3 = {00, 00, 00, 00, 00, 00}
@ RV2 = {00, 00, 00, 00, 00, 00}
@ RV1 = {00, 00, 00, 00, 00, 00}

@ Registros escalares:
@ {00, 00, 00, 01, 00, 00}

@ La memoria esta inicializada de la siguiente manera:
@ 0x0 = 10CC442211FF

@ Operaciones: Memoria
LDR RV2, [RV1]          @ Carga el valor de la dir 0x0 de memoria en el registro vectorial RV2
NOP
NOP
STR RV2, [RV1, #4]      @ Guarda el valor del registro RV2 en la dir 0x4 de memoria
NOP
NOP

@ Operaciones: Data register-register / vectorial-vectorial

@ ADDV:
ADDV RV3, RV9, RV8
NOP
NOP
STR RV3, [RV1, #8]
NOP
NOP

@ MOVV:
MOVV RV3, RV9 
NOP
NOP
STR RV3, [RV1, #12]
NOP
NOP

@ XORV:
XORV RV3, RV5, RV6    @ Todo en 1 1 1 1 1 1
NOP
NOP
STR RV3, [RV1, #16]
NOP
NOP
@ ORV:
ORV RV3, RV7, RV6     @ Todo en 1 0 1 0 1 0
NOP
NOP
STR RV3, [RV1, #20]
NOP
NOP

@ SHRV:
SHRS RV3, RV4, #1     @ 10 08 04 02 00
NOP
NOP
NOP

STR RV3, [RV1, #24]
NOP
NOP

@ SHLV:
SHLS RV3, RV3, #1     @ 20 10 08 04 00
NOP
NOP
NOP

STR RV3, [RV1, #28]
NOP
NOP

@ XORV:
XORS RV2, RV1,RV1     @ 0 0 0 0 0 0 
NOP
NOP

@ CMPS:
CMPS RV2, RS5       @ Si R2[0] es 0
JMP skip
NOP
NOP
STR RV9, [RV1, #32]    @ Save 0 0 0 0 0 0 
NOP
NOP
skip:
NOP
NOP
STR RV2, [RV1, #40]    @ save 1 1 1 1 1 1  saltando dos posiciones
NOP
NOP
END