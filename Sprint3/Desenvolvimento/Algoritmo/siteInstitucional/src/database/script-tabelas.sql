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
     WHERE al.fkMedicao = m.idMedicao
     AND al.statusAlerta IN ('Alerta', 'Crítico', 'Emergência')
    ) AS Num_Sensor_Alertas_AP
    
FROM condominio c 
JOIN portaria pt ON c.idCondominio = pt.fkCondominioPortaria
JOIN predio p ON pt.idPortaria = p.fkPortariaPredio 
JOIN apartamento ap ON ap.fkPredioApto = p.idPredio 
JOIN sensor s ON s.fkApartamento = ap.idApartamento 
JOIN medicao m ON m.fkSensorMedicao = s.idSensor 
JOIN alerta a ON a.fkMedicao = m.idMedicao
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