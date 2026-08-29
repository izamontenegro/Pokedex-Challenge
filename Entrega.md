# ENTREGA

## Listagem e paginação

A listagem da PokéAPI retorna apenas informações básicas de cada Pokémon, principalmente `name` e a URL para seus detalhes. Entretanto, a interface da lista precisava também de informações como número, sprite e tipos.

Por isso, para cada página carregada, é necessário realizar a requisição da listagem e posteriormente buscar os detalhes de cada Pokémon retornado. Em uma página com 20 Pokémon, por exemplo, isso resulta em uma requisição inicial e outras 20 requisições de detalhes.

Como esses detalhes são necessários para todas as linhas da lista, concentrei essa composição no `FetchPokemonPageUseCase`. Dessa forma, a ViewModel não precisa conhecer a estratégia necessária para obter todas as informações que serão exibidas.

As requisições de detalhes são realizadas **concorrentemente com `withThrowingTaskGroup`**, evitando que cada Pokémon precise aguardar o término da requisição anterior. Como tarefas concorrentes podem terminar em ordens diferentes, os resultados são ordenados novamente pelo `id` antes de serem retornados.

Nesse fluxo foram criados `PokemonPageItem` e `PokemonPageResult`.

O `PokemonPageItem` representa um item completo da página, associando o `PokemonSummary`, recebido inicialmente pela listagem, ao seu respectivo `PokemonDetail`. Dessa forma, a camada superior recebe os dados já combinados, sem precisar saber que eles vieram de requisições diferentes.

O `PokemonPageResult`, por sua vez, representa o resultado completo de uma página. Ele contém os itens já processados e a informação `hasNextPage`, utilizada pela ViewModel para decidir se novas páginas ainda podem ser carregadas.

A paginação é disparada quando o usuário se aproxima do final da lista. Optei por iniciar a próxima busca algumas posições antes do último item, em vez de esperar que o usuário chegue exatamente ao fim, diminuindo a percepção do tempo de carregamento.

## Carregamento e tratamento de estados

As buscas são iniciadas quando o usuário entra nas respectivas telas. As ViewModels são responsáveis por controlar os estados da interface, como carregamento, sucesso, conteúdo vazio e erro.

## Tela de detalhes

A navegação envia apenas o identificador do Pokémon e a tela de detalhes realiza sua própria busca. Essa decisão mantém o modelo da listagem enxuto, contendo apenas os dados necessários para a célula, e evita acoplar a tela de detalhes ao formato utilizado pela lista. Como melhoria futura, seria possível reaproveitar os dados já carregados e buscar apenas as informações que ainda fossem necessárias, reduzindo requisições repetidas.

Também adicionei uma seção de **evoluções**. Para obter essa informação, a PokéAPI exige primeiro consultar a espécie do Pokémon e, a partir dela, acessar a URL correspondente à cadeia de evolução. Essa lógica ficou concentrada na camada de dados e exposta através de um use case específico, evitando colocar conhecimento sobre os endpoints dentro da ViewModel.

## Meu Time

As regras de negócio relacionadas ao time ficaram concentradas no `ManageTeamUseCase`. Ele é responsável por impedir Pokémon duplicados, limitar o time a seis integrantes, remover membros e gerar o resumo do time.

A persistência permanece abstraída pelo `TeamRepository`, utilizando a implementação com `UserDefaults` fornecida pelo projeto.

## Imagens

Implementei um cache em memória para as imagens utilizando `NSCache`, evitando downloads repetidos dos mesmos sprites durante a execução da aplicação.

Escolhi `NSCache` por ser uma solução simples e suficiente para o escopo do projeto.

## Organização do projeto

Preferi evoluir a arquitetura existente em vez de substituí-la. A estrutura original já apresentava uma separação clara entre apresentação, regras de negócio e acesso aos dados.

As principais mudanças estruturais foram:

- retirada da criação de dependências de dentro das ViewModels;
- introdução do `AppContainer`;
- organização das Views por fluxo;
- criação de componentes reutilizáveis;
- criação de `Utils` para responsabilidades auxiliares;
- centralização de regras e operações nos respectivos use cases.

Considerei uma reorganização completa por features, mas, para o tamanho atual do projeto, isso aumentaria a quantidade de estrutura sem resolver um problema real. Preferi manter uma organização mais simples e proporcional ao escopo da aplicação.

Para a **navegação**, utilizei `NavigationStack` com um enum `PokemonRoute`, concentrando as rotas possíveis da aplicação. Como existem poucas telas e o fluxo de navegação é simples, considerei essa solução suficiente para o escopo atual. Em uma aplicação maior, com mais fluxos e maior complexidade de navegação, optaria por uma abordagem como o padrão `Coordinator`.

## O que ficou de fora

### Busca por nome

Não implementei a **busca por nome**. A principal dificuldade está relacionada à forma como a listagem e a PokéAPI funcionam.

Como a aplicação trabalha com paginação, apenas os Pokémon das páginas já carregadas estão disponíveis localmente. Uma busca apenas nesses elementos produziria resultados incompletos.

Para realizar uma busca global mantendo as mesmas informações apresentadas nas células da lista, seria necessário obter uma quantidade muito maior de Pokémon e posteriormente realizar novas requisições para buscar os detalhes de cada resultado.

Dentro do tempo disponível, considerei que essa abordagem aumentaria consideravelmente a quantidade de requisições e preferi não adicionar uma implementação incompleta ou pouco eficiente.

### Testes

Também não consegui implementar a cobertura de **testes unitários** que gostaria dentro do prazo.

A alteração na injeção de dependências foi feita pensando justamente nessa evolução. Como ViewModels e use cases recebem suas dependências externamente e através de protocolos, torna-se mais simples substituir implementações reais por mocks ou stubs e testar cada comportamento isoladamente.

Com mais tempo, essa seria uma das principais próximas etapas do projeto.

## Próximas melhorias

A primeira melhoria seria implementar testes unitários para os principais Use Cases e ViewModels, cobrindo especialmente os fluxos de paginação, tratamento de erros, carregamento concorrente dos detalhes e regras de gerenciamento do time.

Também adicionaria um **cache para os dados da listagem e dos detalhes**, além do cache de imagens que já existe.
