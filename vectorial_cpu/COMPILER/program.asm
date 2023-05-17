@ Los registros estan inicializados de la siguiente manera:

@ Registros vectoriales:
@ RV9 = {06, 05, 04, 03, 02, 01}
@ RV8 = {00, 00, 00, 00, 00, 00}
@ RV7 = {00, 00, 00, 00, 00, 00}
@ RV6 = {00, 00, 00, 00, 00, 00}
@ RV5 = {00, 00, 00, 00, 00, 00}
@ RV4 = {00, 00, 00, 00, 00, 00}
@ RV3 = {00, 00, 00, 00, 00, 00}
@ RV2 = {00, 00, 00, 00, 00, 00}
@ RV1 = {00, 00, 00, 00, 00, 00}

@ Registros escalares:
@ {00, 00, 00, 00, 00, 00}

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