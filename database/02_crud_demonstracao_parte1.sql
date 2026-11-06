-- Projeto de Banco de Dados - Webdriver
-- Parte 1 - Dados de demonstracao e operacoes CRUD
-- Execute 01_modelo_fisico_parte1.sql antes deste arquivo.

USE webdriver_db;

START TRANSACTION;

-- =========================================================
-- 1. INSERIR OBJETOS
-- =========================================================

INSERT INTO plano (nome, duracao, data_aquisicao, espaco_por_usuario)
VALUES ('Plano Academico', 12, '2026-11-06', 10737418240);
SET @plano_id = LAST_INSERT_ID();

INSERT INTO instituicao (plano_id, nome, causa_social, endereco)
VALUES (@plano_id, 'UNICAP', 'Universidade Catolica de Pernambuco',
        'Rua do Principe, Recife - PE');
SET @instituicao_id = LAST_INSERT_ID();

INSERT INTO usuario (instituicao_id, login, senha, data_ingresso, email)
VALUES
    (@instituicao_id, 'lucas', 'HASH_DEMONSTRACAO_NAO_USAR_EM_PRODUCAO',
     '2026-11-06', 'lucas@example.com'),
    (@instituicao_id, 'maria', 'HASH_DEMONSTRACAO_NAO_USAR_EM_PRODUCAO',
     '2026-11-06', 'maria@example.com'),
    (@instituicao_id, 'admin', 'HASH_DEMONSTRACAO_NAO_USAR_EM_PRODUCAO',
     '2026-11-06', 'admin@example.com');

SELECT id INTO @lucas_id FROM usuario WHERE login = 'lucas';
SELECT id INTO @maria_id FROM usuario WHERE login = 'maria';
SELECT id INTO @admin_usuario_id FROM usuario WHERE login = 'admin';

INSERT INTO administrador (usuario_id)
VALUES (@admin_usuario_id);
SET @administrador_id = LAST_INSERT_ID();

INSERT INTO arquivo (
    usuario_id, nome, tipo, permissoes_acesso, tamanho,
    localizacao, url
) VALUES (
    @lucas_id,
    'modelo-fisico.sql',
    'text/sql',
    'COMPARTILHADO',
    4096,
    '/uploads/modelo-fisico.sql',
    'http://localhost:5000/arquivos/modelo-fisico.sql'
);
SET @arquivo_id = LAST_INSERT_ID();

INSERT INTO historico (
    arquivo_id, usuario_id, operacao, data, hora, conteudo_alterado
) VALUES (
    @arquivo_id, @lucas_id, 'CARREGAR', CURRENT_DATE(), CURRENT_TIME(),
    'Primeira versao do arquivo carregada.'
);

INSERT INTO compartilha (
    arquivo_id, usuario_dono_id, usuario_compartilhado_id,
    data_compartilhamento
) VALUES (
    @arquivo_id, @lucas_id, @maria_id, CURRENT_DATE()
);

INSERT INTO comentario (
    usuario_id, arquivo_id, conteudo, data, hora
) VALUES (
    @maria_id, @arquivo_id,
    'O modelo fisico precisa manter as FKs e as restricoes de integridade.',
    CURRENT_DATE(), CURRENT_TIME()
);
SET @comentario_id = LAST_INSERT_ID();

INSERT INTO solicitar_suporte (
    usuario_solicitante_id, administrador_id, arquivo_id,
    dia, hora, descricao
) VALUES (
    @lucas_id, @administrador_id, @arquivo_id,
    CURRENT_DATE(), CURRENT_TIME(),
    'Solicitacao de ajuda para validar o compartilhamento do arquivo.'
);

-- =========================================================
-- 2. BUSCAR OBJETOS
-- =========================================================

-- Buscar usuario por login.
SELECT id, login, data_ingresso, email
FROM usuario
WHERE login = 'lucas';

-- Buscar arquivos do proprietario.
SELECT a.id, a.nome, a.tipo, a.tamanho, a.data_ultima_modificacao,
       a.localizacao, a.url
FROM arquivo AS a
WHERE a.usuario_id = @lucas_id;

-- Buscar arquivos aos quais um usuario tem acesso: como dono ou compartilhado.
SELECT DISTINCT
       a.id, a.nome, a.tipo, a.permissoes_acesso,
       a.tamanho, a.data_ultima_modificacao, a.url
FROM arquivo AS a
LEFT JOIN compartilha AS c
       ON c.arquivo_id = a.id
WHERE a.usuario_id = @maria_id
   OR c.usuario_compartilhado_id = @maria_id;

-- Buscar historico do arquivo com o usuario que realizou a operacao.
SELECT h.operacao, h.data, h.hora, h.conteudo_alterado,
       u.login AS usuario_responsavel
FROM historico AS h
INNER JOIN usuario AS u ON u.id = h.usuario_id
WHERE h.arquivo_id = @arquivo_id
ORDER BY h.data DESC, h.hora DESC;

-- =========================================================
-- 3. ATUALIZAR OBJETO
-- =========================================================

UPDATE arquivo
SET nome = 'modelo-fisico-v2.sql',
    tamanho = 6144,
    localizacao = '/uploads/modelo-fisico-v2.sql',
    url = 'http://localhost:5000/arquivos/modelo-fisico-v2.sql'
WHERE id = @arquivo_id
  AND usuario_id = @lucas_id;

INSERT INTO historico (
    arquivo_id, usuario_id, operacao, data, hora, conteudo_alterado
) VALUES (
    @arquivo_id, @lucas_id, 'ATUALIZAR', CURRENT_DATE(), CURRENT_TIME(),
    'Nome, tamanho, localizacao e URL foram atualizados.'
);

-- =========================================================
-- 4. REMOVER OBJETO
-- =========================================================

-- Remocao simples de um comentario.
DELETE FROM comentario
WHERE id = @comentario_id;

-- Remocao de um arquivo temporario sem dependencias.
INSERT INTO arquivo (
    usuario_id, nome, tipo, permissoes_acesso, tamanho,
    localizacao, url
) VALUES (
    @lucas_id, 'temporario.txt', 'text/plain', 'PRIVADO', 10,
    '/uploads/temporario.txt',
    'http://localhost:5000/arquivos/temporario.txt'
);
SET @arquivo_temporario_id = LAST_INSERT_ID();

DELETE FROM arquivo
WHERE id = @arquivo_temporario_id
  AND usuario_id = @lucas_id;

COMMIT;
