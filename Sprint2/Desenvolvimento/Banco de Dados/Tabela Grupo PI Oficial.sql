CREATE DATABASE sgc;
USE sgc;


CREATE TABLE condominio (
idCondominio INT PRIMARY KEY AUTO_INCREMENT,
nome VARCHAR(30) NOT NULL,
logradouro VARCHAR(50) NOT NULL,
cep CHAR(8) NOT NULL,
numero INT NOT NULL,
cnpj CHAR(14) UNIQUE,
email VARCHAR(40),
senha CHAR(8) NOT NULL
);

CREATE TABLE login (
idLogin INT PRIMARY KEY AUTO_INCREMENT,
cnpj CHAR(14) UNIQUE NOT NULL,
senha VARCHAR(8) NOT NULL,
fkCondominio INT,
CONSTRAINT fkCondominio FOREIGN KEY (fkCondominio) references condominio(idCondominio)
);

CREATE TABLE sensor (
idSensor INT PRIMARY KEY auto_increment,
nome VARCHAR(25) NOT NULL,
apartamento VARCHAR(5) NOT NULL,
statusSensor VARCHAR(15),
	CONSTRAINT ckSensor 
		CHECK (statusSensor IN ('Ativo', 'Inativo')),
fkCondominioSensor INT,
CONSTRAINT fkCondominioSensor FOREIGN KEY (fkCondominioSensor) references condominio(idCondominio)
);

CREATE TABLE apartamento (
idApartamento INT PRIMARY KEY auto_increment,
blocoApartamento VARCHAR(3),
numApartamento VARCHAR(5),
metragem INT,
andar INT,
fkCondominioApartamento INT,
CONSTRAINT fkCondominioApartamento FOREIGN KEY (fkCondominioApartamento) references condominio(idCondominio)
);


CREATE TABLE alerta(
idAlerta INT AUTO_INCREMENT,
fkSensorAlerta INT NOT NULL,
statusAlerta VARCHAR(30),
	CONSTRAINT ckStatus
		CHECK (statusAlerta IN ('Seguro', 'Atenção', 'Alerta', 'Perigo', 'Emergência')),
PRIMARY KEY (idAlerta, fkSensorAlerta),
	FOREIGN KEY (fkSensorAlerta) REFERENCES sensor(idSensor)
);


CREATE TABLE medicao (
idMedicao INT PRIMARY KEY AUTO_INCREMENT,
dataHora DATETIME DEFAULT CURRENT_TIMESTAMP,
concentracaoGases FLOAT NOT NULL,
fkSensor INT,
CONSTRAINT fkSensor FOREIGN KEY (fkSensor) references sensor(idSensor)
);


CREATE TABLE contato(
idContato INT PRIMARY KEY auto_increment,
assunto VARCHAR(60),
email VARCHAR(80),
mensagem VARCHAR(200),
fkCondominioContato INT,
CONSTRAINT 	fkCondominioContato FOREIGN KEY (fkCondominioContato) references condominio(idCondominio)
);


-- Tabela condominio
INSERT INTO condominio (nome, logradouro, cep, numero, cnpj, email, senha) VALUES
('Condomínio Sol', 'Rua das Flores', '12345678', 100, '12345678000101', 'sol@exemplo.com', 'senha01'),
('Condomínio Lua', 'Av. Estrelas', '23456789', 200, '23456789000102', 'lua@exemplo.com', 'senha02'),
('Condomínio Mar', 'Rua das Ondas', '34567890', 300, '34567890000103', 'mar@exemplo.com', 'senha03'),
('Condomínio Céu', 'Rua das Nuvens', '45678901', 400, '45678901000104', 'ceu@exemplo.com', 'senha04'),
('Condomínio Terra', 'Av. Planeta', '56789012', 500, '56789012000105', 'terra@exemplo.com', 'senha05'),
('Condomínio Estrela', 'Rua Galáxia', '67890123', 600, '67890123000106', 'estrela@exemplo.com', 'senha06'),
('Condomínio Aurora', 'Av. Luzes', '78901234', 700, '78901234000107', 'aurora@exemplo.com', 'senha07'),
('Condomínio Horizonte', 'Rua do Amanhecer', '89012345', 800, '89012345000108', 'horizonte@exemplo.com', 'senha08'),
('Condomínio Vale', 'Av. Montanhas', '90123456', 900, '90123456000109', 'vale@exemplo.com', 'senha09'),
('Condomínio Lago', 'Rua das Águas', '01234567', 1000, '01234567000110', 'lago@exemplo.com', 'senha10');

-- Tabela login
INSERT INTO login (cnpj, senha, fkCondominio) VALUES
('12345678000101', 'senha01', 1),
('23456789000102', 'senha02', 2),
('34567890000103', 'senha03', 3),
('45678901000104', 'senha04', 4),
('56789012000105', 'senha05', 5),
('67890123000106', 'senha06', 6),
('78901234000107', 'senha07', 7),
('89012345000108', 'senha08', 8),
('90123456000109', 'senha09', 9),
('01234567000110', 'senha10', 10);

-- Tabela sensor
INSERT INTO sensor (nome, apartamento, statusSensor, fkCondominioSensor) VALUES
('Sensor Gás 1', '101A', 'Ativo', 1),
('Sensor Gás 2', '102B', 'Inativo', 2),
('Sensor Gás 3', '103C', 'Ativo', 3),
('Sensor Gás 4', '104D', 'Ativo', 4),
('Sensor Gás 5', '105E', 'Inativo', 5),
('Sensor Gás 6', '106F', 'Ativo', 6),
('Sensor Gás 7', '107G', 'Inativo', 7),
('Sensor Gás 8', '108H', 'Ativo', 8),
('Sensor Gás 9', '109I', 'Ativo', 9),
('Sensor Gás 10', '110J', 'Inativo', 10);


-- Tabela apartamento
INSERT INTO apartamento (blocoApartamento, numApartamento, metragem, andar, fkCondominioApartamento) VALUES
('A', '101', 60, 1, 1),
('B', '102', 65, 2, 2),
('C', '103', 70, 3, 3),
('D', '104', 75, 4, 4),
('E', '105', 80, 5, 5),
('F', '106', 85, 6, 6),
('G', '107', 90, 7, 7),
('H', '108', 95, 8, 8),
('I', '109', 100, 9, 9),
('J', '110', 105, 10, 10);

-- Tabela alerta
INSERT INTO alerta (fkSensorAlerta, statusAlerta) VALUES
(1, 'Seguro'),
(2, 'Atenção'),
(3, 'Alerta'),
(4, 'Perigo'),
(5, 'Emergência'),
(6, 'Seguro'),
(7, 'Atenção'),
(8, 'Alerta'),
(9, 'Perigo'),
(10, 'Emergência');

-- Tabela medicao 
INSERT INTO medicao (concentracaoGases, fkSensor) VALUES
(3.2, 1),
(5.8, 2);

-- Tabela contato
INSERT INTO contato (assunto, email, mensagem, fkCondominioContato) VALUES
('Dúvida sobre gás', 'contato1@exemplo.com', 'Gostaria de saber sobre segurança do gás.', 1),
('Alerta estranho', 'contato2@exemplo.com', 'Recebi um alerta de perigo sem razão.', 2),
('Erro no sensor', 'contato3@exemplo.com', 'O sensor está desligando sozinho.', 3),
('Problema na medição', 'contato4@exemplo.com', 'Medições incorretas estão sendo registradas.', 4),
('Ajuda com acesso', 'contato5@exemplo.com', 'Não consigo acessar o sistema.', 5),
('Troca de sensor', 'contato6@exemplo.com', 'Solicito substituição do sensor.', 6),
('Informações gerais', 'contato7@exemplo.com', 'Gostaria de informações sobre o sistema.', 7),
('Aviso constante', 'contato8@exemplo.com', 'Recebo muitos avisos seguidos.', 8),
('Bug visual', 'contato9@exemplo.com', 'A interface apresenta falhas.', 9),
('Sugestão', 'contato10@exemplo.com', 'Sugiro melhorias na usabilidade.', 10);


SELECT * FROM condominio;


SELECT * FROM login;


SELECT * FROM apartamento;


SELECT * FROM sensor;


SELECT * FROM contato;


SELECT * FROM medicao;


SELECT * FROM alerta;


SELECT * FROM condominio WHERE nome LIKE '%A';


SELECT * FROM apartamento WHERE blocoApartamento = 'd';


SELECT * FROM condominio AS c JOIN apartamento AS a 
ON c.idCondominio = a.fkCondominioApartamento;


SELECT 
  c.nome AS nome_condominio,
  l.cnpj AS cnpj_login,
  s.nome AS nome_sensor,
  al.statusAlerta AS status_alerta,
  m.concentracaoGases AS concentracao_gases,
  CONCAT('bloco', a.blocoApartamento, '-', a.numApartamento) AS apartamento
FROM condominio AS c
JOIN login AS l ON c.idCondominio = l.fkCondominio
JOIN sensor AS s ON c.idCondominio = s.fkCondominioSensor
JOIN alerta AS al ON s.idSensor = al.fkSensorAlerta
JOIN medicao AS m ON s.idSensor = m.fkSensor
JOIN apartamento AS a ON c.idCondominio = a.fkCondominioApartamento;


SELECT 
  c.nome AS nome_condominio,
  l.cnpj AS cnpj_login,
  s.nome AS nome_sensor,
  al.statusAlerta AS status_alerta,
  m.concentracaoGases AS concentracao_gases,
  CONCAT(a.blocoApartamento, '-', a.numApartamento) AS apartamento
FROM condominio AS c
JOIN login AS l ON c.idCondominio = l.fkCondominio
JOIN sensor AS s ON c.idCondominio = s.fkCondominioSensor
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
JOIN sensor AS s ON c.idCondominio = s.fkCondominioSensor
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
JOIN sensor AS s ON c.idCondominio = s.fkCondominioSensor
JOIN alerta AS al ON s.idSensor = al.fkSensorAlerta
JOIN medicao AS m ON s.idSensor = m.fkSensor
JOIN apartamento AS a ON c.idCondominio = a.fkCondominioApartamento
ORDER BY c.nome, classificacao_gas DESC;