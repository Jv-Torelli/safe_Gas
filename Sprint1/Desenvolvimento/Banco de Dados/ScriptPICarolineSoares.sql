-- Tabelas Pi

CREATE DATABASE Sgc;
USE sgc;

CREATE TABLE usuario (
idUsuario INT PRIMARY KEY auto_increment,
senha VARCHAR(15) NOT NULL,
cnpj CHAR(14) UNIQUE NOT NULL
);

CREATE TABLE sensor (
idSensor INT PRIMARY KEY auto_increment,
nome VARCHAR(25) NOT NULL,
tipo VARCHAR(30) NOT NULL,
statusSensor VARCHAR(15) 
	CONSTRAINT ckSensor 
		CHECK (statusSensor in ('Ativo', 'Inativo'))
);

CREATE TABLE medicao (
idMedicao int primary key auto_increment,
dataHora datetime,
concentracaoGases INT NOT NULL,
	CONSTRAINT ckTaxa 
		CHECK (concentracaoGases in (15,30,50)), 
statusAlerta VARCHAR(30)
	CONSTRAINT ckstatus
		CHECK (statusAlerta in ('Normal', 'Atenção', 'Crítico'))
);

CREATE TABLE condominio (
idCondominio INT PRIMARY KEY auto_increment,
nome VARCHAR(30) NOT NULL,
logradouro VARCHAR(50) NOT NULL,
cep CHAR(8) NOT NULL,
numero INT NOT NULL,
cnpj CHAR(14) UNIQUE NOT NULL
);

INSERT INTO usuario (senha, cnpj) VALUES
('aninho2000', '12345678000190'),
('camilinho2000', '98765432000112'),
('carolzinho2000', '56789123000134'),
('guilherminha200', '43210987000156'),
( 'joana2000', '11222333000178'),
('leticinho2000', '77888999000100'),
('rayssinho2000', '34567890000123');

INSERT INTO sensor (nome, tipo, statusSensor) VALUES
('MQ-2', 'Sensor gás', 'Ativo'),
('MQ-3', 'Sensor gás', 'Inativo'),
('MQ-4', 'Sensor gás', 'Ativo');

INSERT INTO condominio (nome, logradouro, cep, numero, cnpj) VALUES
('Osasco Residencial Life','O Trabuco Jornal', '02723456', 247, '12345678000190'),
('Osasco Residencial Death','O Vale da Morte', '66666666', 666, '12345678000191'),
('Osasco Residencial Sky','O Vale da Vida', '77777777', 777, '12345678000192');

INSERT INTO medicao (dataHora, concentracaoGases, statusAlerta) VALUES
('2025-03-10 08:30:00', 15, 'Normal'),
('2025-03-10 09:00:00', 30, 'Atenção'),
('2025-03-10 09:30:00', 50, 'Crítico'),
('2025-03-10 10:00:00', 30, 'Normal');


SELECT * FROM condominio WHERE logradouro LIKE '%l';
SELECT * FROM sensor WHERE statusSensor NOT LIKE 'Inativo';
SELECT * FROM usuario WHERE idUsuario = 2;

SELECT dataHora AS 'Data e Hora',
concentracaoGases AS 'Concentração de Gases',
statusAlerta AS 'Status'
FROM medicao;

