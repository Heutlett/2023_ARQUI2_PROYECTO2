@ MOVV RV0, RV1
@ MOVS RS0, RS1
MOVS RS1, #5

encrypt: 
    ADDV RV1, RV1, RS1
    @ ADDS RV1, RV0, RS0
    @ ADDS RV2, RV0, #10

    @ XORV RV3, RV1, RV0
    @ XORS RV4, RV0, RS3
    @ XORS RV5, RV0, #5

    @ ORV RV6, RV2, RV3
    @ ORS RV7, RV6, RS2
    @ ORS RV8, RV7, #5

    @ jmp encrypt
    @ jeq encrypt
    @ jlt encrypt
    LDR RV1, [RV1]
    LDR RS1, [RV1, #4]
    LDR RV1, [RV1, #8]
    @ STR RV1, [RV1]
    @ STR RV0, [RV3, #8]

    @ NOP
    @ COM
    END