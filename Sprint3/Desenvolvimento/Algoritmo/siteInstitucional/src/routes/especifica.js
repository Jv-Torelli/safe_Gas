var express = require("express");
var router = express.Router();
var especificaController = require("../controllers/especificaController");

router.get('/kpi/:idSensor?', especificaController.obterDadosKpi);

module.exports = router;