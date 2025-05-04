CREATE DATABASE sgc;
USE sgc;

CREATE TABLE condominio (
idCondominio INT PRIMARY KEY AUTO_INCREMENT,
nome_condominio VARCHAR(30) NOT NULL,
cep CHAR(11) NOT NULL,
logradouro VARCHAR(45) NOT NULL,
numero_logradouro varchar(5) NOT NULL,
cnpj CHAR(14) UNIQUE,
dt_cadastro_cond date
);

CREATE TABLE portaria (
idPortaria INT AUTO_INCREMENT,
fkCondominio INT not null,
PRIMARY KEY (idPortaria, fkCondominio),
	FOREIGN KEY (fkCondominio) REFERENCES condominio(idCondominio),
numero_portaria CHAR(1),
telefone char(11),
dt_cadastro_port date,
email varchar(60),
senha VARCHAR(30) NOT NULL
);

CREATE TABLE predio (
idPredio int auto_increment,
fkCondominio INT not null,
PRIMARY KEY (idPredio, fkCondominio),
	FOREIGN KEY (fkCondominio) REFERENCES condominio(idCondominio),
numero_predio CHAR(1)
);

CREATE TABLE andar (
idAndar int auto_increment,
fkPredio INT not null,
fkCondominio INT not null,
PRIMARY KEY (idAndar, fkPredio, fkCondominio),
	FOREIGN KEY (fkPredio) REFERENCES predio(idPredio),
    FOREIGN KEY (fkCondominio) REFERENCES condominio(idCondominio),
piso int
);

CREATE TABLE apartamento (
idApartamento INT auto_increment,
fkAndar INT,
fkPredio INT,
fkCondominio INT,
PRIMARY KEY (idApartamento, fkAndar, fkPredio, fkCondominio),
	FOREIGN KEY (fkAndar) references andar(idAndar),
	FOREIGN KEY (fkPredio) references predio(idPredio),
	FOREIGN KEY (fkCondominio) references condominio(idCondominio),
numero_apartamento VARCHAR(5)
);

CREATE TABLE sensor (
idSensor INT PRIMARY KEY auto_increment,
fkApartamento INT,
CONSTRAINT fkApartamentoSensor FOREIGN KEY (fkApartamento) references apartamento(idApartamento),
fkAndar INT,
CONSTRAINT fkAndarSensor FOREIGN KEY (fkAndar) references andar(idAndar),
fkPredio INT,
CONSTRAINT fkPredioSensor FOREIGN KEY (fkPredio) references predio(idPredio),
fkCondominio INT,
CONSTRAINT fkCondominioSensor FOREIGN KEY (fkCondominio) references condominio(idCondominio),
statusSensor VARCHAR(10),
	CONSTRAINT ckSensor 
		CHECK (statusSensor IN ('Ativo', 'Inativo')),
local_instalado varchar(45)
);

CREATE TABLE medicao (
idMedicao INT AUTO_INCREMENT,
fkSensor INT,
PRIMARY KEY (idMedicao, fkSensor),
	FOREIGN KEY (fkSensor) references sensor(idSensor),
dataHora DATETIME DEFAULT CURRENT_TIMESTAMP,
nivel_de_gas FLOAT NOT NULL
);

CREATE TABLE alerta(
idAlerta INT AUTO_INCREMENT,
fkMedicao int,
fkSensor INT,
PRIMARY KEY (idAlerta, fkMedicao, fkSensor),
	FOREIGN KEY (fkMedicao) REFERENCES medicao(idMedicao),
	FOREIGN KEY (fkSensor) REFERENCES sensor(idSensor),
statusAlerta VARCHAR(12),
	CONSTRAINT ckStatus
		CHECK (statusAlerta IN ('Seguro', 'Atenção', 'Alerta', 'Perigo', 'Emergência'))
);

-- Tabela condominio
INSERT INTO condominio (nome_condominio, cep, logradouro, numero_logradouro, cnpj, dt_cadastro_cond) VALUES
('Condomínio Sol', '12345678', 'Rua das Flores',  '100', '12345678000101', '2025-01-06'),
('Condomínio Lua', '23456789', 'Av. Estrelas',  '200', '23456789000102', '2025-01-11'),
('Condomínio Mar', '34567890', 'Rua das Ondas',  '300', '34567890000103', '2025-01-15'),
('Condomínio Céu', '45678901', 'Rua das Nuvens',  '400', '45678901000104', '2025-01-19'),
('Condomínio Estrela', '56789012', 'Rua Galáxia',  '500', '56789012000105', '2025-01-25');

-- Tabela portaria
INSERT INTO portaria (fkCondominio, numero_portaria, telefone, dt_cadastro_port, email, senha) VALUES
(1, '1', '11958764211', '2025-01-06', 'portariaUm@sol.com', 'senha01'),
(1, '2', '11958764212', '2025-01-06', 'portariaDois@sol.com', 'senha02'),
(2, '1', '11958764221', '2025-01-11', 'portariaUm@lua.com', 'senha03'),
(3, '1', '11958764231', '2025-01-15', 'portariaUm@mar.com', 'senha04'),
(3, '2', '11958764232', '2025-01-15', 'portariaDois@mar.com', 'senha05'),
(4, '1', '11958764241', '2025-01-19', 'portariaUm@ceu.com', 'senha06'),
(4, '2', '11958764242', '2025-01-19', 'portariaDois@ceu.com', 'senha07'),
(5, '1', '11958764251', '2025-01-25', 'portariaUm@estrela.com', 'senha08');

INSERT INTO predio (fkCondominio, numero_predio) VALUES
(1, '1'),
(1, '4'),
(2, '1'),
(3, '2'),
(3, '6'),
(4, '1'),
(4, '7'),
(5, '1');

INSERT INTO andar (fkPredio, fkCondominio, piso) VALUES 
(1, 1, 5),
(3, 2, 8),
(4, 3, 12),
(6, 4, 1),
(8, 5, 15);

-- Tabela apartamento
INSERT INTO apartamento (fkAndar, fkPredio, fkCondominio, numero_apartamento) VALUES
(1, 1, 1, 101),
(2, 3, 2, 806),
(3, 4, 3, 1202),
(4, 6, 4, 101),
(5, 8, 5, 1507);

-- Tabela sensor
INSERT INTO sensor (fkApartamento, fkAndar, fkPredio,  fkCondominio, statusSensor, local_instalado) VALUES
(1, 1, 1, 1, 'Ativo', 'cozinha'),
(2, 2, 3, 2, 'Ativo', 'banheiro'),
(3, 3, 4, 3, 'Ativo', 'banheiro'),
(4, 4, 6, 4, 'Ativo', 'cozinha'),
(5, 5, 8, 5, 'Inativo', 'cozinha');

-- Tabela medicao 
INSERT INTO medicao (fkSensor, nivel_de_gas) VALUES
(1, 2.0),
(2, 2.9),
(3, 5.4),
(4, 10.3),
(5, 16.6);

-- Tabela alerta
INSERT INTO alerta (fkMedicao, fkSensor, statusAlerta) VALUES
(1, 1,'Seguro'),
(2, 2,'Atenção'),
(3, 3,'Alerta'),
(4, 4,'Perigo'),
(5, 5,'Emergência');


SELECT * FROM condominio;

SELECT * FROM portaria;

SELECT * FROM predio;

SELECT * FROM andar;

SELECT * FROM apartamento;

SELECT * FROM sensor;

SELECT * FROM medicao;

SELECT * FROM alerta;

SELECT * FROM condominio WHERE nome_condominio LIKE '%A';

SELECT * FROM apartamento WHERE numero_apartamento = '1202';

SELECT * FROM condominio AS c JOIN predio AS p
ON c.idCondominio = p.fkCondominio JOIN andar AS a
ON p.idPredio = a.fkPredio JOIN apartamento AS ap
ON a.idAndar = ap.fkAndar;

SELECT 
  c.nome_condominio AS nome_condominio,
  p.numero_portaria AS portaria,
  predio.numero_predio AS predio,
  a.piso AS andar,
  ap.numero_apartamento as apartamento,
  s.statusSensor AS status_sensor,
  s.local_instalado,
  m.nivel_de_gas AS concentracao_gases,
  m.dataHora,
  al.statusAlerta
FROM portaria AS p 
JOIN condominio AS c ON c.idCondominio = p.fkCondominio
JOIN predio ON c.idCondominio = predio.fkCondominio
JOIN andar AS a ON predio.idPredio = a.fkPredio
JOIN apartamento AS ap ON a.idAndar = ap.fkAndar
JOIN sensor AS s ON ap.idApartamento = s.fkApartamento
JOIN medicao AS m ON s.idSensor = m.fkSensor
JOIN alerta AS al ON m.idMedicao = al.fkMedicao;


/* SELECT 
  c.nome AS nome_condominio,
  l.cnpj AS cnpj_login,
  s.nome AS nome_sensor,
  al.statusAlerta AS status_alerta,
  m.concentracaoGases AS concentracao_gases,
  CONCAT(a.blocoApartamento, '-', a.numApartamento) AS apartamento
FROM condominio AS c
JOIN login AS l ON c.idCondominio = l.fkCondominio
JOIN sensor AS s ON c.idCondominio = s.fkApartamento
JOIN alerta AS al ON s.idSensor = al.fkSensorAlerta
JOIN medicao AS m ON s.idSensor = m.fkSensor
JOIN apartamento AS a ON c.idCondominio = a.fkCondominioApartamento
WHERE c.nome LIKE '%o%';


SELECT 
  c.nome AS nome_condominio,
  l.cnpj AS cnpj_login,
  s.nome AS nome_sensor,
  al.statusAlerta AS status_alerta,
  m.concentracaoGases AS concentracao_gases,
  CONCAT(a.blocoApartamento, '-', a.numApartamento) AS apartamento,
  CASE
    WHEN m.concentracaoGases < 2 THEN 'Baixa'
    WHEN m.concentracaoGases BETWEEN 2 AND 4.9 THEN 'Moderada'
    WHEN m.concentracaoGases BETWEEN 5 AND 7.9 THEN 'Alta'
    ELSE 'Crítica'
  END AS classificacao_gas
FROM condominio AS c
JOIN login AS l ON c.idCondominio = l.fkCondominio
JOIN sensor AS s ON c.idCondominio = s.fkApartamento
JOIN alerta AS al ON s.idSensor = al.fkSensorAlerta
JOIN medicao AS m ON s.idSensor = m.fkSensor
JOIN apartamento AS a ON c.idCondominio = a.fkCondominioApartamento
ORDER BY c.nome, classificacao_gas DESC;


SELECT 
  c.nome AS nome_condominio,
  IFNULL(c.email, 'sem email') AS email_condominio,
  l.cnpj AS cnpj_login,
  s.nome AS nome_sensor,
  IFNULL(s.statusSensor, 'Desconhecido') AS status_sensor,
  al.statusAlerta AS status_alerta,
  m.concentracaoGases AS concentracao_gases,
  CONCAT(a.blocoApartamento, '-', a.numApartamento) AS apartamento,
  CASE
    WHEN m.concentracaoGases < 2 THEN 'Baixa'
    WHEN m.concentracaoGases BETWEEN 2 AND 4.9 THEN 'Moderada'
    WHEN m.concentracaoGases BETWEEN 5 AND 7.9 THEN 'Alta'
    ELSE 'Crítica'
  END AS classificacao_gas
FROM condominio AS c
JOIN login AS l ON c.idCondominio = l.fkCondominio
JOIN sensor AS s ON c.idCondominio = s.fkApartamento
JOIN alerta AS al ON s.idSensor = al.fkSensorAlerta
JOIN medicao AS m ON s.idSensor = m.fkSensor
JOIN apartamento AS a ON c.idCondominio = a.fkCondominioApartamento
ORDER BY c.nome, classificacao_gas DESC;
*/