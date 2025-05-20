var sensorModel = require("../models/sensorModel");

function retornar_niveisEmLocais(req, res) {
    var numero_apartamento = req.query.numero_apartamento;
    sensorModel.retornar_niveisEmLocais(numero_apartamento)
        .then(resultado => res.json(resultado))
        .catch(erro => res.status(500).json(erro));
}


module.exports = {
    retornar_niveisEmLocais
}