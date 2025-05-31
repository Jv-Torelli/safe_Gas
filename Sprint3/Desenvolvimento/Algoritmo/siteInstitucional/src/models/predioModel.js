var database = require("../database/config")

function retornar_dados_tituloGrafico(numero_apartamento) {
    var instrucaoSql = `
    SELECT predio.bloco_predio
        FROM predio
        JOIN apartamento
        ON predio.idPredio = apartamento.fkPredioApto 
        WHERE apartamento.numero_apartamento = '${numero_apartamento}';`;

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
  }


module.exports = {
    retornar_dados_tituloGrafico,
};

