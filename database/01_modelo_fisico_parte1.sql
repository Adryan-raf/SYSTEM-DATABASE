-- Projeto de Banco de Dados - Webdriver
-- Parte 1 - Primeira versao do modelo fisico
-- SGBD alvo: MySQL 8.x
-- Abordagem: database-first

CREATE DATABASE IF NOT EXISTS webdriver_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE webdriver_db;

-- Para recriar o esquema durante o desenvolvimento, descomente os DROPs
-- abaixo e execute-os na ordem apresentada.
-- DROP TABLE IF EXISTS historico;
-- DROP TABLE IF EXISTS solicitar_suporte;
-- DROP TABLE IF EXISTS comentario;
-- DROP TABLE IF EXISTS compartilha;
-- DROP TABLE IF EXISTS arquivo;
-- DROP TABLE IF EXISTS administrador;
-- DROP TABLE IF EXISTS usuario;
-- DROP TABLE IF EXISTS instituicao;
-- DROP TABLE IF EXISTS plano;

CREATE TABLE IF NOT EXISTS plano (
    id INT UNSIGNED AUTO_INCREMENT,
    nome VARCHAR(100) NOT NULL,
    duracao SMALLINT UNSIGNED NOT NULL COMMENT 'Unidade deve ser definida pela equipe, por exemplo, meses',
    data_aquisicao DATE NOT NULL,
    espaco_por_usuario BIGINT UNSIGNED NOT NULL COMMENT 'Espaco em bytes por usuario',

    CONSTRAINT pk_plano PRIMARY KEY (id),
    CONSTRAINT ck_plano_duracao CHECK (duracao > 0),
    CONSTRAINT ck_plano_espaco CHECK (espaco_por_usuario > 0)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS instituicao (
    id INT UNSIGNED AUTO_INCREMENT,
    plano_id INT UNSIGNED NOT NULL,
    nome VARCHAR(150) NOT NULL,
    causa_social VARCHAR(200) NOT NULL,
    endereco VARCHAR(255) NOT NULL,

    CONSTRAINT pk_instituicao PRIMARY KEY (id),
    CONSTRAINT fk_instituicao_plano
        FOREIGN KEY (plano_id) REFERENCES plano (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    INDEX idx_instituicao_plano (plano_id)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS usuario (
    id INT UNSIGNED AUTO_INCREMENT,
    instituicao_id INT UNSIGNED NOT NULL,
    login VARCHAR(60) NOT NULL,
    senha VARCHAR(255) NOT NULL COMMENT 'Armazenar somente hash de senha',
    data_ingresso DATE NOT NULL,
    email VARCHAR(254) NOT NULL,

    CONSTRAINT pk_usuario PRIMARY KEY (id),
    CONSTRAINT uq_usuario_login UNIQUE (login),
    CONSTRAINT uq_usuario_email UNIQUE (email),
    CONSTRAINT fk_usuario_instituicao
        FOREIGN KEY (instituicao_id) REFERENCES instituicao (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    INDEX idx_usuario_instituicao (instituicao_id)
) ENGINE = InnoDB;

-- Especializacao de USUARIO: o administrador herda os dados do usuario.
CREATE TABLE IF NOT EXISTS administrador (
    id_administrador INT UNSIGNED AUTO_INCREMENT,
    usuario_id INT UNSIGNED NOT NULL,

    CONSTRAINT pk_administrador PRIMARY KEY (id_administrador),
    CONSTRAINT uq_administrador_usuario UNIQUE (usuario_id),
    CONSTRAINT fk_administrador_usuario
        FOREIGN KEY (usuario_id) REFERENCES usuario (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS arquivo (
    id INT UNSIGNED AUTO_INCREMENT,
    usuario_id INT UNSIGNED NOT NULL COMMENT 'Proprietario do arquivo',
    nome VARCHAR(255) NOT NULL,
    tipo VARCHAR(100) NOT NULL COMMENT 'Extensao ou MIME type, usado futuramente pelo trigger Safe_security',
    permissoes_acesso VARCHAR(30) NOT NULL,
    tamanho BIGINT UNSIGNED NOT NULL COMMENT 'Tamanho em bytes',
    data_ultima_modificacao DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
        ON UPDATE CURRENT_TIMESTAMP,
    localizacao VARCHAR(500) NOT NULL,
    url VARCHAR(2048) NOT NULL,

    CONSTRAINT pk_arquivo PRIMARY KEY (id),
    CONSTRAINT uq_arquivo_id_proprietario UNIQUE (id, usuario_id),
    CONSTRAINT ck_arquivo_tamanho CHECK (tamanho >= 0),
    CONSTRAINT fk_arquivo_usuario
        FOREIGN KEY (usuario_id) REFERENCES usuario (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    INDEX idx_arquivo_usuario (usuario_id),
    INDEX idx_arquivo_nome (nome),
    INDEX idx_arquivo_data_modificacao (data_ultima_modificacao)
) ENGINE = InnoDB;

-- O minimundo exige: id do arquivo, id do dono, id do compartilhado
-- e data de compartilhamento. A FK composta garante que o dono informado
-- seja realmente o proprietario do arquivo.
CREATE TABLE IF NOT EXISTS compartilha (
    arquivo_id INT UNSIGNED NOT NULL,
    usuario_dono_id INT UNSIGNED NOT NULL,
    usuario_compartilhado_id INT UNSIGNED NOT NULL,
    data_compartilhamento DATE NOT NULL,

    CONSTRAINT pk_compartilha
        PRIMARY KEY (arquivo_id, usuario_compartilhado_id),
    CONSTRAINT ck_compartilha_usuarios_diferentes
        CHECK (usuario_dono_id <> usuario_compartilhado_id),
    CONSTRAINT fk_compartilha_arquivo_dono
        FOREIGN KEY (arquivo_id, usuario_dono_id)
        REFERENCES arquivo (id, usuario_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_compartilha_usuario_compartilhado
        FOREIGN KEY (usuario_compartilhado_id) REFERENCES usuario (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    INDEX idx_compartilha_dono (usuario_dono_id),
    INDEX idx_compartilha_usuario (usuario_compartilhado_id)
) ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS comentario (
    id INT UNSIGNED AUTO_INCREMENT,
    usuario_id INT UNSIGNED NOT NULL,
    arquivo_id INT UNSIGNED NOT NULL,
    conteudo TEXT NOT NULL,
    data DATE NOT NULL,
    hora TIME NOT NULL,

    CONSTRAINT pk_comentario PRIMARY KEY (id),
    CONSTRAINT fk_comentario_usuario
        FOREIGN KEY (usuario_id) REFERENCES usuario (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_comentario_arquivo
        FOREIGN KEY (arquivo_id) REFERENCES arquivo (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    INDEX idx_comentario_usuario (usuario_id),
    INDEX idx_comentario_arquivo (arquivo_id)
) ENGINE = InnoDB;

-- Entidade associativa entre usuario e administrador.
-- arquivo_id e opcional porque o suporte pode ou nao tratar de um arquivo.
CREATE TABLE IF NOT EXISTS solicitar_suporte (
    id INT UNSIGNED AUTO_INCREMENT,
    usuario_solicitante_id INT UNSIGNED NOT NULL,
    administrador_id INT UNSIGNED NOT NULL,
    arquivo_id INT UNSIGNED NULL,
    dia DATE NOT NULL,
    hora TIME NOT NULL,
    descricao TEXT NOT NULL,

    CONSTRAINT pk_solicitar_suporte PRIMARY KEY (id),
    CONSTRAINT fk_suporte_usuario
        FOREIGN KEY (usuario_solicitante_id) REFERENCES usuario (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_suporte_administrador
        FOREIGN KEY (administrador_id) REFERENCES administrador (id_administrador)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_suporte_arquivo
        FOREIGN KEY (arquivo_id) REFERENCES arquivo (id)
        ON UPDATE CASCADE
        ON DELETE SET NULL,
    INDEX idx_suporte_usuario (usuario_solicitante_id),
    INDEX idx_suporte_administrador (administrador_id),
    INDEX idx_suporte_arquivo (arquivo_id)
) ENGINE = InnoDB;

-- O historico tambem funciona como registro das operacoes realizadas.
CREATE TABLE IF NOT EXISTS historico (
    id INT UNSIGNED AUTO_INCREMENT,
    arquivo_id INT UNSIGNED NOT NULL,
    usuario_id INT UNSIGNED NOT NULL COMMENT 'Usuario que realizou a alteracao',
    operacao ENUM('CARREGAR', 'ATUALIZAR', 'REMOVER') NOT NULL,
    data DATE NOT NULL,
    hora TIME NOT NULL,
    conteudo_alterado TEXT NOT NULL,

    CONSTRAINT pk_historico PRIMARY KEY (id),
    CONSTRAINT fk_historico_arquivo
        FOREIGN KEY (arquivo_id) REFERENCES arquivo (id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT fk_historico_usuario
        FOREIGN KEY (usuario_id) REFERENCES usuario (id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    INDEX idx_historico_arquivo (arquivo_id),
    INDEX idx_historico_usuario (usuario_id),
    INDEX idx_historico_data_hora (data, hora)
) ENGINE = InnoDB;
