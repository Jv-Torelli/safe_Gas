CREATE DATABASE sgc;
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
('senha123', '12345678000195'),
('segredo456', '98765432000188'),
('gasalerta2023', '56789012000133');

INSERT INTO sensor (nome, tipo, statusSensor) VALUES
('DHT11', 'Umidade e temperatura', 'Ativo'),
('DHT22', 'Umidade', 'Inativo'),
('MQ-135', 'Gás', 'Ativo');

INSERT INTO condominio (nome, logradouro, cep, numero, cnpj) VALUES
('Condomínio Alfa', 'Rua das Flores', '12345678', 100, '12345678000195'),
('Condomínio Beta', 'Avenida Central', '87654321', 200, '98765432000188'),
('Condomínio Gama', 'Praça do Sol', '11223344', 300, '56789012000133');

INSERT INTO medicao (dataHora, concentracaoGases, statusAlerta) VALUES
('2025-03-11 08:30:00', 15, 'Normal'),
('2025-03-11 09:00:00', 30, 'Atenção'),
('2025-03-11 09:30:00', 50, 'Crítico');


SELECT * FROM condominio WHERE logradouro LIKE '%o%';
SELECT * FROM sensor WHERE statusSensor NOT LIKE 'Ativo';
SELECT * FROM usuario WHERE idUsuario = 2;
SELECT * FROM medicao WHERE concentracaoGases >= 25;
SELECT * FROM condominio WHERE logradouro LIKE 'a%' OR logradouro LIKE 'p%';
SELECT nome AS 'Nome', CONCAT(logradouro, ', ', numero) AS 'Endereço Completo', cep AS 'CEP' FROM condominio;