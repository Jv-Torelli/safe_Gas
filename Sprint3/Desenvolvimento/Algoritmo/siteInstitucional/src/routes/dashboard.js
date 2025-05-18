var express = require("express");
var router = express.Router();

var dashboardController = require("../controllers/dashboardController");

router.get("/buscar", function (req, res) {
    dashboardController.buscarGeral(req, res);
});

module.exports = router;