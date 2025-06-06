var database = require("../database/config")

function obterDadosKpi(idSensor) {
        var instrucaoSql = `
            SELECT 
                a.acao AS "Acao do usuario",
                a.statusAlerta AS "Status do Alerta", 
                s.local_instalado AS "Local de instalação",
                m.data_hora AS "Data e hora da medição"
            FROM 
                medicao m
            JOIN 
                alerta a ON m.fkAlertaMedicao = a.idAlerta
            JOIN 
                sensor s ON m.fkSensorMedicao = s.idSensor
            WHERE s.idSensor = ${idSensor}
        `;
        
        return database.executar(instrucaoSql);
    }
    
    function obterDadosGrafico(idSensor){
        var instrucaoSql = `
            SELECT 
                m.data_hora AS "Data e hora",
                m.nivel_de_gas AS "Nível de Gás"
            FROM 
                medicao m
            WHERE 
                m.fkSensorMedicao = ${idSensor}
            ORDER BY 
                m.data_hora ASC
        `;
        
        return database.executar(instrucaoSql);
    }

module.exports = {
    obterDadosKpi,
    obterDadosGrafico
};
