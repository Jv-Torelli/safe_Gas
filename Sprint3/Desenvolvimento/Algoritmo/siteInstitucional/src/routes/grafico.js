// graficoRoutes.js
//const express = require('express');
//const router = express.Router();
//const GraficoController = require('../controllers/graficoController');
//
//
//router.get("/medicoes-gas", function(req, res) {
//    GraficoController.buscarMedicoesGas(req, res);
//});
//
//module.exports = router;

/*const express = require("express");
const router = express.Router();
const GraficoModel = require("../models/graficoModel");

router.get("/medicoes-gas", async (req, res) => {
    const { numero_apartamento } = req.query;

    if (!numero_apartamento) {
        return res.status(400).json({ erro: "Número do apartamento não fornecido." });
    }

    try {
        const dados = await GraficoModel.buscarMedicoesGas(numero_apartamento);
        res.status(200).json(dados);
    } catch (erro) {
        console.error("Erro ao buscar medições de gás:", erro);
        res.status(500).json({ erro: "Erro interno no servidor." });
    }
});

module.exports = router;*/

const express = require("express");
const router = express.Router();
const GraficoModel = require("../models/graficoModel");

router.get("/medicoes-gas", async (req, res) => {
    const { numero_apartamento } = req.query;

    if (!numero_apartamento) {
        return res.status(400).json({ erro: "Número do apartamento não fornecido." });
    }

    try {
        const dados = await GraficoModel.buscarMedicoesGas(numero_apartamento);
        res.status(200).json(dados); // Retorna os dados no formato esperado
    } catch (erro) {
        console.error("Erro ao buscar medições de gás:", erro);
        res.status(500).json({ erro: "Erro interno no servidor." });
    }
});

module.exports = router;