# Interface minima Webdriver (Flask)

Esqueleto da Parte 1: pagina inicial e teste de conexao com `webdriver_db`.
Ainda nao ha CRUD de entidades.

## Pre-requisitos

1. MySQL 8 local com o banco criado.
2. Execute `database/01_modelo_fisico_parte1.sql` no Workbench.
3. (Opcional) Execute `database/02_crud_demonstracao_parte1.sql` para dados de demo.

## Configuracao

Na raiz do repositorio:

```text
copy .env.example .env
```

Edite `.env` com usuario e senha do seu MySQL.

Crie o ambiente virtual na raiz:

```text
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
```

## Como subir

Entre na pasta da interface e inicie o servidor:

```text
cd web
python app.py
```

Abra:

- http://127.0.0.1:5000/ — pagina inicial
- http://127.0.0.1:5000/saude — diagnostico (`SELECT 1`)

## Estrutura

- `app.py` — rotas Flask
- `db.py` — conexao MySQL via variaveis de ambiente
- `templates/` — HTML
- `static/style.css` — CSS minimo

## Limitacoes desta versao

- Sem autenticacao de usuario da aplicacao.
- Sem telas de usuarios, arquivos, compartilhamentos, etc.
- Nao altera o banco; so consulta `SELECT 1`.
