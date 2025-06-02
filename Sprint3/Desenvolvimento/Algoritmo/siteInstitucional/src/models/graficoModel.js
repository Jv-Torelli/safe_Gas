var database = require("../database/config")
var database = require("../database/config");

function buscarMedicoesGas(numero_apartamento) {
    const instrucaoSql = `
        SELECT m.nivel_de_gas, m.data_hora, s.local_instalado, s.idSensor
        FROM medicao m
        JOIN sensor s ON m.fkSensor = s.idSensor
        JOIN apartamento a ON s.fkApartamento = a.idApartamento
        WHERE a.numero_apartamento = ? 
        ORDER BY m.data_hora DESC
        LIMIT 75;  -- 25 medições por sensor (3 sensores)
    `;
    
    console.log("Executando SQL do gráfico:", instrucaoSql);
    return database.executar(instrucaoSql, [numero_apartamento]);
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

       


