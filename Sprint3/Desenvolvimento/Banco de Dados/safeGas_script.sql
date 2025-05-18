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
senha VARCHAR(30) NOT NULL,
fkCondominioPortaria INT not null,
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
select * from alerta;
UPDATE alerta 
SET fkMedicao = 9, 
    fkSensorMedicao = 2, 
    fkApartamentoMedicao = 2, 
    fkPredioMedicao = 2
WHERE idAlerta = 2;

INSERT INTO condominio (nome_condominio, cep, logradouro, numero_logradouro, cnpj, dt_cadastro_condominio) VALUES
('Condomínio Sol', '12345678900', 'Rua das Flores', '100', '12345678000101', '2023-01-10'),
('Condomínio Lua', '23456789001', 'Av. Estrelas', '200', '23456789000102', '2023-02-15'),
('Condomínio Mar', '34567890123', 'Rua do Mar', '300', '34567890000103', '2023-03-20'),
('Condomínio Céu', '45678901234', 'Travessa Céu Azul', '400', '45678901000104', '2023-04-25'),
('Condomínio Terra', '56789012345', 'Av. Terra Nova', '500', '56789012000105', '2023-05-30');

INSERT INTO portaria (numero_portaria, telefone, dt_cadastro_port, email, senha, fkCondominioPortaria) VALUES
('1', '11999999999', '2023-01-12', 'portaria1a@sol.com', 'senha123', 1),
('2', '11999999998', '2023-01-13', 'portaria1b@sol.com', 'senha124', 1),
('1', '11988888888', '2023-02-18', 'portaria2@lua.com', 'senha234', 2),
('1', '11977777777', '2023-03-22', 'portaria3a@mar.com', 'senha345', 3),
('2', '11977777776', '2023-03-23', 'portaria3b@mar.com', 'senha346', 3),
('1', '11966666666', '2023-04-28', 'portaria4@ceu.com', 'senha456', 4),
('1', '11955555555', '2023-06-01', 'portaria5a@terra.com', 'senha567', 5),
('2', '11955555554', '2023-06-02', 'portaria5b@terra.com', 'senha568', 5);

INSERT INTO predio (bloco_predio, fkPortariaPredio) VALUES
('A', 1),
('B', 2),
('A', 4), 
('B', 5), 
('C', 7); 


INSERT INTO atendimento (idAtendimento, fkPortaria, fkPredio, fkCondominio) VALUES
(1, 1, 1, 1),
(2, 2, 2, 2),
(3, 3, 3, 3),
(4, 4, 4, 4),
(5, 5, 5, 5);

INSERT INTO apartamento (numero_apartamento, andar_apartamento, fkPredioApto) VALUES
('101', 1, 1),
('202', 2, 2),
('303', 3, 3),
('404', 4, 4),
('505', 5, 5);

INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES
('Ativo', 'Cozinha', 1, 1),
('Ativo', 'Sala', 2, 2),
('Inativo', 'Quarto', 3, 3),
('Ativo', 'Área de Serviço', 4, 4),
('Inativo', 'Banheiro', 5, 5);

INSERT INTO alerta (statusAlerta) VALUES
('Seguro'),
('Atenção'),
('Alerta'),
('Emergência'),
('Seguro');

INSERT INTO medicao (fkSensorMedicao, fkApartamentoMedicao, fkPredioMedicao, nivel_de_gas) VALUES
(1, 1, 1, 0.3),
(2, 2, 2, 0.7),
(3, 3, 3, 1.5),
(4, 4, 4, 2.8),
(5, 5, 5, 3.9);

INSERT INTO alerta (risco, acao, fkSensorMedicao, fkApartamentoMedicao, fkPredioMedicao) VALUES 
	('Explosão', 'Ventilar apartamento',1, 1, 1),
    ('Asfixia', 'ligar Bombeiros',2, 2, 2);

update alerta set statusAlerta = 'Alerta' where idAlerta = 1;
update alerta set statusAlerta = 'Emergência' where idAlerta = 2;

select c.nome_condominio as Condomínio, c.dt_cadastro_condominio as Data_Cad, pt.numero_portaria as Portaria, count(s.idSensor) as Total_Sensores,
	m.data_hora as Hora_Medição, p.bloco_predio as Bloco, ap.andar_apartamento as Andar, a.acao as Ação, a.risco as Risco, s.local_instalado from condominio c join portaria pt on c.idCondominio = pt.fkCondominioPortaria
    join predio p on pt.idPortaria = p.fkPortariaPredio join apartamento ap on ap.fkPredioApto = p.idPredio join sensor s on s.fkApartamento = ap.idApartamento join medicao m on m.fkSensorMedicao = s.idSensor join 
    alerta a on a.fkSensorMedicao = m.idMedicao group by c.nome_condominio;
    
-- seletão é o de cima --  


SELECT 
    c.nome_condominio AS Condomínio, 
    c.dt_cadastro_condominio AS Data_Cad, 
    pt.numero_portaria AS Portaria, 
    COUNT(DISTINCT s.idSensor) AS Total_Sensores,
    MAX(m.data_hora) AS Última_Medição,  -- Ou outra função de agregação
    p.bloco_predio AS Bloco, 
    ap.andar_apartamento AS Andar, 
    a.acao AS Ação, 
    a.risco AS Risco, 
    s.local_instalado 
FROM condominio c 
JOIN portaria pt ON c.idCondominio = pt.fkCondominioPortaria
JOIN predio p ON pt.idPortaria = p.fkPortariaPredio 
JOIN apartamento ap ON ap.fkPredioApto = p.idPredio 
JOIN sensor s ON s.fkApartamento = ap.idApartamento 
JOIN medicao m ON m.fkSensorMedicao = s.idSensor 
JOIN alerta a ON a.fkMedicao = m.idMedicao  -- Corrigido aqui
GROUP BY 
    c.nome_condominio, 
    c.dt_cadastro_condominio,
    pt.numero_portaria,
    p.bloco_predio,
    ap.andar_apartamento,
    a.acao,
    a.risco,
    s.local_instalado;


/*
navbar
seletaoDeApartamentos
nomeCondominio - condominio
data_de_cadastro - condominio
numero_portaria - portaria

Kpi
count idSensor - sensor -    quantidade total de sensores - count sensores
select (count(statusAlerta) where statusSensor = ('Alerta' or 'Crítico' or 'Emergência')) - alerta - quantidade de sensores em alerta ( atenção, critico, emergência) - status | tabela alerta ( fkSensor )
select (count(status_sensor) where statusSensor = 'inativo') - sensor - quantidade de sensores em manutenção - tabela sensor -- FALTA E O DE CIMA
data_hora - medicao - data/hora - medição - ultima atualização

bloco_predio - tabela prédio
andar_apartamento - numero apartamento - tabela apartamento
numero do apartamento - numero_apartamento - tabela apartamento  ( relacionar com a fktorre e fkandar )	
nivel_de_gas > 2.5 - medicao --- status do prédio - tabela medicao ( if algum prédio com a fk do prédio == nivelMedicao > default, ficar vermelho ) ----FALTA
nivel_de_gas > 2.5 - medicao  -- status do apartamento - tabela medicao ( if nivelMedicao > default, ficar vermelho ) ---- FALTA
 
notificações
saber a torre
saber o numero apto
saber o andar
------------||------
acao e risco - alerta - ação e risco 
data_hora - medicao - quando foi gerado - tabela alerta
local_instalado - sensor - local - tabela sensor*/



SELECT * FROM condominio;

SELECT * FROM portaria;

SELECT * FROM predio;

SELECT * FROM atendimento;

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