# Webdriver - primeira versao da Parte 1

## Ordem de execucao

1. Abra o MySQL Workbench e conecte-se ao MySQL 8.
2. Execute `01_modelo_fisico_parte1.sql`.
3. Execute `02_crud_demonstracao_parte1.sql`.
4. Verifique as tabelas e os resultados dos `SELECT`.

## O que esta primeira versao cobre

- Criacao da base e das tabelas.
- Chaves primarias e estrangeiras.
- Restricoes `NOT NULL`, `UNIQUE`, `CHECK` e integridade referencial.
- Insercao, busca, atualizacao e remocao.
- Estrutura preparada para a Parte 2: compartilhamento por usuario,
  historico com responsavel, instituicao, administrador e tipo de arquivo.

## Ajustes necessarios nos diagramas entregues

- `comentario`: adicionar `conteudo`, `data` e `hora`.
- `historico`: adicionar `usuario_id`.
- `solicitar_suporte`: adicionar `id`, `arquivo_id` opcional, `dia`, `hora`
  e `descricao`; referenciar o administrador.
- `compartilha`: distinguir o dono do usuario que recebeu o acesso.

## Proximo passo

Somente depois de validar os scripts no Workbench, criar uma API pequena em
Flask usando consultas SQL parametrizadas. O banco deve continuar sendo a
fonte de verdade; nao gerar o esquema a partir de ORM.
