# Do zero ate a pagina Webdriver

Este guia assume que voce acabou de clonar o repositorio e ainda nao tem
MySQL Workbench. O objetivo e chegar em `http://127.0.0.1:5000/` com a
conexao ao banco funcionando.

## O que voce esta montando

1. MySQL 8 local com o schema `webdriver_db`.
2. Scripts SQL da pasta `database/`.
3. App Flask minimo na pasta `web/` (so home + teste de conexao).

Nao e preciso saber Flask a fundo para seguir estes passos.

## 1. Instalar o MySQL (sem Workbench, se quiser)

### Opcao A — Instalador oficial (Windows)

1. Baixe o MySQL Installer: https://dev.mysql.com/downloads/installer/
2. Instale pelo menos o **MySQL Server 8**.
3. Workbench e opcional. Se nao instalar, use o terminal (`mysql`).
4. Anote a senha do usuario `root` que voce definir na instalacao.
5. Confirme o servico MySQL rodando (servicos do Windows ou reinicie o PC).

### Opcao B — So a linha de comando

Depois de instalar o servidor, abra o PowerShell e teste:

```text
mysql -u root -p -e "SELECT VERSION();"
```

Se o comando `mysql` nao for encontrado, adicione a pasta `bin` do MySQL
ao PATH ou use o caminho completo, por exemplo:

```text
"C:\Program Files\MySQL\MySQL Server 8.0\bin\mysql.exe" -u root -p -e "SELECT VERSION();"
```

## 2. Criar o banco com os scripts do projeto

Na pasta do repositorio, rode o modelo fisico:

```text
mysql -u root -p < database\01_modelo_fisico_parte1.sql
```

(Opcional) Carregar dados de demonstracao:

```text
mysql -u root -p < database\02_crud_demonstracao_parte1.sql
```

Se preferir interface grafica, instale o Workbench depois e execute os
mesmos arquivos na ordem descrita em `database/README.md`.

Conferir:

```text
mysql -u root -p -e "USE webdriver_db; SHOW TABLES;"
```

Voce deve ver tabelas como `usuario`, `arquivo`, `compartilha`, etc.

## 3. Preparar a interface Flask

Na raiz do repositorio:

```text
copy .env.example .env
```

Edite `.env` e preencha `MYSQL_USER` e `MYSQL_PASSWORD` com o seu MySQL.

Crie o ambiente virtual e instale dependencias **dentro do venv**:

```text
python -m venv venv
.\venv\Scripts\activate
pip install -r requirements.txt
```

## 4. Subir a pagina

```text
cd web
python app.py
```

No navegador:

- http://127.0.0.1:5000/
- http://127.0.0.1:5000/saude

Se a home mostrar conexao ok, o esqueleto esta no ponto atual do projeto.

## 5. Racional curto (por que isso existe)

- O foco da disciplina e o **banco** (modelo, constraints, integridade).
- A interface Flask e propositalmente minima: HTML simples, sem dashboard.
- Credenciais ficam no `.env` (nao versionado). Codigo usa SQL parametrizado.
- Nesta etapa so validamos conexao. CRUDs (usuarios, arquivos, ...) vem depois,
  uma tela por vez, conforme `docs/README_interface_minima_webdriver.md`.

## Problemas comuns

| Sintoma | Causa provavel | O que fazer |
| --- | --- | --- |
| `Access denied` | Senha/usuario errados no `.env` | Conferir `.env` e testar `mysql -u root -p` |
| `Unknown database webdriver_db` | Script `01` nao rodou | Executar de novo o `01_modelo_fisico_parte1.sql` |
| Pagina nao abre | Flask nao esta rodando | `cd web` e `python app.py` com venv ativo |
| Pacote Flask nao encontrado | `pip` fora do venv | Ativar `venv` e reinstalar `requirements.txt` |

## Proximo passo do projeto

Depois de validar a conexao: listar e cadastrar usuarios na interface,
ainda sem autenticacao ficticia e sem alterar a logica do MySQL.
