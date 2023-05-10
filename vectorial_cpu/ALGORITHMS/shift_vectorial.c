/**
 Autor: PaoloRamirez
 Tema: Aplicar XOR a una cadena con una clave de N bytes
 Link: https://www.facebook.com/PaoloProgrammer/
**/
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Representa un registro especial vectorial
typedef struct {
  unsigned char reg[6];
} vector;

void print_bytes(char *s, size_t len) {
  if (len == 0)
    return;

  printf("[ 0x%02X", *(unsigned char *)s);
	s++;
	len--;
  while (len > 0) {
    printf(", 0x%02X", *(unsigned char *)s);
    len--;
    s++;
  }
  printf(" ]");
}

// Esto sería una instrucción vectorial del ISA
// Cargar un registro vectorial de un address en memoria
vector load_vector(unsigned char *address) {
  vector vec;
  for (int i = 0; i < 6; i++) {
    vec.reg[i] = *(address + i);
  }
  return vec;
}

// Esto sería una instrucción vectorial del ISA
// Guardar un registro vectorial de un address en memoria
void store_vector(vector v, unsigned char *address) {
  for (int i = 0; i < 6; i++) {
    address[i] = v.reg[i];
  }
}

// Esto sería una instrucción vectorial del ISA
// Right shift vectorial
vector vector_rsh(vector v, int shammt) {
  vector new_v;
  for (int i = 0; i < 6; i++) {
    new_v.reg[i] = v.reg[i] >> shammt;
  }
  return new_v;
}

// Esto sería una instrucción vectorial del ISA
// Left shift vectorial
vector vector_lsh(vector v, int shammt) {
  vector new_v;
  for (int i = 0; i < 6; i++) {
    new_v.reg[i] = v.reg[i] << shammt;
  }
  return new_v;
}

// Esto sería una instrucción vectorial del ISA
// OR vectorial
vector vector_or(vector v1, vector v2) {
  vector new_v;
  for (int i = 0; i < 6; i++) {
    new_v.reg[i] = v1.reg[i] | v2.reg[i];
  }
  return new_v;
}

// NO sería una instrucción del ISA, solo una función normal en ASM
vector circular_right_shift(vector v, unsigned int shammt) {
  return vector_or(vector_rsh(v, shammt), vector_lsh(v, 8 - shammt));
}

// NO sería una instrucción del ISA, solo una función normal en ASM
vector circular_left_shift(vector v, unsigned int shammt) {
  return vector_or(vector_lsh(v, shammt), vector_rsh(v, 8 - shammt));
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

  // Versión vectorial
  for (int i = 0; i < bytes_len; i += 6) {
    vector vec =
        load_vector((unsigned char *)bytes + i); // Load vector from bytes[i]
    vector encrypted_vec =
        circular_right_shift(vec, shift_ammount); // Apply circular shift

    store_vector(encrypted_vec,
                 (unsigned char *)bytes + i); // store back into bytes[i]
  }

  printf("Bytes cifrados: ");
  print_bytes(bytes, bytes_len);
  printf("\n\n");

  for (int i = 0; i < bytes_len; i+=6) {

    vector encrypted_vec =
        load_vector((unsigned char *)bytes + i); // Load vector from bytes[i]
    vector vec =
        circular_left_shift(vec, shift_ammount); // Apply circular shift

    store_vector(vec, (unsigned char *)bytes + i); // store back into bytes[i]
  }

  printf("Bytes descifrados: ");
  print_bytes(bytes, bytes_len);
  printf("\nSalida descifrada: %s\n", bytes);
}
