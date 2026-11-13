# Framework web minimo usado pela interface academica.
from flask import Flask, render_template

# Função que valida a conexao com o MySQL sem alterar dados.
from db import testar_conexao


# Cria a aplicacao Flask e resolve templates/static relativos a esta pasta.
app = Flask(__name__)


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


# Permite executar com: python app.py (a partir da pasta web/).
if __name__ == "__main__":
    # Sobe o servidor de desenvolvimento na porta padrao do Flask.
    app.run(debug=True)
