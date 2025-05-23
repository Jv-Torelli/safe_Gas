CREATE DATABASE sgc;
USE sgc;
-- drop database sgc;

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



-- alter table alerta add column fkMedicao int;
-- alter table alerta add constraint fkMedicao foreign key (fkMedicao, fkSensorMedicao, fkApartamentoMedicao, fkPredioMedicao ) references medicao(idMedicao, fkSensorMedicao, fkApartamentoMedicao, fkPredioMedicao);
-- esses dois de cima eu só fiz pq tava errado a tabela antes, mas ja add na prórpia tabela alerta, ent NÃO precisa fazer nada, so deixei para caso precise fazer algo, mais para nosso controle

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

INSERT INTO alerta (statusAlerta, risco, acao) VALUES
('Seguro', 'Nenhum risco', 'Nenhuma ação necessária'),
('Atenção', 'Possível vazamento', 'Ventilar o apartamento'),
('Perigo', 'Possibilidade de explosão', 'Evacuar o local imediatamente'),
('Emergência', 'Possibilidade de asfixia', 'Ligar para os bombeiros');

-- INSERT INTO medicao (fkSensorMedicao, fkApartamentoMedicao, fkPredioMedicao, fkAlertaMedicao, nivel_de_gas) VALUES
-- (1, 1, 1, 1, 0.3),
-- (2, 2, 2, 2, 0.7),
-- (3, 3, 3, 3, 1.5),
-- (4, 4, 4, 4, 2.8),
-- (5, 5, 5, 5, 3.9);
    
-- seletão/view é o de baixo --  
CREATE VIEW dados as
    SELECT 
    c.nome_condominio AS Condomínio, 
    c.dt_cadastro_condominio AS Data_Cad, 
    pt.numero_portaria AS Portaria, 
    
    /* Total de sensores do condomínio */
    (SELECT COUNT(DISTINCT s_total.idSensor)
     FROM sensor s_total
     JOIN apartamento ap_total ON s_total.fkApartamento = ap_total.idApartamento
     JOIN predio p_total ON ap_total.fkPredioApto = p_total.idPredio
     JOIN portaria pt_total ON p_total.fkPortariaPredio = pt_total.idPortaria
     WHERE pt_total.fkCondominioPortaria = c.idCondominio
    ) AS Total_Sensores_Condomínio,
    
    /* Sensores inativos/em manutenção */
    (SELECT COUNT(DISTINCT s_inativo.idSensor)
     FROM sensor s_inativo
     JOIN apartamento ap_inativo ON s_inativo.fkApartamento = ap_inativo.idApartamento
     JOIN predio p_inativo ON ap_inativo.fkPredioApto = p_inativo.idPredio
     JOIN portaria pt_inativo ON p_inativo.fkPortariaPredio = pt_inativo.idPortaria
     WHERE pt_inativo.fkCondominioPortaria = c.idCondominio
     AND s_inativo.status_sensor = 'Inativo'
    ) AS Sensores_Em_Manutencao,
    
    MAX(m.data_hora) AS Última_Medição, 
    p.bloco_predio AS Bloco, 
    ap.andar_apartamento AS Andar,
    ap.numero_apartamento AS Numero_Apartamento,
    m.nivel_de_gas AS Nível_de_Gás,
    a.acao AS Ação, 
    a.risco AS Risco, 
    s.local_instalado,
    s.status_sensor AS Status_Sensor,
    
    /* Alertas críticos */
    (SELECT COUNT(*) 
     FROM alerta al 
     WHERE m.fkAlertaMedicao = al.idAlerta           -- POSSÍVEL ERRO AQUI
     AND al.statusAlerta IN ('Alerta', 'Crítico', 'Emergência')
    ) AS Num_Sensor_Alertas_AP
    
FROM condominio c 
JOIN portaria pt ON c.idCondominio = pt.fkCondominioPortaria
JOIN predio p ON pt.idPortaria = p.fkPortariaPredio 
JOIN apartamento ap ON ap.fkPredioApto = p.idPredio 
JOIN sensor s ON s.fkApartamento = ap.idApartamento 
JOIN medicao m ON m.fkSensorMedicao = s.idSensor 
JOIN alerta a ON m.fkAlertaMedicao = a.idAlerta
/* WHERE ap.numero_apartamento = 101 */  --  filtrar por apartamento
GROUP BY 
    c.nome_condominio, 
    c.dt_cadastro_condominio,
    pt.numero_portaria,
    p.bloco_predio,
    ap.andar_apartamento,
    ap.numero_apartamento,
    m.nivel_de_gas,
    a.acao,
    a.risco,
    s.local_instalado,
    s.status_sensor,
    m.idMedicao,
    c.idCondominio;

select Numero_Apartamento from dados; -- teste para mostrar que a view funciona
/*
ISSO AQUI É O QUE A GENTE PRECISAVA PARA CRIAR A VIEW E USAR NA DASH, DECIDI POR MANTER.
navbar
seletaoDeApartamentos
nomeCondominio - condominio  -- ok
data_de_cadastro - condominio   -- ok
numero_portaria - portaria  -- ok

Kpi
count idSensor - sensor -    quantidade total de sensores - count sensores -- quase não está retornando o total de sensor, so o total de cada id
select (count(statusAlerta) where statusSensor = ('Alerta','Crítico', 'Emergência')) - alerta - quantidade de sensores em alerta ( atenção, critico, emergência) - status | tabela alerta ( fkSensor ) -- ok
select (count(status_sensor) where statusSensor = 'inativo') - sensor - quantidade de sensores em manutenção - tabela sensor -- ok
data_hora - medicao - data/hora - medição - ultima atualização -- ok

bloco_predio - tabela prédio -- ok
andar_apartamento - numero apartamento - tabela apartamento -- ok
numero do apartamento - numero_apartamento - tabela apartamento  ( relacionar com a fktorre e fkandar )	-- ok
nivel_de_gas > 2.5 - medicao --- status do prédio - tabela medicao ( if algum prédio com a fk do prédio == nivelMedicao > default, ficar vermelho ) -- ok - mas tem que ver se esse > seria de fato la no JS
nivel_de_gas > 2.5 - medicao  -- status do apartamento - tabela medicao ( if nivelMedicao > default, ficar vermelho ) -- ok
 
notificações
saber a torre -- ok
saber o numero apto -- ok
saber o andar -- ok
------------||------
acao e risco - alerta - ação e risco -- ok
data_hora - medicao - quando foi gerado - tabela alerta   -- ok
local_instalado - sensor - local - tabela sensor*/ -- ok



SELECT * FROM condominio;

SELECT * FROM portaria;

SELECT * FROM predio;

SELECT * FROM apartamento;

SELECT * FROM sensor;

SELECT * FROM medicao;

SELECT * FROM alerta;

SELECT * FROM condominio WHERE nome_condominio LIKE '%A';

SELECT * FROM apartamento WHERE numero_apartamento = '202';