-- tablea sprint1


create DATABASE SGC;
USE SGC;

create table usuario (
idUsuario INT primary key auto_increment,
senha varchar (15) not null,
cnpj char (14) unique not null
);

create table sensor(
idSensor int primary key auto_increment,
nome varchar(25) not null,
tipo varchar (30) not null,
StatusSensor varchar(15)
	constraint ckTaxa 
    check (StatusSensor in ('Ativo', 'Inativo')) 
);

Create Table medicao(
idMedicacao int primary key auto_increment,
dataHora datetime,
concetracaoGases int not null,
	Constraint ckTAxa
		CHECK (concentracaoGases in(15,30,50)),
statusAlerta varchar(30)
	Constraint ckstatus
    Check (statusAlerta in ('Normal', 'Atenção', 'Crítico'))
);

create table condominio (
idCondominio int primary key auto_increment,
nome varchar (30) not null,
logradouro varchar (50) not null,
numero int not null,
cep char (8) not null,
cnpj char (14) unique
);
insert into cadastro (nome, senha, email) values
('Ana Karoline ' ,'aninha2000 ' ,'ana.barrocal@sptech.com' ),
('Camila  Jodoi' ,'camilinha2000' ,'camila.jodai@sptech.com'),
('Caroline Soares' ,'carolzinha2000' ,'caroline.soares@sptech.com' ),
('Guilherme Mendes' ,'guilherminho200' ,'guilherme.mendes@sptech.com' ),
('João Lucas Reis ' ,'joaozinho2000' ,'joao.Lcarvallho@sptech.com' ),
('Leticia Rodrigues' ,'leticinha2000' ,'leticia.rodrigues@sptech.com' ),
('Rayssa Casagrande' ,'rayssinha2000' ,'rayssa.casagrande@sptech.com' );

insert into sensor (nome, tipo, taxaConcentracao) values
('MQ - 2','Sensor gás','15'),
('MQ - 2','Sensor gás','30'),
('MQ - 2','Sensor gás','50');

insert into condominio (nome, logradouro, cep, numero, cnpj ) values
('Osasco Residencial Life','O Trabuco Jornal ','0273456',247,'12345678000190'),
('Osasco Residencial Death','O Vale da Morte ','666666',666,'12345678000191'),
('Osasco REsidencial','O vale da vida ','77777777',777,'12345678000192');


select * from condominio;
select * from sensor;
select * from cadastro;
