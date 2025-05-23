var grafico_linha = require("../models/graficoModel")

class GraficoController {
    static async buscarMedicoesGas(req, res) {
        const { numero_apartamento } = req.query;

        try {
            const grafico_dado = await GraficoModel.buscarMedicoesGas(numero_apartamento);
            console.log(grafico_dado);
            res.status(200).json(grafico_dado);
        } catch (erro) {
            res.status(500).json({ 
                erro: "Erro ao buscar medições de gás",
                detalhes: erro.message 
            });
        }
    }
}

module.exports = GraficoController;

