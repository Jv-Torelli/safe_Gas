var usuarioModel = require("../models/usuarioModel");

function autenticar(req, res) {
    var identificador = req.body.identificadorServer;
    var senha = req.body.senhaServer;
    var tipoUsuario = req.body.tipoUsuarioServer;

    
    if (!identificador || !senha || !tipoUsuario) {
        res.status(400).send("Dados incompletos para autenticação");
        return;
    }

   
    if (tipoUsuario !== 'sindico' && tipoUsuario !== 'porteiro') {
        res.status(400).send("Tipo de usuário inválido");
        return;
    }

    console.log(`Tentativa de login - Tipo: ${tipoUsuario}, Identificador: ${identificador}`);

    usuarioModel.autenticar(identificador, senha, tipoUsuario)
        .then(function (resultadoAutenticar) {
            console.log(`\nResultados encontrados: ${resultadoAutenticar.length}`);
            console.log(`Resultados: ${JSON.stringify(resultadoAutenticar)}`);

            if (resultadoAutenticar.length == 1) {
                console.log(resultadoAutenticar);

                const usuario = resultadoAutenticar[0];
                
                if (tipoUsuario === 'sindico') {
                    res.json({
                        id: usuario.idCondominio,
                        nome: usuario.nome_condominio,
                        cnpj: usuario.cnpj,
                        tipo: 'sindico'
                    });
                } else { 
                    res.json({
                        id: usuario.idPortaria,
                        nome: `Portaria ${usuario.numero_portaria}`,
                        email: usuario.email,
                        fkCondominio: usuario.fkCondominioPortaria,
                        tipo: 'porteiro'
                    });
                }

            } else if (resultadoAutenticar.length == 0) {
                res.status(403).send("Credenciais inválidas");
            } else {
                res.status(403).send("Múltiplos usuários encontrados com as mesmas credenciais");
            }

        })
        .catch(function (erro) {
            console.log(erro);
            console.log("\nHouve um erro ao realizar o login! Erro: ", erro.sqlMessage);
            res.status(500).json(erro.sqlMessage);
        });
}

function cadastrar(req, res) {
    var nome = req.body.nomeServer;
    var cep = req.body.cepServer;
    var logradouro = req.body.logradouroServer;
    var numLog = req.body.numLogServer;
    var cnpj = req.body.cnpjServer;
    var senha = req.body.senhaServer;

    if (nome == undefined) {
        res.status(400).send("Seu nome está undefined!");
    } else if (cep == undefined) {
        res.status(400).send("Seu cep está undefined!");
    } else if (logradouro == undefined) {
        res.status(400).send("Seu logradouro está undefined!");
    } else if (numLog == undefined) {
        res.status(400).send("Seu numLog está undefined!");
    } else if (cnpj == undefined) {
        res.status(400).send("Seu cnpj está undefined!");
    } else if (senha == undefined) {
        res.status(400).send("Sua senha está undefined!");
    } else {

        
        usuarioModel.cadastrar(nome, cep, logradouro, numLog, cnpj, senha)
            .then(function (resultado) {
                res.json(resultado);
            })
            .catch(function (erro) {
                console.log(erro);
                console.log(
                    "\nHouve um erro ao realizar o cadastro! Erro: ",
                    erro.sqlMessage
                );
                res.status(500).json(erro.sqlMessage);
            });
    }
}

module.exports = {
    autenticar,
    cadastrar
}