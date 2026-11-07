# Pull request — feature/interface-home-crud → feature/esqueleto-interface

Base: `feature/esqueleto-interface` (nao `main`).
Depois que o esqueleto for mergeado em `developer`, esta PR pode ser retargetada para `developer`.

Use este texto no GitHub se o `gh` ainda nao estiver autenticado.

**Compare:** https://github.com/Adryan-raf/SYSTEM-DATABASE/compare/feature/esqueleto-interface...feature/interface-home-crud?expand=1

**Title:** feat: botoes CRUD na home com rotas placeholder

---

## Summary

- Atualiza a pagina inicial com botoes evidentes por entidade (usuarios, arquivos, compartilhamentos, comentarios, suporte e historico).
- Cria rotas Flask nomeadas para cada operacao prevista; por enquanto todas abrem `em_breve.html` sem consultar nem alterar o MySQL.
- Liga a navegacao do cabecalho as rotas de listagem/consulta e documenta o limite no `web/README.md` e no `docs/CHANGELOG.md`.

## Escopo e limites

- Botoes e urls prontos para o proximo passo (ligar cada rota ao SQL parametrizado).
- Sem formularios reais, sem INSERT/UPDATE/DELETE e sem autenticacao.
- Sem alteracao nos scripts SQL da Parte 1.
- Historico permanece somente leitura, sem botao de edicao.

## Test plan

- [ ] Estar na branch `feature/interface-home-crud` com o Flask rodando (`cd web` e `python app.py`)
- [ ] Abrir `http://127.0.0.1:5000/` e confirmar que os blocos CRUD aparecem com botoes
- [ ] Clicar em pelo menos um botao de cada entidade e confirmar que abre a tela placeholder
- [ ] Confirmar que a nav (Usuarios, Arquivos, etc.) tambem abre as rotas de listagem/consulta
- [ ] Confirmar que home e `/saude` continuam mostrando o status da conexao MySQL
- [ ] Confirmar que nenhuma operacao CRUD altera dados no banco nesta versao
