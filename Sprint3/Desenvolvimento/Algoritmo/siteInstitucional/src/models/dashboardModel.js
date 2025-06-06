var database = require("../database/config")

function buscarDados() {
    console.log("ACESSEI O USUARIO MODEL \n \n\t\t >> Se aqui der erro de 'Error: connect ECONNREFUSED',\n \t\t >> verifique suas credenciais de acesso ao banco\n \t\t >> e se o servidor de seu BD está rodando corretamente. \n\n function entrar(): ")
    var instrucaoSql = `
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
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function apartamentoStatus() {
    console.log("ACESSEI O USUARIO MODEL \n \n\t\t >> Se aqui der erro de 'Error: connect ECONNREFUSED',\n \t\t >> verifique suas credenciais de acesso ao banco\n \t\t >> e se o servidor de seu BD está rodando corretamente. \n\n function entrar(): ")
    var instrucaoSql = `
  SELECT
    ap.numero_apartamento AS Numero_Apartamento,
    s.status_sensor AS Status_Sensor,
    MAX(m.nivel_de_gas) AS Nivel_Mais_Alto
FROM apartamento ap
JOIN sensor s ON s.fkApartamento = ap.idApartamento
JOIN medicao m ON m.fkSensorMedicao = s.idSensor
GROUP BY ap.numero_apartamento, s.status_sensor
ORDER BY MAX(m.nivel_de_gas) DESC;

    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarKpi() {
    console.log("ACESSEI O USUARIO MODEL \n \n\t\t >> Se aqui der erro de 'Error: connect ECONNREFUSED',\n \t\t >> verifique suas credenciais de acesso ao banco\n \t\t >> e se o servidor de seu BD está rodando corretamente. \n\n function entrar(): ")
    var instrucaoSql = `
        select * from kpi;
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarTorre() {
    console.log("ACESSEI O USUARIO MODEL \n \n\t\t >> Se aqui der erro de 'Error: connect ECONNREFUSED',\n \t\t >> verifique suas credenciais de acesso ao banco\n \t\t >> e se o servidor de seu BD está rodando corretamente. \n\n function entrar(): ")
    var instrucaoSql = `
        select * from predio;
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function buscarApto() {
    console.log("ACESSEI O USUARIO MODEL \n \n\t\t >> Se aqui der erro de 'Error: connect ECONNREFUSED',\n \t\t >> verifique suas credenciais de acesso ao banco\n \t\t >> e se o servidor de seu BD está rodando corretamente. \n\n function entrar(): ")
    var instrucaoSql = `
        select * from apartamento;
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}


function buscarAndares() {
    console.log("ACESSEI O USUARIO MODEL \n \n\t\t >> Se aqui der erro de 'Error: connect ECONNREFUSED',\n \t\t >> verifique suas credenciais de acesso ao banco\n \t\t >> e se o servidor de seu BD está rodando corretamente. \n\n function entrar(): ")
    var instrucaoSql = `
        select * from andares;
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function graficoModal(idAptoModal) {
    console.log('grafico modal models')

    var instrucaoSql = `
select * from medicao where fkSensorMedicao = ${idAptoModal} order by data_hora desc;
`;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function graficoMedicao(idAptoModal) {
    console.log('grafico modal models', idAptoModal)

    var instrucaoSql = `
SELECT * 
FROM apartamento AS a
JOIN medicao AS m ON a.idApartamento = m.fkApartamentoMedicao
WHERE m.fkApartamentoMedicao = ${idAptoModal}
ORDER BY m.data_hora DESC
LIMIT 10;
`;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}


module.exports = {
    buscarDados, buscarKpi, buscarTorre, buscarApto, buscarAndares, graficoModal, graficoMedicao, apartamentoStatus
};

