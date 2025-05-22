var express = require("express");
var router = express.Router();

var portariaController = require("../controllers/portariaController");

router.post("/cadastrar", function (req, res) {
    portariaController.cadastrar(req, res);
});

router.get("/exibir", function (req, res) {
    portariaController.exibir(req, res);
});


module.exports = router;