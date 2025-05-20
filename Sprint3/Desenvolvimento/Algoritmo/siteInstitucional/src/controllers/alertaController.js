var alertaModel = require("../models/alertaModel");

function retornar_dados_kpi(req, res) {
    var numero_apartamento = req.query.numero_apartamento;
    alertaModel.retornar_dados_kpi(numero_apartamento).then(
        function (resultado) {
            if (resultado.length > 0) {
                res.json({
                    statusAlerta: resultado[0].statusAlerta,
                    acao: resultado[0].acao,
                    risco: resultado[0].risco
                });
            } else {
                res.status(404).send("Nenhum alerta encontrado");
            }
        }
    ).catch(
        function (erro) {
            res.status(500).json(erro.sqlMessage);
        }
    );
}


module.exports = {
    retornar_dados_kpi
}