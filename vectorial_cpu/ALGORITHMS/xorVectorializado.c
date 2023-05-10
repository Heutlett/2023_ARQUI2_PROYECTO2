#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>

int main(int argc, char *argv[])
{
    if (argc != 3)
    {
        perror("Insertar 2 parametros (p1:texto, p2:clave)");
        exit(0);
    }
   if (strnlen(argv[1], 7) > 6 || strnlen(argv[2], 7) > 6)
    {
        perror("Tamaño de cadena excedido");
        exit(0);
    }
    int len_texto, len_clave;
    len_texto = strlen(argv[1]);
    len_clave = strlen(argv[2]);

    // Tamaño de cadena = len+fincadena \0
    uint8_t texto[6] = {0}; //L+R
    uint8_t clave[6] = {0}; //Ki

    // Copiar a variables
    memcpy(texto, argv[1], len_texto);
    memcpy(clave, argv[2], len_clave);

    printf("Texto: ");
    for (int i = 0; i < 6; i++)
    {
        printf("%02x", texto[i]);
    }
    printf("\n");

    printf("Clave: ");
    for (int i = 0; i < 6; i++)
    {
        printf("%02x", clave[i]);
    }
    printf("\n\n");

    // Aplicando XOR;  texto[i] XOR clave[i]
    for (int i = 0; i < 6; i++)
    {
        texto[i] ^= clave[i];
    }

    printf("Texto cifrado: ");
    for (int i = 0; i < 6; i++)
    {
        printf("%02x", texto[i]);
    }
    printf("\n");

    return 0;
}
