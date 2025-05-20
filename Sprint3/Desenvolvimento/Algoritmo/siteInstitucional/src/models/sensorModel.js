var database = require("../database/config")

function retornar_niveisEmLocais(numero_apartamento) {

    var instrucaoSql = `
        SELECT 
        s.local_instalado, 
        m.nivel_de_gas,
        m.data_hora
        FROM sensor AS s
        JOIN apartamento AS a ON s.fkApartamento = a.idApartamento
        LEFT JOIN (
            SELECT 
            fkSensorMedicao, 
            nivel_de_gas, 
            data_hora
            FROM medicao
            WHERE (fkSensorMedicao, data_hora) IN (
            SELECT fkSensorMedicao, MAX(data_hora)
            FROM medicao
            GROUP BY fkSensorMedicao)) 
            AS m ON m.fkSensorMedicao = s.idSensor
            WHERE a.numero_apartamento = '${numero_apartamento}'
            ORDER BY s.idSensor
            LIMIT 3;
            `;

    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}


module.exports = {
    retornar_niveisEmLocais,
};