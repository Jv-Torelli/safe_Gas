var database = require("../database/config")

function cadastrar(numPortaria, telefone, email, dtCadastro) {
    console.log("ACESSEI O USUARIO MODEL \n \n\t\t >> Se aqui der erro de 'Error: connect ECONNREFUSED',\n \t\t >> verifique suas credenciais de acesso ao banco\n \t\t >> e se o servidor de seu BD está rodando corretamente. \n\n function cadastrar():", numPortaria, telefone, email, dtCadastro);
    
    var instrucaoSql = `
        INSERT INTO portaria (numero_portaria, telefone, email, dt_cadastro_port) VALUES ('${numPortaria}', '${telefone}', '${email}', '${dtCadastro}');
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

module.exports = {
    cadastrar
};