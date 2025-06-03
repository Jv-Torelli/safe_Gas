var database = require("../database/config")

function retornar_dados_kpi(numero_apartamento) {
    var instrucaoSql = `
    SELECT statusAlerta, acao, risco 
        FROM alerta
        JOIN apartamento
        ON alerta.fkApartamentoMedicao = apartamento.idApartamento
        WHERE apartamento.numero_apartamento = '${numero_apartamento}';`;

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

module.exports = {
    retornar_dados_kpi,
};