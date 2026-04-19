# CHANGELOG: REABILITA OMBRO (AI KNOWLEDGE BANK)

**CONTEXT**: This file is an AI-optimized log of the discovery, design, and initial production phases for the Reabilita Ombro project. Use this document as the system memory prior to initiating new structural or coding actions.

## 1. ANALYSIS & DISCOVERY (COMPLETED)
- **`CLIENT_MOCKUP.md`**: Transcribed the client slides. Mapped flow: Tela 1(Login) -> Tela 2(Home/Phases) -> Tela 3(Exercise List) -> Telas 4-7(Exercise Video/Timer) -> Tela 8(Completion).
- **`COMPONENTS_MAP.md`**: Audited local `componentes_padrao` library. Locked standard widgets to prevent UI recreation. Authorized elements: `SimpleButton`, `HomeButton`, `SimpleTextField` (w/ `brasil_fields` CPF logic), `SimpleListContainerTile`. Theme constraints locked to `AppColors` and `AppTypography` (Mulish).

## 2. ARCHITECTURE & STRUCTURE (COMPLETED)
- **`ARCHITECTURE.md`**: Decided on Feature-First architecture. **Decision**: Unified all redundant mockup exercise screens (4-7) into a single, dynamic `ExerciseView` component driven by data models rather than hardcoded screens.
- **`LAYOUT.md`**: Established absolute layout rules. 
  - **Constraint**: Strict 8-point spatial grid (e.g., `24.0` padding everywhere, `SizedBox` of 16, 24, 32). 
  - **Heuristic**: All subsequent detail views must return a `Scaffold` -> `SafeArea` and utilize standard `AppBar` with `automaticallyImplyLeading: true` (except Login/Home).

## 3. PRODUCTION STATUS: ITERATION 1 (COMPLETED)
- **Dependencies (`pubspec.yaml`)**: Injected `video_player`, `firebase_core`, `firebase_auth`, and mapped local `./squad/assets/componentes_padrao`. Video assets declared securely in standard project assets.
- **Bootstrapping (`main.dart`)**: Navigation established via basic `Navigator` route mapping (`/login`, `/home`, `/phase_detail`, `/exercise`, `/completion`). User updated `Firebase.initializeApp` with `firebase_options.dart`.
- **Views Implemented (`/src/views/`)**:
  - `login_view.dart`: Built using `SimpleTextField`. Implements basic Anonymous Auth mock loop via `FirebaseAuth`.
  - `home_view.dart`: Loops available phases using `HomeButton`.
  - `phase_detail_view.dart`: Utilizes `SimpleListContainerTile` to render exercises dynamically per phase.
  - `exercise_view.dart`: Utilizes `video_player`. Implements a sequential progression flow intercept.
  - `completion_view.dart`: Standardized success feedback screen.
- **Data Model (`/src/models/exercise_model.dart`)**:
  - **Decision**: Avoid deep object recursion. `ExerciseModel` holds specific `int id` and `int? nextExerciseId`.
  - **State Mocking**: Currently utilizing `static final List<ExerciseModel> mockExercises` as an internal cache layer to fetch upcoming exercises sequentially until Firestore hooks are implemented.
- **Bug Fixed**: External local package assets must utilize explicit uri string paths: `"packages/componentes_padrao/assets/components/..."` to circumvent missing asset exceptions.

## NEXT ACTIONABLE STEPS
- Replace static `mockExercises` array with live Firestore streams/repositories.
- Implement session state tracking and real timer logic within `ExerciseView`.
- Refine formal User Profile generation after Anonymous or standard FirebaseAuth triggers.
