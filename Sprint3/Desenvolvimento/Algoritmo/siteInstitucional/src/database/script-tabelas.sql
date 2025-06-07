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

-- Tabela Alerta
CREATE TABLE alerta(
idAlerta INT PRIMARY KEY AUTO_INCREMENT,
statusAlerta VARCHAR(12),
	CONSTRAINT ckStatus
		CHECK (statusAlerta IN ('Seguro', 'Atenção', 'Perigo', 'Emergência')),
risco VARCHAR(50),
	CONSTRAINT ckRisco
		CHECK (risco IN ('Nenhum risco', 'Possível vazamento', 'Possibilidade de explosão', 'Possibilidade de asfixia')),
acao varchar(60),
	CONSTRAINT ckAcao
		CHECK (acao IN ('Nenhuma ação necessária', 'Ventilar o apartamento', 'Evacuar o local imediatamente', 'Ligar para os bombeiros'))

);

-- Tabela Medicao
CREATE TABLE medicao (
idMedicao INT AUTO_INCREMENT,
fkSensorMedicao INT,
fkApartamentoMedicao INT,
fkPredioMedicao INT,
fkAlertaMedicao INT,
CONSTRAINT pkCompostaMedicao PRIMARY KEY (idMedicao, fkSensorMedicao, fkApartamentoMedicao, fkPredioMedicao, fkAlertaMedicao),
CONSTRAINT fkSensorMedicao FOREIGN KEY (fkSensorMedicao) references sensor(idSensor),
CONSTRAINT fkApartamentoMedicao FOREIGN KEY (fkApartamentoMedicao) references apartamento(idApartamento),
CONSTRAINT fkPredioMedicao FOREIGN KEY (fkPredioMedicao) references predio(idPredio),
CONSTRAINT fkAlertaMedicao FOREIGN KEY (fkAlertaMedicao) references alerta(idAlerta),
data_hora DATETIME DEFAULT CURRENT_TIMESTAMP,
nivel_de_gas FLOAT NOT NULL
);








-- kpis dash geral
create view kpi as

SELECT 
    COUNT(DISTINCT s.idSensor) AS Total_Sensores,
    COUNT(DISTINCT CASE WHEN a.statusAlerta IN ('Atenção','Perigo', 'Emergência') THEN s.idSensor END) AS Sensores_Alarmantes,
    COUNT(DISTINCT CASE WHEN s.status_sensor = 'Inativo' THEN s.idSensor END) AS Sensores_Inativos,
    MAX(m.data_hora) AS Ultima_Verificacao
FROM sensor s
LEFT JOIN medicao m ON s.idSensor = m.fkSensorMedicao
LEFT JOIN alerta a ON m.fkAlertaMedicao = a.idAlerta;
select * from kpi;

-- notificações

CREATE VIEW dados AS
SELECT 
    p.bloco_predio AS Torre, -- Torre (bloco) a que o apartamento pertence
    ap.numero_apartamento AS Numero_Apartamento, -- Número do apartamento
    CASE 
        WHEN EXISTS (
            SELECT 1
            FROM medicao m_sub
            JOIN alerta a_sub ON m_sub.fkAlertaMedicao = a_sub.idAlerta
            WHERE m_sub.fkApartamentoMedicao = ap.idApartamento 
              AND a_sub.statusAlerta IN ('Atenção', 'Perigo', 'Emergência')
        ) THEN 'Nível Alarmante'
        ELSE 'Normal'
    END AS Status_Apartamento, -- Status do apartamento baseado nos sensores
    a.risco AS Descricao_Status, -- Descrição do status (ex.: possível vazamento)
    s.local_instalado AS Comodo, -- Local do sensor com nível alarmante
    m.fkSensorMedicao AS Sensor_Detector, -- ID do sensor que detectou o vazamento
    s.status_sensor AS Status_Sensor, -- Status do sensor que detectou o vazamento
    m.nivel_de_gas AS Nivel_Alarmante, -- Nível de gás do sensor em nível alarmante
    m.data_hora AS Horario_Consulta -- Data e hora da medição
FROM apartamento ap
JOIN predio p ON ap.fkPredioApto = p.idPredio
JOIN sensor s ON s.fkApartamento = ap.idApartamento AND s.status_sensor = 'Ativo' -- Considera apenas sensores ativos
JOIN medicao m ON m.fkSensorMedicao = s.idSensor
JOIN alerta a ON m.fkAlertaMedicao = a.idAlerta
WHERE a.statusAlerta IN ('Seguro','Atenção', 'Perigo', 'Emergência') -- Apenas sensores em estado alarmante
ORDER BY p.bloco_predio, ap.numero_apartamento, m.data_hora DESC; -- Ordenação por torre, apartamento e data de consulta

INSERT INTO condominio (nome_condominio, cep, logradouro, numero_logradouro, cnpj, senha) 
VALUES ('Residencial Seguro', '01234-567', 'Rua das Flores', '100', '12345678000190', 'seguranca123');

INSERT INTO portaria (numero_portaria, telefone, dt_cadastro_port, email, senha, fkCondominioPortaria) 
VALUES ('1', '11987654321', '2023-01-01', 'portaria1@residencialseguro.com', 'portaria123', 1);

INSERT INTO predio (bloco_predio, fkPortariaPredio) 
VALUES ('A', 1);

-- Andar 1
INSERT INTO apartamento (numero_apartamento, andar_apartamento, fkPredioApto) VALUES ('101', 1, 1);
INSERT INTO apartamento (numero_apartamento, andar_apartamento, fkPredioApto) VALUES ('102', 1, 1);
INSERT INTO apartamento (numero_apartamento, andar_apartamento, fkPredioApto) VALUES ('103', 1, 1);

-- Andar 2
INSERT INTO apartamento (numero_apartamento, andar_apartamento, fkPredioApto) VALUES ('201', 2, 1);
INSERT INTO apartamento (numero_apartamento, andar_apartamento, fkPredioApto) VALUES ('202', 2, 1);
INSERT INTO apartamento (numero_apartamento, andar_apartamento, fkPredioApto) VALUES ('203', 2, 1);

-- Andar 3
INSERT INTO apartamento (numero_apartamento, andar_apartamento, fkPredioApto) VALUES ('301', 3, 1);
INSERT INTO apartamento (numero_apartamento, andar_apartamento, fkPredioApto) VALUES ('302', 3, 1);
INSERT INTO apartamento (numero_apartamento, andar_apartamento, fkPredioApto) VALUES ('303', 3, 1);

-- Andar 4
INSERT INTO apartamento (numero_apartamento, andar_apartamento, fkPredioApto) VALUES ('401', 4, 1);
INSERT INTO apartamento (numero_apartamento, andar_apartamento, fkPredioApto) VALUES ('402', 4, 1);
INSERT INTO apartamento (numero_apartamento, andar_apartamento, fkPredioApto) VALUES ('403', 4, 1);

-- Andar 5
INSERT INTO apartamento (numero_apartamento, andar_apartamento, fkPredioApto) VALUES ('501', 5, 1);
INSERT INTO apartamento (numero_apartamento, andar_apartamento, fkPredioApto) VALUES ('502', 5, 1);
INSERT INTO apartamento (numero_apartamento, andar_apartamento, fkPredioApto) VALUES ('503', 5, 1);

-- Andar 6
INSERT INTO apartamento (numero_apartamento, andar_apartamento, fkPredioApto) VALUES ('601', 6, 1);
INSERT INTO apartamento (numero_apartamento, andar_apartamento, fkPredioApto) VALUES ('602', 6, 1);
INSERT INTO apartamento (numero_apartamento, andar_apartamento, fkPredioApto) VALUES ('603', 6, 1);

INSERT INTO alerta (statusAlerta, risco, acao) VALUES 
('Seguro', 'Nenhum risco', 'Nenhuma ação necessária'),
('Atenção', 'Possível vazamento', 'Ventilar o apartamento'),
('Perigo', 'Possibilidade de explosão', 'Evacuar o local imediatamente'),
('Emergência', 'Possibilidade de asfixia', 'Ligar para os bombeiros');

-- Sensores Ativos (49 sensores)
-- Apartamento 101
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Banheiro', 1, 1);
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Quarto', 1, 1);
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Cozinha', 1, 1);

-- Apartamento 102
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Banheiro', 2, 1);
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Quarto', 2, 1);
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Cozinha', 2, 1);

-- Apartamento 103
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Banheiro', 3, 1);
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Quarto', 3, 1);
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Cozinha', 3, 1);

-- Apartamento 201
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Banheiro', 4, 1);
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Quarto', 4, 1);
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Cozinha', 4, 1);

-- Apartamento 202
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Banheiro', 5, 1);
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Quarto', 5, 1);
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Cozinha', 5, 1);

-- Apartamento 203
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Banheiro', 6, 1);
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Quarto', 6, 1);
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Cozinha', 6, 1);

-- Apartamento 301
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Banheiro', 7, 1);
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Quarto', 7, 1);
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Cozinha', 7, 1);

-- Apartamento 302
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Banheiro', 8, 1);
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Quarto', 8, 1);
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Cozinha', 8, 1);

-- Apartamento 303
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Banheiro', 9, 1);
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Quarto', 9, 1);
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Cozinha', 9, 1);

-- Apartamento 401
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Banheiro', 10, 1);
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Quarto', 10, 1);
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Cozinha', 10, 1);

-- Apartamento 402
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Banheiro', 11, 1);
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Quarto', 11, 1);
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Cozinha', 11, 1);

-- Apartamento 403
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Banheiro', 12, 1);
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Quarto', 12, 1);
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Cozinha', 12, 1);

-- Apartamento 501
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Banheiro', 13, 1);
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Quarto', 13, 1);
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Cozinha', 13, 1);

-- Apartamento 502
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Banheiro', 14, 1);
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Quarto', 14, 1);
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Cozinha', 14, 1);

-- Apartamento 503
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Banheiro', 15, 1);
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Quarto', 15, 1);
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Cozinha', 15, 1);

-- Apartamento 601 (5 sensores inativos aqui)
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Inativo', 'Banheiro', 16, 1);
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Inativo', 'Quarto', 16, 1);
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Inativo', 'Cozinha', 16, 1);

-- Apartamento 602 (2 sensores inativos aqui)
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Inativo', 'Banheiro', 17, 1);
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Quarto', 17, 1);
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Cozinha', 17, 1);

-- Apartamento 603 (todos ativos)
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Banheiro', 18, 1);
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Quarto', 18, 1);
INSERT INTO sensor (status_sensor, local_instalado, fkApartamento, fkPredio) VALUES ('Ativo', 'Cozinha', 18, 1);

-- Caso 1: Sensor Seguro (nível de gás 1.5%)
INSERT INTO medicao (fkSensorMedicao, fkApartamentoMedicao, fkPredioMedicao, fkAlertaMedicao, nivel_de_gas) 
VALUES (1, 1, 1, 1, 13.5);

-- Caso 2: Sensor em Atenção (nível de gás 3.0%)
INSERT INTO medicao (fkSensorMedicao, fkApartamentoMedicao, fkPredioMedicao, fkAlertaMedicao, nivel_de_gas) 
VALUES (2, 1, 1, 2, 3.0);

-- Caso 3: Sensor em Perigo (nível de gás 8.0%)
INSERT INTO medicao (fkSensorMedicao, fkApartamentoMedicao, fkPredioMedicao, fkAlertaMedicao, nivel_de_gas) 
VALUES (3, 1, 1, 3, 8.0);

-- Medições adicionais para outros sensores (todos seguros)
INSERT INTO medicao (fkSensorMedicao, fkApartamentoMedicao, fkPredioMedicao, fkAlertaMedicao, nivel_de_gas) 
VALUES 
(4, 2, 1, 1, 0.8),
(5, 2, 1, 1, 1.2),
(6, 2, 1, 1, 1.0),
(7, 3, 1, 1, 1.8),
(8, 3, 1, 1, 2.0),
(9, 3, 1, 1, 1.5),
(10, 4, 1, 1, 0.5),
(11, 4, 1, 1, 1.0),
(12, 4, 1, 1, 0.7),
(13, 5, 1, 1, 1.2),
(14, 5, 1, 1, 1.3),
(15, 5, 1, 1, 1.1),
(16, 6, 1, 1, 0.9),
(17, 6, 1, 1, 1.0),
(18, 6, 1, 1, 1.2),
(19, 7, 1, 1, 1.5),
(20, 7, 1, 1, 1.6),
(21, 7, 1, 1, 1.4),
(22, 8, 1, 1, 1.7),
(23, 8, 1, 1, 1.8),
(24, 8, 1, 1, 1.9),
(25, 9, 1, 1, 2.0),
(26, 9, 1, 1, 2.1),
(27, 9, 1, 1, 2.0),
(28, 10, 1, 1, 1.5),
(29, 10, 1, 1, 1.6),
(30, 10, 1, 1, 1.4),
(31, 11, 1, 1, 1.2),
(32, 11, 1, 1, 1.3),
(33, 11, 1, 1, 1.1),
(34, 12, 1, 1, 0.8),
(35, 12, 1, 1, 0.9),
(36, 12, 1, 1, 0.7),
(37, 13, 1, 1, 1.0),
(38, 13, 1, 1, 1.1),
(39, 13, 1, 1, 0.9),
(40, 14, 1, 1, 1.2),
(41, 14, 1, 1, 1.3),
(42, 14, 1, 1, 1.1),
(43, 15, 1, 1, 1.4),
(44, 15, 1, 1, 1.5),
(45, 15, 1, 1, 1.3),
(46, 16, 1, 1, 0.0),  -- Sensor inativo
(47, 16, 1, 1, 0.0),  -- Sensor inativo
(48, 16, 1, 1, 0.0),  -- Sensor inativo
(49, 17, 1, 1, 0.0),  -- Sensor inativo
(50, 17, 1, 1, 1.2),
(51, 17, 1, 1, 1.1),
(52, 18, 1, 1, 1.3),
(53, 18, 1, 1, 1.4),
(54, 18, 1, 1, 1.2);


-- predio
SELECT * from predio;

-- total andares
create view andares as
SELECT 
    FLOOR(ap.numero_apartamento / 100) AS Andar, -- Calcula o andar com base no número do apartamento
    COUNT(ap.numero_apartamento) AS Quantidade_Apartamentos -- Conta o número de apartamentos por andar
FROM apartamento ap
GROUP BY Andar -- Agrupamento por andar
ORDER BY Quantidade_Apartamentos DESC; -- Ordenação pelo maior número de apartamentos por andar


select * from andares;



-- apartamentos
create view apGeral as
SELECT     
FLOOR(ap.numero_apartamento / 100) AS Andar, -- Calcula o andar com base no número do apartamento
    ap.numero_apartamento AS Numero_Apartamento, -- Número do apartamento
    s.status_sensor AS Status_Sensor, -- Status do sensor
    MAX(m.nivel_de_gas) AS Nivel_Mais_Alto -- Nível mais alto de gás no apartamento
FROM apartamento ap
JOIN sensor s ON s.fkApartamento = ap.idApartamento
JOIN medicao m ON m.fkSensorMedicao = s.idSensor
where m.data_hora >= DATE_SUB(NOW(), INTERVAL 24 HOUR) 
GROUP BY Andar, ap.numero_apartamento, s.status_sensor -- Agrupamento por andar, apartamento e status do sensor
ORDER BY Andar, MAX(m.nivel_de_gas) DESC; -- Ordenação por andar e maior nível de gás em ordem decrescente


select * from apGeral;

select * from apartamento as a join predio as p on a.fkPredioApto = p.idPredio;

select * from kpi;

select * from dados;

SELECT 
    p.bloco_predio AS Torre, -- Torre (bloco) a que o apartamento pertence
    ap.numero_apartamento AS Numero_Apartamento, -- Número do apartamento
    CASE 
        WHEN EXISTS (
            SELECT 1
            FROM medicao m_sub
            JOIN alerta a_sub ON m_sub.fkAlertaMedicao = a_sub.idAlerta
            WHERE m_sub.fkApartamentoMedicao = ap.idApartamento 
              AND a_sub.statusAlerta IN ('Atenção', 'Perigo', 'Emergência')
        ) THEN 'Nível Alarmante'
        ELSE 'Normal'
    END AS Status_Apartamento, --	 Status do apartamento baseado nos sensores
    a.risco AS Descricao_Status, -- Descrição do status (ex.: possível vazamento)
    s.local_instalado AS Comodo, -- Local do sensor com nível alarmante
    m.fkSensorMedicao AS Sensor_Detector, -- ID do sensor que detectou o vazamento
    s.status_sensor AS Status_Sensor, -- Status do sensor que detectou o vazamento
    m.nivel_de_gas AS Nivel_Alarmante, -- Nível de gás do sensor em nível alarmante
    m.data_hora AS Horario_Consulta -- Data e hora da medição
FROM apartamento ap
JOIN predio p ON ap.fkPredioApto = p.idPredio
JOIN sensor s ON s.fkApartamento = ap.idApartamento AND s.status_sensor = 'Ativo' -- Considera apenas sensores ativos
JOIN medicao m ON m.fkSensorMedicao = s.idSensor
JOIN alerta a ON m.fkAlertaMedicao = a.idAlerta
WHERE ap.idApartamento = 1 -- Apenas sensores em estado alarmante
ORDER BY m.data_hora; -- Ordenação por torre, apartamento e data de consulta

-- sensores, medicoes e status
SELECT 
    m.idMedicao AS 'ID Medição',
    s.idSensor AS 'ID Sensor',
    s.local_instalado AS 'Local do Sensor',
    s.status_sensor AS 'Status do Sensor',
    a.statusAlerta AS 'Status Alerta',
    a.risco AS 'Descricao_Status',
    a.acao AS 'Ação Recomendada',
    m.nivel_de_gas AS 'Nível de Gás',
    m.data_hora AS 'Data/Hora Medição'
FROM 
    medicao m
JOIN 
    sensor s ON m.fkSensorMedicao = s.idSensor
JOIN 
    alerta a ON m.fkAlertaMedicao = a.idAlerta
WHERE 
    a.statusAlerta IN ('Perigo', 'Atenção', 'Emergência')
ORDER BY 
    m.data_hora DESC;

-- ap, sensor, medicao
create view notificacoes as
SELECT 
    ap.idApartamento AS ID_Apartamento,
    ap.numero_apartamento AS Numero_Apartamento,
    ap.andar_apartamento AS Andar,
    p.bloco_predio AS Bloco_Predio,
    s.idSensor AS ID_Sensor,
    s.local_instalado AS Local_do_Sensor,
    MAX(m.nivel_de_gas) AS Maior_Nivel_de_Gas,
    a.statusAlerta AS tatus_Alerta,
    a.risco AS Descricao_Risco,
    a.acao AS Acao_Recomendada,
    MAX(m.data_hora) AS Hora_da_ultima_Medicao
FROM 
    apartamento ap
JOIN 
    predio p ON ap.fkPredioApto = p.idPredio
JOIN 
    sensor s ON s.fkApartamento = ap.idApartamento
JOIN 
    medicao m ON m.fkSensorMedicao = s.idSensor
JOIN 
    alerta a ON m.fkAlertaMedicao = a.idAlerta
WHERE 
     m.data_hora >= DATE_SUB(NOW(), INTERVAL 24 HOUR) AND
     a.statusAlerta IN ('seguro', 'Perigo', 'Atenção', 'Emergência')
GROUP BY 
    ap.idApartamento, ap.numero_apartamento, ap.andar_apartamento, 
    p.bloco_predio, s.idSensor, s.local_instalado, 
    a.statusAlerta, a.risco, a.acao
ORDER BY 
    p.bloco_predio, ap.andar_apartamento, ap.numero_apartamento, 
    MAX(m.nivel_de_gas) DESC;
    
	select * from notificacoes;
    
    
select * from medicao where fkSensorMedicao = 1 order by data_hora desc;

select * from apartamento as a join medicao as m on fkApartamentoMedicao = 1
where m.fkApartamentoMedicao = 1  order by data_hora desc limit 10;

SELECT * 
FROM apartamento AS a
JOIN medicao AS m ON a.idApartamento = m.fkApartamentoMedicao
WHERE m.fkApartamentoMedicao = 1
ORDER BY m.data_hora DESC
LIMIT 10;

select * from medicao where fkSensorMedicao = 1 order by data_hora desc;


select * from alerta;	
select * from apartamento;




select * from sensor where status_sensor = 'Inativo';

SELECT COUNT(*) AS total_sensores_inativos
FROM sensor
WHERE status_sensor = 'Inativo';

	select * from notificacoes;


SELECT
    ap.numero_apartamento AS Numero_Apartamento,
    s.status_sensor AS Status_Sensor,
    MAX(m.nivel_de_gas) AS Nivel_Mais_Alto
FROM apartamento ap
JOIN sensor s ON s.fkApartamento = ap.idApartamento
JOIN medicao m ON m.fkSensorMedicao = s.idSensor
GROUP BY ap.numero_apartamento, s.status_sensor
ORDER BY MAX(m.nivel_de_gas) DESC;


	SELECT     
    ap.numero_apartamento AS Numero_Apartamento, -- Número do apartamento
    s.status_sensor AS Status_Sensor, -- Status do sensor
    MAX(m.nivel_de_gas) AS Nivel_Mais_Alto -- Nível mais alto de gás no apartamento
FROM apartamento ap
JOIN sensor s ON s.fkApartamento = ap.idApartamento
JOIN medicao m ON m.fkSensorMedicao = s.idSensor
where m.data_hora >= DATE_SUB(NOW(), INTERVAL 24 HOUR) 
GROUP BY ap.numero_apartamento, s.status_sensor -- Agrupamento por andar, apartamento e status do sensor
ORDER BY MAX(m.nivel_de_gas) DESC; -- Ordenação por andar e maior nível de gás em ordem decrescente
        ;
        
             	select * from notificacoes;
                
                
                select * from sensor where status_sensor = "Inativo";
                
                   select * from kpi;
                   

SELECT 
    COUNT(DISTINCT s.idSensor) AS Total_Sensores,
    COUNT(DISTINCT CASE WHEN a.statusAlerta IN ('Atenção','Perigo', 'Emergência') THEN s.idSensor END) AS Sensores_Alarmantes,
    COUNT(DISTINCT CASE WHEN s.status_sensor = 'Inativo' THEN s.idSensor END) AS Sensores_Inativos,
    MAX(m.data_hora) AS Ultima_Verificacao
FROM sensor s
LEFT JOIN medicao m ON s.idSensor = m.fkSensorMedicao
LEFT JOIN alerta a ON m.fkAlertaMedicao = a.idAlerta;



SELECT 
    s.idSensor AS ID_Sensor,
    s.local_instalado AS Local_Instalado,
    a.statusAlerta AS Status_Alerta,
    a.risco AS Risco_Detectado,
    a.acao AS Acao_Recomendada,
    m.nivel_de_gas AS Nivel_Gas,
    m.data_hora AS Data_Hora_Medicao,
    ap.numero_apartamento AS Apartamento,
    p.bloco_predio AS Torre
FROM sensor s
JOIN medicao m ON s.idSensor = m.fkSensorMedicao
JOIN alerta a ON m.fkAlertaMedicao = a.idAlerta
JOIN apartamento ap ON s.fkApartamento = ap.idApartamento
JOIN predio p ON ap.fkPredioApto = p.idPredio
WHERE a.statusAlerta IN ('Atenção', 'Perigo', 'Emergência')
ORDER BY m.data_hora DESC;


SELECT 
    s.idSensor AS 'ID Sensor',
    s.local_instalado AS 'Local Instalado',
    s.status_sensor AS 'Status',
    ap.numero_apartamento AS 'Apartamento',
    p.bloco_predio AS 'Torre',
    MAX(m.data_hora) AS 'Última Medição',
    COALESCE(MAX(m.nivel_de_gas), 0) AS 'Último Nível de Gás Registrado'
FROM 
    sensor s
JOIN 
    apartamento ap ON s.fkApartamento = ap.idApartamento
JOIN 
    predio p ON ap.fkPredioApto = p.idPredio
LEFT JOIN 
    medicao m ON s.idSensor = m.fkSensorMedicao
WHERE 
    s.status_sensor = 'Inativo'
GROUP BY 
    s.idSensor, s.local_instalado, s.status_sensor, 
    ap.numero_apartamento, p.bloco_predio
ORDER BY 
    p.bloco_predio, ap.numero_apartamento, s.local_instalado;
    
    
    SELECT 
    s.idSensor AS 'ID',
    s.local_instalado AS 'Local',
    ap.numero_apartamento AS 'Apto',
    p.bloco_predio AS 'Torre'
FROM 
    sensor s
JOIN 
    apartamento ap ON s.fkApartamento = ap.idApartamento
JOIN 
    predio p ON ap.fkPredioApto = p.idPredio
WHERE 
    s.status_sensor = 'Inativo'
ORDER BY 
    p.bloco_predio, ap.numero_apartamento;	
    
    
    
    SELECT 
    p.bloco_predio AS Torre,
    ap.numero_apartamento AS Numero_Apartamento,
    a.statusAlerta AS Categoria_Alerta,
    CASE a.statusAlerta
        WHEN 'Seguro' THEN 'Normal'
        WHEN 'Atenção' THEN 'Atenção - Monitorar'
        WHEN 'Perigo' THEN 'Perigo - Ação Necessária'
        WHEN 'Emergência' THEN 'Emergência - Evacuar'
        ELSE a.statusAlerta
    END AS Status_Descricao,
    s.local_instalado AS Comodo,
    m.nivel_de_gas AS Nivel_Gas,
    a.risco AS Risco_Detectado,
    a.acao AS Acao_Recomendada,
    m.data_hora AS Data_Hora_Medicao
FROM apartamento ap
JOIN predio p ON ap.fkPredioApto = p.idPredio
JOIN sensor s ON s.fkApartamento = ap.idApartamento AND s.status_sensor = 'Ativo'
JOIN medicao m ON m.fkSensorMedicao = s.idSensor
JOIN alerta a ON m.fkAlertaMedicao = a.idAlerta
ORDER BY 
    p.bloco_predio,
    ap.numero_apartamento,
    CASE a.statusAlerta
        WHEN 'Emergência' THEN 1
        WHEN 'Perigo' THEN 2
        WHEN 'Atenção' THEN 3
        ELSE 4
    END,
    m.data_hora DESC;
    
      SELECT
    ap.numero_apartamento AS Numero_Apartamento,
    s.status_sensor AS Status_Sensor,
    MAX(m.nivel_de_gas) AS Nivel_Mais_Alto
FROM apartamento ap
JOIN sensor s ON s.fkApartamento = ap.idApartamento
JOIN medicao m ON m.fkSensorMedicao = s.idSensor
GROUP BY ap.numero_apartamento, s.status_sensor
ORDER BY MAX(m.nivel_de_gas) DESC;
	
    

    
        SELECT 
    ap.idApartamento AS ID_Apartamento,
    ap.numero_apartamento AS Numero_Apartamento,
    ap.andar_apartamento AS Andar,
    p.bloco_predio AS Bloco_Predio,
    s.idSensor AS ID_Sensor,
    s.local_instalado AS Local_do_Sensor,
    MAX(m.nivel_de_gas) AS Maior_Nivel_de_Gas,
    a.statusAlerta AS tatus_Alerta,
    a.risco AS Descricao_Risco,
    a.acao AS Acao_Recomendada,
    MAX(m.data_hora) AS Hora_da_ultima_Medicao
FROM 
    apartamento ap
JOIN 
    predio p ON ap.fkPredioApto = p.idPredio
JOIN 
    sensor s ON s.fkApartamento = ap.idApartamento
JOIN 
    medicao m ON m.fkSensorMedicao = s.idSensor
JOIN 
    alerta a ON m.fkAlertaMedicao = a.idAlerta
WHERE 
   
     a.statusAlerta IN ('seguro', 'Perigo', 'Atenção', 'Emergência')
GROUP BY 
    ap.idApartamento, ap.numero_apartamento, ap.andar_apartamento, 
    p.bloco_predio, s.idSensor, s.local_instalado, 
    a.statusAlerta, a.risco, a.acao
ORDER BY 
    p.bloco_predio, ap.andar_apartamento, ap.numero_apartamento, 
    MAX(m.nivel_de_gas) DESC;
    
    
    
    -- para o ap
    SELECT 
    ap.numero_apartamento AS 'Número Apartamento',
    p.bloco_predio AS 'Bloco/Prédio',
    s.idSensor AS 'ID Sensor',
    s.local_instalado AS 'Localização',
    s.status_sensor AS 'Status',
    MAX(m.nivel_de_gas) AS 'Última Medição',
    MAX(m.data_hora) AS 'Data/Hora Última Medição',
    a.statusAlerta AS 'Status Alerta',
    a.risco AS 'Risco Detectado',
    a.acao AS 'Ação Recomendada'
FROM 
    apartamento ap
JOIN 
    predio p ON ap.fkPredioApto = p.idPredio
JOIN 
    sensor s ON s.fkApartamento = ap.idApartamento
LEFT JOIN 
    medicao m ON m.fkSensorMedicao = s.idSensor
LEFT JOIN 
    alerta a ON m.fkAlertaMedicao = a.idAlerta
WHERE 
    m.fkApartamentoMedicao = 1  
GROUP BY 
    ap.numero_apartamento, p.bloco_predio, s.idSensor, s.local_instalado, 
    s.status_sensor, a.statusAlerta, a.risco, a.acao
ORDER BY 
    s.local_instalado;
    
    
    -- planta
    
        SELECT 
    ap.numero_apartamento AS 'Número Apartamento',
    p.bloco_predio AS 'Bloco/Prédio',
    s.idSensor AS 'ID Sensor',
    s.local_instalado AS 'Localização',
    s.status_sensor AS 'Status',
    MAX(m.nivel_de_gas) AS 'Última Medição',
    MAX(m.data_hora) AS 'Data/Hora Última Medição',
    a.statusAlerta AS 'Status Alerta',
    a.risco AS 'Risco Detectado',
    a.acao AS 'Ação Recomendada'
FROM 
    apartamento ap
JOIN 
    predio p ON ap.fkPredioApto = p.idPredio
JOIN 
    sensor s ON s.fkApartamento = ap.idApartamento
LEFT JOIN 
    medicao m ON m.fkSensorMedicao = s.idSensor
LEFT JOIN 
    alerta a ON m.fkAlertaMedicao = a.idAlerta
WHERE 
     m.fkApartamentoMedicao = 1
GROUP BY 
    ap.numero_apartamento, p.bloco_predio, s.idSensor, s.local_instalado, 
    s.status_sensor, a.statusAlerta, a.risco, a.acao
ORDER BY 
    s.local_instalado;