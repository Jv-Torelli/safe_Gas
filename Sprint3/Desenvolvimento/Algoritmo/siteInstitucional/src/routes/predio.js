var express = require("express");
var router = express.Router();

var predioModel = require("../models/predioModel");

router.get("/retornar", function (req, res) {
    var numero_apartamento = req.query.numero_apartamento;
    predioModel.retornar_dados_tituloGrafico(numero_apartamento) 
        .then(resultado => { 
                res.json(resultado[0]);
        })
});


module.exports = router;