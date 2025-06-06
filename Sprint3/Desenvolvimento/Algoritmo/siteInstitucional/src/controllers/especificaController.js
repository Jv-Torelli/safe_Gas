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

    async function obterDadosGrafico(req, res) {
        try {
            const idSensor = req.params.idSensor || req.query.idSensor || 1;
            const resultado = await especificaModel.obterDadosGrafico(idSensor);
            
            res.status(200).json({
                sucesso: true,
                dados: resultado,
                mensagem: 'Dados do gráfico recuperados com sucesso'
            });
        } catch (erro) {
            console.error('Erro ao buscar dados do gráfico:', erro);
            res.status(500).json({
                sucesso: false,
                mensagem: erro.message
            });
        }
    }


module.exports = {
    obterDadosKpi,
    obterDadosGrafico
}