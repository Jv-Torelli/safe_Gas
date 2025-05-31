var express = require("express");
var router = express.Router();

var dashboardController = require("../controllers/dashboardController");

router.get("/buscar", function (req, res) {
    dashboardController.buscarGeral(req, res);
});

router.get("/kpi", function (req, res) {
    dashboardController.buscarKpi(req, res);
});

router.get("/torre", function (req, res) {
    dashboardController.buscarTorre(req, res);
});


router.get("/apto", function (req, res) {
    dashboardController.buscarApto(req, res);
});

router.get("/andares", function (req, res) {
    dashboardController.buscarAndares(req, res);
});



module.exports = router;