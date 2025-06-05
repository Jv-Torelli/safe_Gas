var database = require("../database/config")

function retornar_dados_kpi(numero_apartamento) {
    var instrucaoSql = `
   select * from notificacoes where Numero_Apartamento = ${numero_apartamento};`;

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

module.exports = {
    retornar_dados_kpi,
};