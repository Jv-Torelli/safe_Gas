var dashboardModel = require("../models/dashboardModel");

function buscarGeral(req, res) {
    // Passe os valores como parâmetro e vá para o arquivo usuarioModel.js
    dashboardModel.buscarDados()
        .then(
            function (resultado) {
                res.json(resultado);
            }
        ).catch(
            function (erro) {
                console.log(erro);
                console.log(
                    "\nHouve um erro ao realizar o cadastro! Erro: ",
                    erro.sqlMessage
                );
                res.status(500).json(erro.sqlMessage);
            }
        );
}



function buscarKpi(req, res) {
    // Passe os valores como parâmetro e vá para o arquivo usuarioModel.js
    dashboardModel.buscarKpi()
        .then(
            function (resultado) {
                res.json(resultado);
            }
        ).catch(
            function (erro) {
                console.log(erro);
                console.log(
                    "\nHouve um erro ao realizar o cadastro! Erro: ",
                    erro.sqlMessage
                );
                res.status(500).json(erro.sqlMessage);
            }
        );
}

function buscarTorre(req, res) {
    dashboardModel.buscarTorre()
        .then(
            function (retorno) {
                res.json(retorno);
            }
        ).catch(
            function (erro) {
                console.log(erro);
                console.log(
                    "\nHouve um erro ao realizar o cadastro! Erro: ",
                    erro.sqlMessage
                );
                res.status(500).json(erro.sqlMessage);
            }
        );
}

function buscarAndares(req, res) {
    dashboardModel.buscarAndares()
        .then(
            function (retornoAndar) {
                res.json(retornoAndar);
            }
        ).catch(
            function (erro) {
                console.log(erro);
                console.log(
                    "\nHouve um erro ao realizar o cadastro! Erro: ",
                    erro.sqlMessage
                );
                res.status(500).json(erro.sqlMessage);
            }
        );
}

function buscarApto(req, res) {
    dashboardModel.buscarApto()
        .then(
            function (retornoApto) {
                res.json(retornoApto);
            }
        ).catch(
            function (erro) {
                console.log(erro);
                console.log(
                    "\nHouve um erro ao realizar o cadastro! Erro: ",
                    erro.sqlMessage
                );
                res.status(500).json(erro.sqlMessage);
            }
        );
}


function buscarMedicaoModal(req, res) {

    var idAptoModal = req.params.idModalGrafico;

    dashboardModel.graficoModal(idAptoModal)
        .then(
            function (retornoApto) {
                res.json(retornoApto);
            }
        ).catch(
            function (erro) {
                console.log(erro);
                console.log(
                    "\nHouve um erro ao realizar o cadastro! Erro: ",
                    erro.sqlMessage
                );
                res.status(500).json(erro.sqlMessage);
            }
        );
}
module.exports = {
    buscarGeral, buscarKpi, buscarTorre, buscarApto, buscarAndares, buscarMedicaoModal
}