var portariaModel = require("../models/portariaModel");



function cadastrar(req, res) {
    var numPortaria = req.body.numPortariaServer;
    var telefone = req.body.telefoneServer;
    var email = req.body.emailServer;
    var dtCadastro = req.body.dtCadastroServer;
    var senha = req.body.senhaServer

   
    if (numPortaria == undefined) {
        res.status(400).send("Seu número da portaria está undefined!");
    } else if (telefone == undefined) {
        res.status(400).send("Seu telefone está undefined!");
    } else if (email == undefined) {
        res.status(400).send("Seu email está undefined!");
    } else if (dtCadastro == undefined) {
        res.status(400).send("Sua data de cadastro está undefined!");
    }else if (senha == undefined) {
        res.status(400).send("Sua data de cadastro está undefined!");
    }else {

       
        portariaModel.cadastrar(numPortaria, telefone, email, dtCadastro, senha)
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

function salvarEdicao(req, res) {
    var numPortaria = req.params.numPortaria;  
    var telefone = req.body.telefoneServer;
    var email = req.body.emailServer;

    console.log("Dados recebidos para edição:", { numPortaria, telefone, email });

    if (!numPortaria) return res.status(400).send("Número da portaria é obrigatório!");
    if (!telefone) return res.status(400).send("Telefone é obrigatório!");
    if (!email) return res.status(400).send("Email é obrigatório!");

    portariaModel.salvarEdicao(telefone, email, numPortaria)
        .then(() => res.json({ success: "Edição realizada com sucesso!" }))
        .catch(erro => {
            console.error("Erro na edição:", erro);
            res.status(500).json({
                error: "Erro interno do servidor",
                details: erro.sqlMessage || erro.message
            });
        });
}

function deletar(req, res) {
    var numPortaria = req.params.numPortariaServer;

    if (!numPortaria) {
        return res.status(400).send("Número da portaria é obrigatório para deletar!");
    }

    portariaModel.deletar(numPortaria)
        .then(() => res.json({ success: "Portaria deletada com sucesso!" }))
        .catch(erro => {
            console.error("Erro ao deletar:", erro);
            res.status(500).json({
                error: "Erro interno ao deletar portaria",
                details: erro.sqlMessage || erro.message
            });
        });
}

module.exports = {
    cadastrar,
    exibir,
    salvarEdicao,
    deletar
}