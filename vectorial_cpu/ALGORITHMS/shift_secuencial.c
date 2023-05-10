/**
 Autor: PaoloRamirez
 Tema: Aplicar XOR a una cadena con una clave de N bytes
 Link: https://www.facebook.com/PaoloProgrammer/
**/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void print_bytes(char *s, size_t len) {
  if (len == 0)
    return;

  printf("[ 0x%02X", *(unsigned char *)s);
  while (len > 0) {
    printf(", 0x%02X", *(unsigned char *)s);
    len--;
    s++;
  }
  printf(" ]");
}

unsigned char circular_left_shift(unsigned char x, unsigned int shammt) {
  return (x << shammt) | (x >> (8 - shammt));
}

unsigned char circular_right_shift(unsigned char x, unsigned int shammt) {
  return (x >> shammt) | (x << (8 - shammt));
}

int main(int argc, char *argv[]) {
  if (argc != 3) {
    perror("Insertar 2 parametros (p1:bytes, p2:shift)");
    exit(1);
  }

  char *bytes = argv[1];
  int bytes_len = strlen(bytes);

  // Parseo de shift ammount, no importa para implementación en procesador
  // (shift_ammount puede ir hardcodeado)
  int shift_ammount = strtoul(argv[2], NULL, 0);
  if (shift_ammount == 0 || shift_ammount >= 8) {
    // Solo hay 8 bits en un byte
    perror(
        "Error parseando shift ammount (debe ser diferente de 0 y menor a 8)");
    exit(2);
  }

  printf("Entrada: %s\n", bytes);
  printf("Shift: %d\n", shift_ammount);
  printf("Entrada en bytes: ");
  print_bytes(bytes, bytes_len);
	printf("\n\n");

  // Versión secuencial
  for (int i = 0; i < bytes_len; i++) {
    unsigned char byte = bytes[i];
    unsigned char encrypted_byte = circular_right_shift(byte, shift_ammount);
    bytes[i] = encrypted_byte;
  }

  printf("Bytes cifrados: ");
  print_bytes(bytes, bytes_len);
  printf("\n\n");

  for (int i = 0; i < bytes_len; i++) {
    unsigned char encrypted_byte = bytes[i];
    unsigned char byte = circular_left_shift(encrypted_byte, shift_ammount);
    bytes[i] = byte;
  }

  printf("Bytes descifrados: ");
  print_bytes(bytes, bytes_len);
  printf("\nSalida descifrada: %s\n", bytes);
}
