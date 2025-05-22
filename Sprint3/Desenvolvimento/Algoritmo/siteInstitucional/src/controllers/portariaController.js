var portariaModel = require("../models/portariaModel");



function cadastrar(req, res) {
    // Crie uma variável que vá recuperar os valores do arquivo cadastro.html
    var numPortaria = req.body.numPortariaServer;
    var telefone = req.body.telefoneServer;
    var email = req.body.emailServer;
    var dtCadastro = req.body.dtCadastroServer;

    // Faça as validações dos valores
    if (numPortaria == undefined) {
        res.status(400).send("Seu número da portaria está undefined!");
    } else if (telefone == undefined) {
        res.status(400).send("Seu telefone está undefined!");
    } else if (email == undefined) {
        res.status(400).send("Seu email está undefined!");
    } else if (dtCadastro == undefined) {
        res.status(400).send("Sua data de cadastro está undefined!");
    }else {

        // Passe os valores como parâmetro e vá para o arquivo usuarioModel.js
        portariaModel.cadastrar(numPortaria, telefone, email, dtCadastro)
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
}

function exibir(req, res) {
      portariaModel.exibir()
        .then(function (resultado) {
            if (resultado.length > 0) {
                res.json(resultado);
            } else {
                res.status(204).send("Nenhum resultado encontrado!");
            }
        })
        .catch(function (erro) {
            console.log(erro);
            console.log("\nHouve um erro ao exibir os dados da portaria! Erro: ", erro.sqlMessage);
            res.status(500).json(erro.sqlMessage);
        });
}

module.exports = {
    cadastrar,
    exibir
}