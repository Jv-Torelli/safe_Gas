-- Arquivo de apoio, caso você queira criar tabelas como as aqui criadas para a API funcionar.
-- Você precisa executar os comandos no banco de dados para criar as tabelas,
-- ter este arquivo aqui não significa que a tabela em seu BD estará como abaixo!

/*
comandos para mysql server
*/

CREATE DATABASE sgc;
USE sgc;


-- Tabela Condominio
CREATE TABLE condominio (
idCondominio INT PRIMARY KEY AUTO_INCREMENT,
nome_condominio VARCHAR(30) NOT NULL,
cep CHAR(11) NOT NULL,
logradouro VARCHAR(45) NOT NULL,
numero_logradouro varchar(5) NOT NULL,
cnpj CHAR(14) UNIQUE,
dt_cadastro_condominio datetime default current_timestamp,
senha varchar(45)
);

-- Tabela Portaria
CREATE TABLE portaria (
idPortaria INT PRIMARY KEY AUTO_INCREMENT,
numero_portaria CHAR(1),
telefone char(11),
dt_cadastro_port date,
email varchar(60),
fkCondominioPortaria INT,
CONSTRAINT fkCondominioPortaria FOREIGN KEY (fkCondominioPortaria) REFERENCES condominio(idCondominio)
);

-- Tabela Predio
CREATE TABLE predio (
idPredio INT PRIMARY KEY auto_increment,
bloco_predio CHAR(1),
fkPortariaPredio INT,
CONSTRAINT fkPortariaPredio FOREIGN KEY(fkPortariaPredio) REFERENCES portaria(idPortaria)
);

-- Tabela Atendimento
CREATE TABLE atendimento(
idAtendimento INT,
fkPortaria INT,
fkPredio INT,
fkCondominio INT,
CONSTRAINT pkComposta PRIMARY KEY (idAtendimento, fkPortaria, fkPredio, fkCondominio),
CONSTRAINT fkPortaria FOREIGN KEY(fkPortaria) REFERENCES portaria(idPortaria),
CONSTRAINT fkPredio FOREIGN KEY(fkPredio) REFERENCES predio(idPredio),
CONSTRAINT fkCondominio FOREIGN KEY(fkCondominio) REFERENCES condominio(idCondominio)
);

-- Tabela Apartamento
CREATE TABLE apartamento (
idApartamento INT PRIMARY KEY auto_increment,
numero_apartamento VARCHAR(5),
andar_apartamento INT,
fkPredioApto INT,
CONSTRAINT fkPredioApto FOREIGN KEY(fkPredioApto) REFERENCES predio(idPredio)
);

-- Tabela Sensor
CREATE TABLE sensor (
idSensor INT PRIMARY KEY auto_increment,
status_sensor VARCHAR(10),
	CONSTRAINT ckSensor 
		CHECK (status_sensor IN ('Ativo', 'Inativo')),
local_instalado VARCHAR(45),
fkApartamento INT,
CONSTRAINT fkApartamentoSensor FOREIGN KEY (fkApartamento) references apartamento(idApartamento),
fkPredio INT,
CONSTRAINT fkPredioSensor FOREIGN KEY (fkPredio) references predio(idPredio)
);

-- Tabela Medicao
CREATE TABLE medicao (
idMedicao INT AUTO_INCREMENT,
fkSensorMedicao INT,
fkApartamentoMedicao INT,
fkPredioMedicao INT,
CONSTRAINT pkCompostaMedicao PRIMARY KEY (idMedicao, fkSensorMedicao, fkApartamentoMedicao, fkPredioMedicao),
CONSTRAINT fkSensorMedicao FOREIGN KEY (fkSensorMedicao) references sensor(idSensor),
CONSTRAINT fkApartamentoMedicao FOREIGN KEY (fkApartamentoMedicao) references apartamento(idApartamento),
CONSTRAINT fkPredioMedicao FOREIGN KEY (fkPredioMedicao) references predio(idPredio),
data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
nivel_de_gas FLOAT NOT NULL
);

-- Tabela Alerta
CREATE TABLE alerta(
idAlerta INT AUTO_INCREMENT,
statusAlerta VARCHAR(12),
	CONSTRAINT ckStatus
		CHECK (statusAlerta IN ('Seguro', 'Atenção', 'Alerta', 'Emergência')),
acao varchar(60),
risco VARCHAR(50),
fkSensorMedicao int,
fkApartamentoMedicao int,
fkPredioMedicao int,
constraint chave_primaria primary KEY (idAlerta, fkSensorMedicao, fkApartamentoMedicao, fkPredioMedicao));

alter table alerta add column fkMedicao int;
alter table alerta add constraint fkMedicao foreign key (fkMedicao, fkSensorMedicao, fkApartamentoMedicao, fkPredioMedicao ) references medicao(idMedicao, fkSensorMedicao, fkApartamentoMedicao, fkPredioMedicao);