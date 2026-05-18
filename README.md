# Reabilita Ombro

Aplicativo de reabilitação de ombro desenvolvido pelo **Laboratório de Inovações Tecnológicas (LIT)**.

Plataforma Flutter que guia pacientes através de protocolos de reabilitação pós-cirúrgicos do ombro, com exercícios em vídeo via YouTube e acompanhamento médico em tempo real.

## Funcionalidades

### Paciente
- Cadastro com dados clínicos (nome, idade, data de nascimento, data da cirurgia)
- Confirmação de senha no registro
- Visualização de níveis de exercícios com status visual (disponível, concluído, aguardando, bloqueado)
- Execução de exercícios com player de vídeo YouTube integrado
- Pesquisa de dor pós-exercício (escala 1–5: antes, durante, depois)
- Progressão automática de níveis após conclusão

### Médico
- Painel de gerenciamento de pacientes
- Criação e edição de níveis personalizados por paciente
- Atribuição de exercícios com URLs do YouTube (preview de thumbnail ao vivo)
- Liberação manual de níveis para cada paciente
- Visualização de resultados das pesquisas de dor

## Tecnologias

| Camada | Tecnologia |
|--------|-----------|
| Frontend | Flutter / Dart |
| Autenticação | Firebase Auth (email/senha) |
| Banco de dados | Cloud Firestore |
| Vídeo | YouTube Player (youtube_player_flutter) |
| Componentes UI | componentes_padrao (biblioteca local) |

## Arquitetura

```
lib/
├── main.dart                          — Entry point, tema, rotas
├── firebase_options.dart              — Configuração Firebase (gitignored)
└── src/
    ├── models/
    │   ├── level_model.dart           — LevelModel + ExerciseItem
    │   ├── survey_model.dart          — SurveyModel (escalas de dor 1-5)
    │   └── user_model.dart            — UserModel (médico | paciente)
    ├── services/
    │   ├── auth_service.dart          — Wrapper FirebaseAuth, erros pt-BR
    │   └── database_service.dart      — CRUD Firestore (subcoleções por paciente)
    └── views/
        ├── auth_gate.dart             — Roteamento declarativo por role
        ├── login_view.dart            — Login email/senha
        ├── patient_register_view.dart — Registro de paciente (7 campos + confirmação de senha)
        ├── patient_home_view.dart     — Cards de níveis com status
        ├── phase_detail_view.dart     — Lista de exercícios do nível
        ├── exercise_view.dart         — Player YouTube integrado
        ├── survey_view.dart           — Pesquisa de dor (3 perguntas, escala 1-5)
        ├── completion_view.dart       — Tela de conclusão
        └── doctor/
            ├── doctor_home_view.dart      — Lista de pacientes
            ├── patient_detail_view.dart   — Gerenciamento de níveis por paciente
            ├── level_manager_view.dart    — Editor de nível (URLs YouTube + thumbnail)
            └── survey_results_view.dart   — Visualização de pesquisas de dor
```

## Esquema Firestore

```
users/{uid}
├── uid, email, name, role, createdAt
├── (paciente) dateOfBirth, age, dateOfSurgery, doctorUid
└── levels/{levelId}              ← subcoleção por paciente
    ├── order, title, exercises[{title, videoUrl}]
    ├── status ("available"|"completed"|"waiting"|"locked")
    └── completedAt, createdAt, createdBy

surveys/{surveyId}
├── patientUid, levelOrder
├── painBefore, painDuring, painAfter (1-5)
└── submittedAt
```

## Configuração do Projeto

### Pré-requisitos
- Flutter SDK ^3.10.8
- Conta Firebase com projeto configurado
- Arquivo `google-services.json` (Android) e/ou `GoogleService-Info.plist` (iOS)

### Instalação

```bash
# Clone o repositório
git clone <url-do-repositorio>
cd reabilitaOmbro-app

# Instale as dependências
flutter pub get

# Configure o Firebase
# 1. Gere firebase_options.dart com FlutterFire CLI:
#    flutterfire configure
# 2. Coloque google-services.json em android/app/
# 3. Coloque GoogleService-Info.plist em ios/Runner/

# Execute
flutter run
```

### Regras Firestore
Copie o conteúdo de `firestore.rules` para o Firebase Console → Firestore → Rules e publique.

## Segurança

Os seguintes arquivos sensíveis estão protegidos pelo `.gitignore`:
- `firebase_options.dart` — Chaves de API do Firebase
- `google-services.json` / `GoogleService-Info.plist` — Configuração Firebase
- `*.jks` / `*.keystore` / `key.properties` — Assinatura de app
- `.env` / `.env.*` — Variáveis de ambiente

## Licença

Todos os direitos reservados ao **Laboratório de Inovações Tecnológicas (LIT)**.
