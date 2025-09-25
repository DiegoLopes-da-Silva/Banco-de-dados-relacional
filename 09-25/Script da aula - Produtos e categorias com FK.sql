SHOW DATABASES;

-- Cria um banco de dados
-- Com If deixa de ser erro e vira warning

CREATE DATABASE IF NOT EXISTS diego;

-- Deleta um banco de dados
-- Todo Create & Drop aceitam a estrutura do IF

DROP DATABASE IF EXISTS ronan;

-- Cria um banco de dados completo!

CREATE DATABASE IF NOT EXISTS aula_180925 CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode;

-- Mostra o script de criação do banco completo, com o charset

SHOW CREATE DATABASE aula_180925;

-- Marca um banco de dados para ser utilizado até que a conexão finalize

USE aula_180925;

-- Cria uma tabela que impede erro
CREATE TABLE usuarios(
	id_usuario BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	nome VARCHAR(255) NOT NULL,
    cpf VARCHAR(14) UNIQUE,
    email VARCHAR(255) UNIQUE,
    date_nascimento DATE,
    admin BOOLEAN DEFAULT FALSE,
    salario DECIMAL (10,2),
    cargo ENUM('Vendedor', 'Supervisor', 'Gerente'),
    senha VARCHAR(255) NOT NULL,
    -- CAMPOS PARA LOG / AUDITORIA
    criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    alterado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deletado_em DATETIME NULL
);

-- Busca todos os dados presentes em uma tabela
SELECT * FROM usuarios;

-- Descreve a tabela mostrando seus dados de criação
DESCRIBE usuarios;

-- Adicionando a coluna gênero
ALTER TABLE usuarios
-- ENUM é por padrão NOT NULL e não aceita vazio
-- 							0			 1			 2			3
	ADD COLUMN genero ENUM('Masculino', 'Feminino', 'Outros', 'Prefiro não declarar') 
    AFTER date_nascimento;

ALTER TABLE usuarios
	DROP COLUMN genero;
    
-- SET - Não utilizamos porque ela é outra tabela N:M
-- SET permite NULL e a seleção de várias opções
    
-- Troca o tipo de uma tabela
ALTER TABLE usuarios
	MODIFY COLUMN genero CHAR(1);
    
-- Troca o nome de uma coluna
ALTER TABLE usuarios
	CHANGE COLUMN nome nome_completo VARCHAR(255) NOT NULL;
    
CREATE TABLE IF NOT EXISTS produtos (
	id_produto BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    nome VARCHAR(255) NOT NULL,
    quantidade DECIMAL(6,3),
    valor DECIMAL(10,2),
    validade DATE NULL,
	-- LOGS
	criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    alterado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deletado_em DATETIME NULL
);

CREATE TABLE IF NOT EXISTS categorias (
	id_categoria BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    nome VARCHAR(255) NOT NULL,
	-- LOGS
	criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    alterado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deletado_em DATETIME NULL
);

CREATE TABLE IF NOT EXISTS produtos_categorias (
	-- FK não precisa ter PK, mas não ter pode causar algumas inviabilidades
    produto_id BIGINT UNSIGNED NOT NULL,
    categoria_id BIGINT UNSIGNED NOT NULL,
    -- Caso por algum motivo ocorra a deleção de um produto, sem a PK não teria como adicionar o mesmo produto de novo.
    -- LOGS
	criado_em DATETIME DEFAULT CURRENT_TIMESTAMP,
    alterado_em DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deletado_em DATETIME NULL,
    PRIMARY KEY (produto_id, categoria_id),
	FOREIGN KEY (produto_id) REFERENCES produtos(id_produto)
);

-- Adicionar um relacionamento depois da tabela criada
-- Informar o nome do BD no script é uma boa prática, mas pouco usada para comandos simples
ALTER TABLE aula_180925.produtos_categorias
	-- Ao fazer com ALTER TABLE é obrigatorio informar o nome do relacionamento
    ADD CONSTRAINT fk_produtos_categorias_categorias
    FOREIGN KEY (categoria_id) REFERENCES categorias(id_categoria);
    
DESCRIBE produtos;

DESCRIBE categorias;

DESCRIBE produtos_categorias;