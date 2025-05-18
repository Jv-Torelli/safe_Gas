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


module.exports = {
    buscarGeral
}