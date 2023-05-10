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
// Suma de vector con escalar
vector vector_scalar_sum(vector v, int scalar) {

  vector new_v;
  for (int i = 0; i < 6; i++) {
    new_v.reg[i] = v.reg[i] + scalar;
  }

  return new_v;
}

// NO sería una instrucción del ISA, solo una función normal en ASM
vector rot128(vector v) { return vector_scalar_sum(v, 128); }

int main(int argc, char *argv[]) {
  if (argc != 2) {
    printf("Insertar 1 parametro (p1:bytes)\n");
    exit(1);
  }

  char *bytes = argv[1];
  int bytes_len = strlen(bytes);

  printf("Entrada: %s\n", bytes);
  printf("Entrada en bytes: ");
  print_bytes(bytes, bytes_len);
  printf("\n\n");

  // Versión vectorial
  for (int i = 0; i < bytes_len; i += 6) {
    vector vec =
        load_vector((unsigned char *)bytes + i); // Load vector from bytes[i]
    vector encrypted_vec = rot128(vec);          // Apply ROT128 operation

    store_vector(encrypted_vec,
                 (unsigned char *)bytes + i); // store back into bytes[i]
  }

  printf("Bytes cifrados: ");
  print_bytes(bytes, bytes_len);
  printf("\n\n");

  for (int i = 0; i < bytes_len; i += 6) {

    vector encrypted_vec =
        load_vector((unsigned char *)bytes + i); // Load vector from bytes[i]
    vector vec =
        rot128(encrypted_vec); // Apply ROT128 operation

    store_vector(vec, (unsigned char *)bytes + i); // store back into bytes[i]
  }

  printf("Bytes descifrados: ");
  print_bytes(bytes, bytes_len);
  printf("\nSalida descifrada: %s\n", bytes);
}
