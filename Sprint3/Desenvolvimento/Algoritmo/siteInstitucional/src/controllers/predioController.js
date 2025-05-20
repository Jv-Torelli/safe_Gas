var predioModel = require("../models/predioModel");

function retornar_dados_tituloGrafico(req, res) {
    var numero_apartamento = req.query.numero_apartamento;
    predioModel.retornar_dados_tituloGrafico(numero_apartamento).then(
        function (resultado) {
            if (resultado.length > 0) {
                res.json({
                    bloco_predio: resultado[0].bloco_predio,
                });
            } else {
                res.status(404).send("Nenhum prédio encontrado");
            }
        }
    ).catch(
        function (erro) {
            res.status(500).json(erro.sqlMessage);
        }
    );
}


module.exports = {
    retornar_dados_tituloGrafico
}