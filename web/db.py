# Expoe funcoes para ler variaveis de ambiente com valor padrao.
import os

# Monta caminhos absolutos ate o .env na raiz do repositorio.
from pathlib import Path

# Carrega variaveis do arquivo .env para o ambiente do processo.
from dotenv import load_dotenv

# Conector oficial do MySQL para Python.
import mysql.connector

# Classe de erro tipica de falha de conexao ou autenticacao.
from mysql.connector import Error


# Pasta deste arquivo (web/).
_DIR_WEB = Path(__file__).resolve().parent

# Raiz do repositorio (pai de web/).
_DIR_RAIZ = _DIR_WEB.parent

# Le sempre o .env da raiz, independente da pasta de onde o Flask sobe.
load_dotenv(_DIR_RAIZ / ".env")


def get_connection():
    # Abre uma conexao nova com o MySQL usando so dados do ambiente.
    return mysql.connector.connect(
        # Endereco do servidor MySQL local.
        host=os.getenv("MYSQL_HOST", "127.0.0.1"),
        # Porta padrao do MySQL, convertida para inteiro.
        port=int(os.getenv("MYSQL_PORT", "3306")),
        # Usuario do banco (nao confundir com a tabela usuario).
        user=os.getenv("MYSQL_USER", "root"),
        # Senha do usuario do MySQL; vazia se nao definida.
        password=os.getenv("MYSQL_PASSWORD", ""),
        # Nome do schema criado pelo script 01.
        database=os.getenv("MYSQL_DATABASE", "webdriver_db"),
    )


def testar_conexao():
    # Guarda a conexao para fechar no finally.
    conexao = None
    try:
        # Tenta autenticar e selecionar o banco.
        conexao = get_connection()
        # Cria um cursor para enviar SQL.
        cursor = conexao.cursor()
        # Consulta minima so para validar que o servidor responde.
        cursor.execute("SELECT 1")
        # Consome o resultado para liberar o cursor.
        cursor.fetchone()
        # Encerra o cursor apos o teste.
        cursor.close()
        # Indica sucesso sem detalhe sensivel.
        return True, "Conexao com webdriver_db ok."
    except Error as erro:
        # Devolve a mensagem do MySQL para a tela de saude.
        return False, str(erro)
    finally:
        # Fecha a conexao se ela chegou a abrir.
        if conexao is not None and conexao.is_connected():
            conexao.close()
