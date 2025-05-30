const int PINO_SENSOR_MQ2 = A0;  // DECLARAÇÃO DA VARIÁVEL QUE ACESSA O PINO
const int VALOR_MINIMO = 100;    // DECLARAÇÃO DA VARIÁVEL QUE GUARDA O VALOR MÍNIMO
int linhaFixa = 0;
const int VALOR_MAXIMO = 1000;  // DECLARAÇÃO DA VARIÁVEL QUE GUARDA O VALOR MÁXIMO
const float PORCENTAGEM_MIN = 5.0;
const float PORCENTAGEM_MAX = 18.0;
float porcentagem = 0;

void setup() {  // AQUI NESSE BLOCO ELE CONFIGURA O ARDUINO PARA 9600 BITS POR SEGUNDO
  Serial.begin(9600);
}
void loop() {
  int valorSensor = analogRead(PINO_SENSOR_MQ2);  // NESSE BLOCO INICIA OS CÁLCULOS PARA CAPTURA DA DENSIDADE DE GÁS E FAZ EM UMA REPETIÇÃO
  
  
  

  Serial.print(linhaFixa);
  Serial.print(porcentagem);
  Serial.println(15);

  
 porcentagem = ((float)(valorSensor - VALOR_MINIMO) / (VALOR_MAXIMO - VALOR_MINIMO)) * (PORCENTAGEM_MAX - PORCENTAGEM_MIN) + PORCENTAGEM_MIN;

  if (porcentagem < 0) {
    porcentagem = 0;

  } else if (porcentagem > 100) {
    porcentagem = 100;
  }

  delay(2000);
}