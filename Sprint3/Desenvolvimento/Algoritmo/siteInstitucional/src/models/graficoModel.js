var database = require("../database/config")

// function grafico_dados(numero_apartamento) {
//     var instrucaoSql = `
//     SELECT Última_Medição Bloco Andar Numero_Apartamento Nível_de_Gás
//         FROM dados where Número_Apartamento = ${numero_apartamento}`;
// 
//     console.log("Executando a instrução SQL: \n" + instrucaoSql);
//     return database.executar(instrucaoSql);
//   }
// 
// 
// module.exports = {
//     grafico_dados,
// };

//class GraficoModel {
//    static async buscarMedicoesGas(numero_apartamento) {
//        const instrucaoSql = `
//    select m.nivel_de_gas, m.data_hora, a.numero_apartamento, p.bloco_predio from medicao m join 
//    apartamento a on m.fkApartamentoMedicao = a.idApartamento join predio p on a.fkPredioApto = p.idPredio 
//    where a.numero_apartamento = ${numero_apartamento}
//            `;
//
//        console.log("Executando SQL do gráfico:", instrucaoSql);
//        return database.executar(instrucaoSql,  [numero_apartamento]);
//    }
//}
                  //class GraficoModel {
                  //    static async buscarMedicoesGas(numero_apartamento) {
                  //        try { // Seguir o padrão do data viz
                  //            const instrucaoSql = `
                  //                SELECT m.nivel_de_gas, m.data_hora, a.numero_apartamento, p.bloco_predio 
                  //                FROM medicao m 
                  //                JOIN apartamento a ON m.fkApartamentoMedicao = a.idApartamento 
                  //                JOIN predio p ON a.fkPredioApto = p.idPredio 
                  //                WHERE a.numero_apartamento = ${numero_apartamento}`;
                  //
                  //            console.log("Executando SQL do gráfico:", instrucaoSql);
                  //            return await database.executar(instrucaoSql, [numero_apartamento]);
                  //        } catch (erro) {
                  //            console.error("Erro ao executar a query:", erro);
                  //            throw erro; // Repassa o erro para ser tratado no nível superior
                  //        }
                  //    }
                  //}

/*function buscarMedicoesGas(numero_apartamento) {
        try { // Seguir o padrão do data viz
            const instrucaoSql = `
                SELECT m.nivel_de_gas, m.data_hora, a.numero_apartamento, p.bloco_predio 
                FROM medicao m 
                JOIN apartamento a ON m.fkApartamentoMedicao = a.idApartamento 
                JOIN predio p ON a.fkPredioApto = p.idPredio 
                WHERE a.numero_apartamento = ${numero_apartamento}`;

            console.log("Executando SQL do gráfico:", instrucaoSql);
            return database.executar(instrucaoSql, [numero_apartamento]);
        } catch (erro) {
            console.error("Erro ao executar a query:", erro);
            throw erro; // Repassa o erro para ser tratado no nível superior
        }
    }*/

        function buscarMedicoesGas(numero_apartamento) {
            const instrucaoSql = `
                SELECT m.nivel_de_gas, m.data_hora, a.numero_apartamento, p.bloco_predio 
                FROM medicao m 
                JOIN apartamento a ON m.fkApartamentoMedicao = a.idApartamento 
                JOIN predio p ON a.fkPredioApto = p.idPredio 
                WHERE a.numero_apartamento = ${numero_apartamento}`;
        
            console.log("Executando SQL do gráfico:", instrucaoSql);
            return database.executar(instrucaoSql, [numero_apartamento]); // Passa o parâmetro de forma segura
        }


module.exports = {buscarMedicoesGas};