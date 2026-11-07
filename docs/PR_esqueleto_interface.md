# Pull request — feature/esqueleto-interface → developer

Use este texto no GitHub se o `gh` ainda nao estiver autenticado.

**Compare:** https://github.com/Adryan-raf/SYSTEM-DATABASE/compare/developer...feature/esqueleto-interface?expand=1

**Title:** feat: esqueleto Flask minimo com conexao MySQL

---

## Summary

- Adiciona o esqueleto da interface academica em Flask (`web/`), com pagina inicial e rota `/saude` que valida a conexao ao `webdriver_db` via `SELECT 1`.
- Configura credenciais por `.env` (exemplo versionado), `requirements.txt` e `.gitignore`, sem alterar os scripts SQL da Parte 1.
- Inclui `docs/CHANGELOG.md`, `docs/SETUP_DO_ZERO.md` (instalacao do MySQL e app do zero, inclusive sem Workbench) e as diretrizes em `docs/README_interface_minima_webdriver.md`.

## Escopo e limites

- Sem CRUD de usuarios/arquivos nesta PR.
- Sem autenticacao ficticia e sem ORM.
- Stack Node legado (`package.json`) permanece fora do caminho da interface.

## Test plan

- [ ] Instalar/ativar MySQL 8 e aplicar `database/01_modelo_fisico_parte1.sql` (Workbench ou `mysql` CLI)
- [ ] Copiar `.env.example` para `.env` e preencher usuario/senha
- [ ] Criar venv, `pip install -r requirements.txt`, rodar `cd web` e `python app.py`
- [ ] Abrir `http://127.0.0.1:5000/` e confirmar status de conexao ok
- [ ] Abrir `http://127.0.0.1:5000/saude` e confirmar HTTP 200 com `SELECT 1`
- [ ] Testar falha proposital (senha errada no `.env`) e verificar mensagem clara na home/`/saude`
