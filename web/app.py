# Framework web minimo usado pela interface academica.
from flask import Flask, render_template

# Função que valida a conexao com o MySQL sem alterar dados.
from db import testar_conexao


# Cria a aplicacao Flask e resolve templates/static relativos a esta pasta.
app = Flask(__name__)


def pagina_placeholder(titulo, operacao):
    # Renderiza tela temporaria ate a rota receber SQL real.
    return render_template(
        "em_breve.html",
        titulo=titulo,
        operacao=operacao,
    )


@app.route("/")
def inicio():
    # Testa o MySQL para mostrar status textual na pagina inicial.
    ok, mensagem = testar_conexao()
    # Renderiza o HTML da home com o resultado do teste.
    return render_template(
        "index.html",
        conexao_ok=ok,
        mensagem_conexao=mensagem,
    )


@app.route("/saude")
def saude():
    # Repete o teste de conexao em uma rota dedicada a diagnostico.
    ok, mensagem = testar_conexao()
    # Codigo HTTP 200 se conectou; 503 se o MySQL nao respondeu.
    status = 200 if ok else 503
    # Pagina simples so com o texto do resultado.
    return render_template(
        "saude.html",
        conexao_ok=ok,
        mensagem_conexao=mensagem,
    ), status


# --- Usuarios (placeholders; ligar ao SQL depois) ---

@app.route("/usuarios")
def usuarios_listar():
    return pagina_placeholder("Usuarios", "LISTAR")


@app.route("/usuarios/cadastrar")
def usuarios_cadastrar():
    return pagina_placeholder("Usuarios", "CADASTRAR")


@app.route("/usuarios/consultar")
def usuarios_consultar():
    return pagina_placeholder("Usuarios", "CONSULTAR")


@app.route("/usuarios/atualizar")
def usuarios_atualizar():
    return pagina_placeholder("Usuarios", "ATUALIZAR")


@app.route("/usuarios/excluir")
def usuarios_excluir():
    return pagina_placeholder("Usuarios", "EXCLUIR")


# --- Arquivos ---

@app.route("/arquivos")
def arquivos_listar():
    return pagina_placeholder("Arquivos", "LISTAR")


@app.route("/arquivos/cadastrar")
def arquivos_cadastrar():
    return pagina_placeholder("Arquivos", "CADASTRAR")


@app.route("/arquivos/consultar")
def arquivos_consultar():
    return pagina_placeholder("Arquivos", "CONSULTAR")


@app.route("/arquivos/atualizar")
def arquivos_atualizar():
    return pagina_placeholder("Arquivos", "ATUALIZAR")


@app.route("/arquivos/remover")
def arquivos_remover():
    return pagina_placeholder("Arquivos", "REMOVER")


# --- Compartilhamentos ---

@app.route("/compartilhamentos")
def compartilhamentos_listar():
    return pagina_placeholder("Compartilhamentos", "LISTAR")


@app.route("/compartilhamentos/registrar")
def compartilhamentos_registrar():
    return pagina_placeholder("Compartilhamentos", "REGISTRAR")


# --- Comentarios ---

@app.route("/comentarios")
def comentarios_listar():
    return pagina_placeholder("Comentarios", "LISTAR")


@app.route("/comentarios/registrar")
def comentarios_registrar():
    return pagina_placeholder("Comentarios", "REGISTRAR")


# --- Suporte ---

@app.route("/suporte")
def suporte_listar():
    return pagina_placeholder("Suporte", "LISTAR")


@app.route("/suporte/criar")
def suporte_criar():
    return pagina_placeholder("Suporte", "CRIAR")


# --- Historico (somente leitura) ---

@app.route("/historico")
def historico_consultar():
    return pagina_placeholder("Historico", "CONSULTAR")


# Permite executar com: python app.py (a partir da pasta web/).
if __name__ == "__main__":
    # Sobe o servidor de desenvolvimento na porta padrao do Flask.
    app.run(debug=True)
