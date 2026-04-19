# Componentes Padrão - LIT

Um repositório de códigos de todos os componentes padrão que devem ser usados para construir seus aplicativos LIT/Unichristus.

Você pode acessar um exemplo de design no seguinte link do [Figma](https://www.figma.com/file/xcFQpipRDFHCvOx6wK1ssc/app-cirurgia-ocular?type=design&node-id=60%3A1267&t=0vOBaxO7gzCFZ8lR-1) do projeto [**cirurgia_ocular**](https://github.com/lit-ipade/cirurgia_ocular).

[1 - Getting Started/Set up](#getting-startedset-up)

[2 - Style Guidelines](#style-guidelines)

[3 - Componentes](#componentes)

## Getting Started/Set up

Antes de começar a usar os componentes padrões do LIT é preciso adicionar as bibliotecas e dependencias necessárias para o funcionamento!

### Depedências

#### flutter_localizations

Adcione a dependência **flutter_localizations**  da seguinte forma no arquivo _pubspec.yaml_ do seu projeto:

![flutter_localizations](/assets/images/dependencia.png "Código pubspec.yaml")

Após isso, adicione no widget **MaterialApp**, que deve ser a raiz do seu projeto, o seguinte trecho de código:

![locales](/assets/images/locales.png "Código main.dart")

Assim, seu aplicativo terá como linguagem base a língua portuguesa, mantendo o padrão.

### Packges ou Bibliotecas

Você precisa adicionar, inicialmente, 3 pacotes!

Esses pacotes são essenciais para o funcionamentos dos widgets que devem ser usados no seu aplicativo, então **NÃO PULE** esse passo.

A seguir você vai encontrar a listagem de todas as bibliotecas que deve adicionar + o uso:

![packages](/assets/images/packages.png "pubspec.yaml")
*Você pode adicionar apenas essas linhas*

#### google_fontes

Carrega as fontes padrões que deverão ser utilizadas nos TextStyles de todos os seus textos. [Link de acesso](https://pub.dev/packages/google_fonts)

#### brasil_fields

Pacote validação de padrões e formatos brasileiros. É utilizado na validação de CPF e data, mas você pode aproveitá-lo para outras coisas. [Link de acesso](https://pub.dev/packages/brasil_fields)

#### email_validator

Outro pacote de validação, mas dessa vez para e-mails. [Link de acesso](https://pub.dev/packages/email_validator) 
<br/>

### Theme Set Up

Após adicionar todos as dependências e os packages necessários, você deve copiar a página **components** desse repositório para o seu projeto. É lá que você vai encontrar todos widgets e padrões de estilo já previamente definidos.

É provável que você irá precisar resolver possíveis conflitos de importação, mas após isso tudo deve funcionar normalmente.

Com isso, você vai poder começar a usar todos os componentes já previamente criados no seu aplicativo!

Mas antes adicione as seguintes linhas de código dentro do widget _MaterialApp_ para que todo o seu aplicativo siga as normas de estilo básicas de cor definidas, ou seja, o tema.

![theme](/assets/images/theme.png "main.dart")

[↑ back to top ↑](#componentes-padrão---lit)

-----

## Style Guidelines

A seguir você irá encontrar as regras básicas de estilo que você deve seguir durante a construção do seu aplicativo. Para mais detalhes, acesse o link do Figma disponibilizado no início dessa página.

* [2.1 Cores](#cores)
* [2.2 Tipografia](#tipografia)

### Cores

Existem 13 cores pré-definidas para serem usadas por todo seu aplicativo, podendo ser separadas em 3 categorias diferentes: ***cores principais***, ***cores secundárias*** ou de apoio e ***cores específicas***.

#### Cores Principais

São apenas 3 cores que são usadas por todo o aplicativo: azul, branco e preto.

São as cores da marca LIT e não devem ser alteradas. Todo cor de texto deve se restrigir a apenas essa categoria.

***NUNCA USE PRETO E BRANCO PUROS!***

![principais](/assets/images/principais.png "cores principais")

#### Cores Secundárias ou de Apoio

São apenas 2 cores que não tem usos definidos, mas possa ser que você precise delas para contrastar com as cores principais.

![apoio](/assets/images/apoio.png "cores secundárias")

#### Cores Específicas

São 8 cores que os usos são definidos, mas você pode adaptar da maneira que achar conveniente.

Diferentemente das outras categorias, você pode expandir a quantidade de cores conforme achar necessário durante a construção do seu aplicativo, se atentando apenas ao contraste delas com a cor de fundo que você está usando.

![especificas](/assets/images/especiais.png "cores específicas")

### Tipografia

Os estilos de texto foram definidos com base no design padrão atual, criado com base no aplicativo da Unichristus.

A única fonte utilizada é a Mulish em diferentes tamanhos e pesos, disponível no pacote de fontes do Google, que você deve adicionar ao projeto. A seguir a hierarquia:

![tipo](/assets/images/tipo.png "hierarquia de tipos")

-----

[↑ back to top ↑](#componentes-padrão---lit)

## Componentes

No momento, os componentes padrões ou widgtes podem ser divididos em 3 categorias:

* [3.1 Buttons](#buttons)
* [3.2 Text-Fields](#text-fields)
* [3.3 List Tiles](#list-tiles)

### Buttons

No total existem 5 botões, onde um é um Radio Button.

A seguir você vai encontrar a documentação desses widgets, que está disponivel via código, podendo ser acessada ao colocar o mouse em cima do nome do componente sendo usado.

#### HomeButton

![home button](/assets/components/consultas.png "home button")

> A simple square button with an image background.
> 
> This version is used to list the **different options** a user can take.

#### SimpleButton

![simple button](/assets/components/Group23.png "simple button")

> A simple button with only text.
> 
> There is a dark and a light version to be **used accordingly**.

#### ButtonContainer

![button conteiner](/assets/components/agendadas.png "button conteiner")

> Another simple button with text and a background image.
> 
> This version is used for **listing categories**.

#### CustomTextButton

![text button](/assets/components/Group25.png "text button")

> A simple text button to be used for a secondary action or an action that the user most likely will never touch.
> 
> There is a dark and a light version to be **used accordingly**.

#### LabeledRadio

![radio](/assets/components/Frame128.png "radio")

> A simple text button to be used when you want to get a choice information from your user.
> 
> There is a dark and a light version to be **used accordingly**.

### Text Fields

![text field](/assets/components/Group24.png "text field")

Diferentemente da categoria anterior, essa categoria possui widget muito mais complexos com funcionalidades embutidas, justamente por esperar um input do usuário.

A seguir você vai encontrar a documentação desses widgets, que está disponivel via código, podendo ser acessada ao colocar o mouse em cima do nome do componente sendo usado.

#### SimpleTextField

> A simple text field to be used for a simple text input, with options to validate cpf, email or if the input is empty. There is also a option to only allow digits in case you need this.
>
> If you want to hide the label, pass this atribute as an empty string.
> 
> There is a dark and a light version to be **used accordingly**.

#### ObscureTextField

> A text field to be used for a simple text input that requires an option to obscure the input, to be used for password or sensitive data that the user may like to hide. The default validation of this widget is validate a password with 6 digits, in case you set the atributte "isPassword" to _false_ the validation will allow any combinations minus an empty input.
> _**This widget is a variation of the [SimpleTextField](#simpletextfield)**_
> 
> If you want to hide the label, pass this atribute as an empty string.
> 
> There is a dark and a light version to be **used accordingly**.

#### DatePickerTextField

> A text field to be used when you need to get a date information of your user.
> 
> You need to pass a _**start date**_ and an _**end date**_ of the timeframe you want, then it will only allow your user to select a date in between these two, avoiding an input error. Validation takes place only for this interval and the mandatory completion of the field.
> 
> The default start date and end date entries are 01/01/1920 and the present date, respectively. If you want to set the timeframe there is a few restrictions you must follow. The start date **MUST NOT** exceed the date 01/01/1920, otherwise the widget will automatically set the start date to that one. On the other hand, the **ONLY** restriction of the end date is to be after the start date, otherwise it will automatically set the date to the present day.
>
> If you want to hide the label, pass this atribute as an empty string.
> 
> There is a dark and a light version to be **used accordingly**.

#### TimePickerTextField

> A text field to be used when you need to get a time information of your user.
> 
> Unlike the widget [DatePickerTextField](#datepickertextfield), this widget doesn't require a start and end date, because the user will only select a time.
> 
> If you want to hide the label, pass this atribute as an empty string.
> 
> There is a dark and a light version to be **used accordingly**.

### List Tiles

Atualmente, existem apenas dois widgets nessa categoria, mas caso mais sejam criados eles serão documentados e colocados aqui junto com os outros.

Esses widgets são usados quando se deseja listar informações para seu usuário, como consultas, exames, pacientes, etc.

#### ListContainerTile

![ListContainerTile](/assets/components/Card.png "ListContainerTile")

> A container to display information with a background image to indicate the category of the information. To be used in list views.
> 
> The lists _topInfo_ and _bottomInfo_ needs to be of a **maximum length of 2**, aka it needs to have one or two items. 
> 
> If you **DON'T** want to show any bottom info, use the widget SimpleListContainerTile.
> 
> The _title_ is the main information you want to display. Be sure to use this widget the correct way. If the tile opens a page, pass the action on the _onTap_ atributte.

#### SimpleListContainerTile

![SimpleListContainerTile](/assets/components/Card-Chat.png "SimpleListContainerTile")

> A simpler version of the widger ListContainerTile to be used to display information with a background image to indicate the category of the information. To be used in list views
> 
> The list _topInfo_ needs to be of a **maximum length of 2**, aka it needs to have one or two itemsgit
> 
> The _title_ is the main information you want to display. Be sure to use this widget the correct way. If the tile opens a page, pass the action on the _onTap_ atributte.

#### CustomExpasionTile

![CustomExpasionTile](/assets/components/tile.png "CustomExpasionTile")

> A version of the flutter widget 'ExpansionTile', but following the LIT style guidelines.
> 
> Use this widget when you want to compile some information of your user and show only when they want to see.
> 
> **USE ONLY ON A LIGHT BACKGROUND.**

----

[↑ back to top ↑](#componentes-padrão---lit)

## Table of content

[1 - Getting Started/Set up](#getting-startedset-up)

[2 - Style Guidelines](#style-guidelines)

[3 - Componentes](#componentes)
