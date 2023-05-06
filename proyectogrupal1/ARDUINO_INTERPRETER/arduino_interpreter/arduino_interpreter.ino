int b0 = 2;  //
int b1 = 3;  //
int b2 = 4;  //
int b3 = 5;  //
int b4 = 6;  //
int b5 = 7;  //
int b6 = 8;  //
int b7 = 9;  //

int val0 = 0;  //
int val1 = 0;  //
int val2 = 0;  //
int val3 = 0;  //
int val4 = 0;  //
int val5 = 0;  //
int val6 = 0;  //
int val7 = 0;  //

int clk_out = 13;
int val_clk = 0;

int o_byte = B00000000;
int flag = 0;
int contador = 0;
int contador2 = 0;

char cadena[100];

void setup() {
  Serial.begin(115200);
  pinMode(b0, INPUT);
  pinMode(b1, INPUT);
  pinMode(b2, INPUT);
  pinMode(b3, INPUT);
  pinMode(clk_out, INPUT);
}

void loop() {

  if (digitalRead(clk_out) == 0) {
    flag = 0;
  }
  if (digitalRead(clk_out) == 1 && flag == 0) {
    flag = 1;

    bitWrite(o_byte, 0, digitalRead(b0));
    bitWrite(o_byte, 1, digitalRead(b1));
    bitWrite(o_byte, 2, digitalRead(b2));
    bitWrite(o_byte, 3, digitalRead(b3));
    bitWrite(o_byte, 4, digitalRead(b4));
    bitWrite(o_byte, 5, digitalRead(b5));
    bitWrite(o_byte, 6, digitalRead(b6));
    bitWrite(o_byte, 7, digitalRead(b7));

    if (o_byte != 255 & contador != 100) {
      if (contador == 0) {
        Serial.println("Se inicia la comunicacion, recepcion de datos:\n");
      }
      
      cadena[contador] = char(o_byte);
      contador = contador + 1;
      Serial.print("Byte(");
      Serial.print(contador);
      Serial.print("): \t");
      Serial.print(o_byte);
      Serial.print("\t");
      Serial.println(char(o_byte));
    }
  }

  if (contador == 100 && contador2 ==0)
    Serial.println("\n\nCadena resultante del desencriptado:\n");

  if (contador == 100 & contador2 != 100) {

    Serial.print(cadena[contador2]);
    contador2 = contador2 + 1;
  }
}