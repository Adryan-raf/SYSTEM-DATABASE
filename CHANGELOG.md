# Changelog

Registro das mudancas relevantes do projeto Webdriver.
Formato simples, em ordem cronologica inversa.

## [Unreleased]

### Added

- Esqueleto da interface minima em Flask (`web/`).
- Pagina inicial com status textual da conexao MySQL.
- Rota `/saude` que executa `SELECT 1` para diagnostico.
- Conexao MySQL via variaveis de ambiente (`.env.example`).
- Dependencias Python em `requirements.txt` (Flask, mysql-connector-python, python-dotenv).
- `.gitignore` para `.env`, `venv/` e cache Python.
- Guia `SETUP_DO_ZERO.md` para subir banco e interface sem experiencia previa.
- Diretrizes da interface em `README_interface_minima_webdriver.md`.

### Notes

- Esta versao nao implementa CRUD de usuarios, arquivos ou demais entidades.
- O banco continua sendo a fonte de verdade; a interface so demonstra conexao.
- Stack Node (`package.json` / `mysql2`) nao e usada pela interface.
