const int PINO_SENSOR_MQ2 = A0;  // DECLARAÇÃO DAS VARIÁVEIS
const float porcentagem = 0;

void setup() {  // CONFIGURAÇÃO SERIAL MONITOR
  Serial.begin(9600);
}

void loop() {

  int valorSensor = analogRead(PINO_SENSOR_MQ2);  
  float porcentagem = ((float)valorSensor); // VARIÁVEL RECEBENDO O VALOR DO SENSOR
  porcentagem = ((float)porcentagem/180); // CÁLCULO PARA CONVERSÃO DE (PPM) PARA PERCENTUAL (%)

  // Serial.print("Porcentagem:"); // SAÍDA PRINTADAS
  Serial.println(porcentagem);
  // Serial.print(" ");
  // Serial.print("LIE:"); // LIMITE INFERIOR 
  // Serial.print(5);
  // Serial.print(" ");
  // Serial.print("LSE:"); // LIMITE SUPERIOR
  // Serial.print(15);
  // Serial.println("");

  delay(2000);

}
