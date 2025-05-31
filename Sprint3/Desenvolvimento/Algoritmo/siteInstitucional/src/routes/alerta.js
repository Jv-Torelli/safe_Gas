var express = require("express");
var router = express.Router();

var alertaModel = require("../models/alertaModel");

router.get("/retornar", function (req, res) {
    var numero_apartamento = req.query.numero_apartamento;
    alertaModel.retornar_dados_kpi(numero_apartamento) 
        .then(resultado => { 
                res.json(resultado[0]);
        })
});


module.exports = router;