const express = require("express");
const router = express.Router();
const GraficoModel = require("../models/graficoModel");

// Rota única, aceita sensor e limita a 12 registros
router.get("/medicoes-gas", async (req, res) => {
    const { numero_apartamento, sensor } = req.query;

    if (!numero_apartamento) {
        return res.status(400).json({ erro: "Número do apartamento não fornecido." });
    }

    try {
        // Passa sensor (idSensor) para o model, se informado
        const dados = await GraficoModel.buscarMedicoesGas(numero_apartamento, sensor);
        res.status(200).json(dados);
    } catch (erro) {
        console.error("Erro ao buscar medições de gás:", erro);
        res.status(500).json({ erro: "Erro interno no servidor." });
    }
});

module.exports = router;