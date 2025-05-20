var express = require("express");
var router = express.Router();
var sensorController = require("../controllers/sensorController");

router.get("/por-apartamento", function(req, res) {
    sensorController.retornar_niveisEmLocais(req, res);
});

module.exports = router;