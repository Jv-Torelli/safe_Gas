var express = require("express");
var router = express.Router();
var especificaController = require("../controllers/especificaController");

router.get('/kpi/:idSensor?', especificaController.obterDadosKpi);

router.get('/grafico/:idSensor?', especificaController.obterDadosGrafico);

module.exports = router;