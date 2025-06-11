var database = require("../database/config")

function autenticar(identificador, senha, tipoUsuario) {
    console.log("ACESSEI O USUARIO MODEL \n \n\t\t >> Se aqui der erro de 'Error: connect ECONNREFUSED',\n \t\t >> verifique suas credenciais de acesso ao banco\n \t\t >> e se o servidor de seu BD está rodando corretamente. \n\n function autenticar(): ", identificador, senha, tipoUsuario);
    
    var instrucaoSql = "";
    
    if (tipoUsuario === 'sindico') {
        
        instrucaoSql = `
            SELECT idCondominio, nome_condominio, cnpj, senha 
            FROM condominio 
            WHERE cnpj = '${identificador}' AND senha = '${senha}';
        `;
    } else if (tipoUsuario === 'porteiro') {
        
        instrucaoSql = `
            SELECT idPortaria, numero_portaria, telefone, email, senha, fkCondominioPortaria
            FROM portaria 
            WHERE email = '${identificador}' AND senha = '${senha}';
        `;
    } else {
        throw new Error("Tipo de usuário inválido");
    }
    
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

function cadastrar(nome, cep, logradouro, numero_log, cnpj, senha) {
    console.log("ACESSEI O USUARIO MODEL \n \n\t\t >> Se aqui der erro de 'Error: connect ECONNREFUSED',\n \t\t >> verifique suas credenciais de acesso ao banco\n \t\t >> e se o servidor de seu BD está rodando corretamente. \n\n function cadastrar():", nome, cep, logradouro, numero_log, cnpj, senha);
    
    var instrucaoSql = `
        INSERT INTO condominio (nome_condominio, cep, logradouro, numero_logradouro, cnpj, senha) 
        VALUES ('${nome}', '${cep}', '${logradouro}', '${numero_log}', '${cnpj}', '${senha}');
    `;
    console.log("Executando a instrução SQL: \n" + instrucaoSql);
    return database.executar(instrucaoSql);
}

module.exports = {
    autenticar,
    cadastrar
};