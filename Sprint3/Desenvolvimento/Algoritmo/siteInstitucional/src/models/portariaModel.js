var database = require("../database/config")

function cadastrar(numPortaria, telefone, email, dtCadastro, senha) {
    console.log("ACESSEI O USUARIO MODEL \n \n\t\t >> Se aqui der erro de 'Error: connect ECONNREFUSED',\n \t\t >> verifique suas credenciais de acesso ao banco\n \t\t >> e se o servidor de seu BD está rodando corretamente. \n\n function cadastrar():", numPortaria, telefone, email, dtCadastro, senha);
    
    var instrucaoSql = `
        INSERT INTO portaria (numero_portaria, telefone, email, dt_cadastro_port, fkCondominioPortaria, senha) VALUES ('${numPortaria}', '${telefone}', '${email}', '${dtCadastro}', '1', '${senha}');
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function exibir() {
    var instrucaoSql = `
        SELECT idPortaria, numero_portaria, telefone, email, dt_cadastro_port
        FROM portaria;
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function salvarEdicao(telefone, email, numPortaria) {
    console.log("ACESSEI A EDIÇÃO MODEL: ", telefone, email, numPortaria);
    
    var instrucaoSql = `
        UPDATE portaria 
        SET telefone = '${telefone}', 
            email = '${email}' 
        WHERE numero_portaria = '${numPortaria}';
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function deletar(numPortaria) {
    console.log("ACESSEI O MODEL DE DELETAR: ", numPortaria);

    var instrucaoSql = `
        DELETE FROM portaria WHERE numero_portaria = '${numPortaria}';
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

module.exports = {
    cadastrar,
    exibir,
    salvarEdicao,
    deletar
};
