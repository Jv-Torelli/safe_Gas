var especificaModel = require("../models/especificaModel");


async function obterDadosKpi(req, res) {
        try {
            const idSensor = 1;
            const resultado = await especificaModel.obterDadosKpi(idSensor);
            
            res.status(200).json({
                sucesso: true,
                dados: resultado,
                mensagem: 'Dados recuperados com sucesso'
            });
        } catch (erro) {
            console.error('Erro ao buscar dados KPI:', erro);
            res.status(500).json({
                sucesso: false,
                mensagem: erro.message
            });
        }
    }


module.exports = {
    obterDadosKpi,
}