# Webdriver --- Diretrizes para uma interface mínima

## 1. Objetivo

Orientar um agente de IA a construir uma interface inicial, rudimentar e
funcional para o projeto acadêmico Webdriver.

A interface existe para demonstrar as funcionalidades do sistema e
testar a integração com o MySQL. O foco do projeto é a modelagem, a
integridade dos dados e as regras implementadas no banco --- não um
front-end elaborado.

**Princípio central:** implementar o menor produto funcional que permita
demonstrar os requisitos e explicar cada operação.

## 2. Contexto do sistema

O Webdriver é uma plataforma de gerenciamento e compartilhamento de
arquivos. O modelo apresentado no projeto contempla:

-   **plano:** plano contratado e espaço por usuário;
-   **instituicao:** organização associada a um plano;
-   **usuario:** pessoa vinculada a uma instituição;
-   **administrador:** especialização de usuário;
-   **arquivo:** arquivo pertencente a um usuário;
-   **compartilha:** registro de compartilhamento de um arquivo com
    outro usuário;
-   **comentario:** comentário associado a usuário e arquivo;
-   **solicitar_suporte:** solicitação feita por usuário e direcionada a
    administrador, opcionalmente relacionada a um arquivo;
-   **historico:** registro de operações realizadas sobre arquivos.

Respeitar os minimundos, diagramas e scripts SQL fornecidos. Não
inventar entidades, atributos, relacionamentos ou regras de negócio.
Quando houver divergência entre os materiais, apontar o conflito e
solicitar decisão; não corrigir silenciosamente.

## 3. Escopo visual

A interface deve ser propositalmente simples: HTML nativo, formulários,
tabelas, links e botões básicos.

Não implementar:

-   identidade visual elaborada, animações ou transições;
-   dashboards gráficos ou componentes complexos;
-   notificações sofisticadas;
-   bibliotecas visuais sem necessidade;
-   funcionalidades não previstas nos documentos;
-   upload real do conteúdo binário dos arquivos, a menos que isso seja
    exigido pelo minimundo ou aprovado pelo grupo.

Priorizar legibilidade, previsibilidade e facilidade de apresentação em
sala de aula.

## 4. Telas mínimas

Criar somente as telas necessárias para demonstrar os requisitos.

### 4.1 Página inicial

-   Identificar o sistema como Webdriver.
-   Apresentar links para as áreas implementadas.
-   Exibir o usuário atual, se houver autenticação real.
-   Não criar landing page elaborada.

### 4.2 Usuários

-   Listar, cadastrar, consultar e atualizar usuários.
-   Permitir exclusão somente quando as regras de integridade
    permitirem.

### 4.3 Arquivos

-   Listar, cadastrar, consultar, atualizar e remover arquivos.
-   Exibir o proprietário.
-   Na primeira versão, trabalhar com os metadados previstos no modelo:
    nome, tipo, permissões, tamanho, data de modificação, localização e
    URL.
-   Não presumir que o banco armazena o conteúdo binário do arquivo.

### 4.4 Compartilhamentos

-   Listar compartilhamentos.
-   Selecionar arquivo e usuário destinatário.
-   Registrar a data.
-   Exibir proprietário e destinatário.
-   Respeitar a regra de que o proprietário não pode compartilhar
    consigo mesmo.

### 4.5 Comentários

-   Listar comentários de um arquivo.
-   Registrar comentário, autor, data e hora.

### 4.6 Suporte

-   Criar e listar solicitações.
-   Selecionar solicitante e administrador responsável.
-   Permitir arquivo opcional.
-   Informar descrição, dia e hora.

### 4.7 Histórico

-   Consultar operações de um arquivo.
-   Exibir operação, usuário responsável, data, hora e conteúdo
    alterado.
-   Não permitir edição manual do histórico sem requisito explícito.

### 4.8 Administração

-   Disponibilizar consultas administrativas necessárias à demonstração.
-   Não simular permissões apenas escondendo botões.
-   Respeitar as permissões reais do MySQL quando Roles e Views
    estiverem implementadas.

## 5. Relação com a Parte 2

A interface deve facilitar a demonstração dos recursos do banco, sem
duplicar sua lógica na aplicação.

-   **Views:** consultar as visões definidas para cada perfil.
-   **Roles:** testar permissões com contas/usuários de banco
    apropriados. Não simular segurança no front-end.
-   **Procedures:** chamar as procedures exigidas quando a operação
    corresponder a uma delas, em vez de reimplementar sua lógica.
-   **Functions:** utilizar a função prevista quando for necessário
    apresentar seu resultado.
-   **Triggers:** deixar o MySQL executar os gatilhos automaticamente; a
    aplicação apresenta o resultado ou a mensagem de erro.
-   **atividades_recentes:** seguir os campos e as regras definidos no
    documento da Parte 2. Não presumir comportamentos não especificados.

## 6. Regras obrigatórias para o agente de IA

1.  Antes de alterar arquivos, inspecionar o repositório, README,
    scripts SQL, diagramas e documentos disponíveis.
2.  Confirmar qual tecnologia de backend foi escolhida pelo grupo.
3.  Preservar nomes de tabelas e colunas existentes.
4.  Não recriar o banco automaticamente nem executar comandos
    destrutivos.
5.  Não alterar scripts SQL sem explicar motivo, impacto e requisito
    relacionado.
6.  Implementar uma funcionalidade por vez, com mudanças pequenas.
7.  Preferir HTML nativo e CSS mínimo.
8.  Separar minimamente rotas, acesso ao banco e apresentação, sem
    arquitetura excessiva.
9.  Utilizar consultas parametrizadas. Nunca concatenar diretamente
    entradas do usuário em SQL.
10. Manter credenciais em variáveis de ambiente; não versionar o arquivo
    `.env`.
11. Tratar erros de conexão, validação e integridade com mensagens
    simples.
12. Nunca armazenar senhas em texto puro. Se houver autenticação,
    utilizar hash apropriado.
13. Não implementar autenticação ou autorização fictícia. Identificar
    limitações enquanto não houver segurança real.
14. Manter dados de demonstração em script separado e claramente
    identificado.
15. Ao concluir cada etapa, informar arquivos criados/alterados,
    requisitos atendidos e instruções de teste.

## 7. Comentários no código

O código deve ser didático para um estudante que precisa explicar a
implementação.

-   Comentar cada linha executável do código-fonte com uma explicação
    curta de sua finalidade.
-   Em blocos pequenos e repetitivos, um comentário pode explicar um
    conjunto de linhas quando a função de cada linha estiver evidente.
-   Não repetir literalmente o nome da instrução no comentário.
-   Explicar especialmente consultas SQL, parâmetros, validações,
    tratamento de erros e chamadas a procedures/functions.
-   Evitar comentários longos ou óbvios.
-   Arquivos que não aceitam comentários, como determinados formatos
    JSON, devem ser explicados em documentação Markdown próxima. Não
    inserir comentários que tornem o arquivo inválido.

Exemplo ilustrativo em Python:

``` python
# Importa a classe usada para criar a aplicação web.
from flask import Flask

# Cria a instância principal da aplicação.
app = Flask(__name__)

# Associa a função abaixo à página inicial.
@app.route("/")
def inicio():
    # Retorna um conteúdo HTML mínimo ao navegador.
    return "<h1>Webdriver</h1>"
```

O exemplo não determina a escolha de Flask. A tecnologia deve ser
confirmada pelo grupo.

## 8. Tecnologia e compatibilidade

Utilizar exclusivamente a tecnologia de backend definida pelo grupo:

-   Se a escolha for **Flask**, implementar o backend em Python e
    utilizar um conector MySQL compatível.
-   Se a escolha for **Node.js**, implementar o backend em JavaScript e
    utilizar um driver MySQL compatível.
-   Não manter duas implementações paralelas.
-   Não migrar de tecnologia sem autorização explícita.
-   Manter o MySQL local e o banco `webdriver_db`, salvo decisão
    documentada do grupo.

Antes de instalar dependências, verificar o que já existe no repositório
e reutilizar o que for adequado.

## 9. Critérios de aceite da primeira versão

A primeira versão será suficiente quando:

-   [ ] A aplicação iniciar localmente com instruções simples.
-   [ ] A aplicação conectar ao MySQL local.
-   [ ] A página inicial apresentar navegação básica.
-   [ ] For possível listar e cadastrar usuários.
-   [ ] For possível listar e cadastrar metadados de arquivos.
-   [ ] For possível registrar e consultar compartilhamentos.
-   [ ] For possível registrar e consultar comentários.
-   [ ] For possível registrar e consultar solicitações de suporte.
-   [ ] For possível consultar o histórico.
-   [ ] As operações respeitarem as constraints do banco.
-   [ ] As consultas forem parametrizadas.
-   [ ] Não houver funcionalidades visuais ou técnicas sem relação com
    os requisitos.

Os itens podem ser entregues gradualmente. Não é necessário construir
todas as telas antes de validar a conexão e a primeira operação.

## 10. Ordem de execução

1.  Inspecionar o repositório e confirmar a tecnologia escolhida.
2.  Conferir se `webdriver_db` existe e se as tabelas foram criadas.
3.  Configurar a conexão por variáveis de ambiente.
4.  Criar a página inicial mínima.
5.  Implementar listagem e cadastro de usuários.
6.  Implementar listagem e cadastro de arquivos.
7.  Implementar compartilhamentos e comentários.
8.  Implementar suporte e consulta ao histórico.
9.  Integrar as telas aos recursos da Parte 2 conforme forem
    implementados.
10. Testar cada fluxo e documentar limitações.

Executar um teste pequeno ao final de cada etapa antes de continuar.

## 11. Instrução final ao agente

Atue como desenvolvedor orientado a escopo mínimo e como tutor técnico.

O objetivo não é produzir uma aplicação comercial ou visualmente
sofisticada. É criar uma interface acadêmica funcional, pequena e fácil
de explicar, que demonstre os requisitos do Webdriver e permita validar
o banco.

Antes de implementar, apresente um plano curto com os arquivos que
pretende criar ou alterar. Aguarde validação quando houver dúvida sobre
regra de negócio, tecnologia, estrutura do banco ou requisito dos
documentos.

Não invente requisitos. Não faça refatorações amplas. Não gere código
desnecessário. Explique as decisões e mantenha cada implementação no
menor tamanho razoável.
