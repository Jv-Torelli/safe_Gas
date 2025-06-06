var database = require("../database/config")
var database = require("../database/config");

// ...existing code...
// ...existing code...
async function buscarMedicoesGas(numero_apartamento, idSensor) {
    let instrucaoSql = 
        'SELECT m.nivel_de_gas, m.data_hora, s.local_instalado, s.idSensor ' +
        'FROM medicao m ' +
        'JOIN sensor s ON m.fkSensorMedicao = s.idSensor ' +
        'JOIN apartamento a ON s.fkApartamento = a.idApartamento ' +
        'WHERE a.numero_apartamento = ?';
    let params = [numero_apartamento];

    // Só adiciona o filtro do sensor se idSensor for realmente informado e não vazio
    if (idSensor !== undefined && idSensor !== null && idSensor !== '') {
        instrucaoSql += ' AND s.idSensor = ?';
        params.push(idSensor);
    }

    instrucaoSql += ' ORDER BY m.data_hora ASC;';

    return database.executar(instrucaoSql, params);
}

function buscarUltimasMedicoesPorSensor(numero_apartamento) {
    const instrucaoSql = `
                SELECT m.nivel_de_gas, m.data_hora, a.numero_apartamento, p.bloco_predio 
                FROM medicao m 
                JOIN apartamento a ON m.fkApartamentoMedicao = a.idApartamento 
                JOIN predio p ON a.fkPredioApto = p.idPredio 
                WHERE a.numero_apartamento = ${numero_apartamento}; 
    `;
    
    return database.executar(instrucaoSql, [numero_apartamento]);
}

function buscarDadosAlerta(numero_apartamento) {
    const instrucaoSql = `
        SELECT 
            MAX(m.nivel_de_gas) as maior_nivel,
            s.local_instalado as local_maior_nivel,
            MAX(m.data_hora) as data_hora_maior_nivel
        FROM medicao m
        JOIN sensor s ON m.fkSensor = s.idSensor
        JOIN apartamento a ON s.fkApartamento = a.idApartamento
        WHERE a.numero_apartamento = ?
        GROUP BY s.local_instalado
        ORDER BY maior_nivel DESC
        LIMIT 1;
    `;
    
    return database.executar(instrucaoSql, [numero_apartamento]);
}

module.exports = {
    buscarMedicoesGas,
    buscarUltimasMedicoesPorSensor,
    buscarDadosAlerta
};

       


