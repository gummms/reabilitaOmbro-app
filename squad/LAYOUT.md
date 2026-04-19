# REABILITA OMBRO: LAYOUT STRATEGIES

This document defines the exact spatial and structural layout strategies for the Reabilita Ombro application. It serves as the definitive blueprint for the frontend implementation.

## 1. UX Heuristics Review

Before defining the layout, a rapid UX analysis based on Nielsen's Heuristics was conducted on the architecture:
- **User Control and Freedom**: All views (except Login and Home) must implement an `AppBar` with `automaticallyImplyLeading: true` to provide a clear 'Back' arrow, enabling easy navigation recovery.
- **Visibility of System Status**: `ExerciseView` will feature a dynamic header or progress indicator showing the current exercise step (e.g., "Exercício 1 de 3").
- **Consistency and Standards**: The `componentes_padrao` library enforces consistency. All spacing will strictly utilize an 8-point grid strategy to maintain a predictable visual rhythm.

## 2. Layout Blueprints

### Global Constraints
- **Root Element**: All screens will return a `Scaffold`.
- **Background Color**: `Scaffold` background set to `MY_WHITE`.
- **Safe Area**: All body content must be wrapped in a `SafeArea`.
- **Standard Padding**: `EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0)` or `EdgeInsets.all(24.0)` (strictly using the 8-point grid).

---

### 2.1 LoginView
**Objective**: Center the login form and primary action on the screen, reacting appropriately to keyboard focus.

- **Root Widget**: `Scaffold` (No AppBar).
- **Body Wrapper**: `SafeArea` -> `Padding(EdgeInsets.symmetric(horizontal: 24.0))`.
- **Main Axis Structure**: `Center` -> `SingleChildScrollView` -> `Column`.
- **Alignment directivies**: `MainAxisAlignment.center`, `CrossAxisAlignment.stretch`.
- **Widget Flow**:
  1. `Text` ("Reabilita Ombro", `H1` centered).
  2. `SizedBox(height: 48.0)`.
  3. `SimpleTextField` (NOME).
  4. `SizedBox(height: 16.0)`.
  5. `SimpleTextField` (CPF, `isCPF: true`).
  6. `SizedBox(height: 32.0)`.
  7. `SimpleButton` (ENTRAR).

---

### 2.2 HomeView
**Objective**: Display the user greeting and the scrollable list of available phases.

- **Root Widget**: `Scaffold` (With standard `AppBar`, title: "Teste", `automaticallyImplyLeading: false`).
- **Body Wrapper**: `SafeArea` -> `Padding(EdgeInsets.all(24.0))`.
- **Main Axis Structure**: `Column`.
- **Alignment directives**: `MainAxisAlignment.start`, `CrossAxisAlignment.start`.
- **Widget Flow**:
  1. `Text` ("Olá [Nome]", `H2`).
  2. `SizedBox(height: 8.0)`.
  3. `Text` ("Escolha a Fase", `BODY`).
  4. `SizedBox(height: 24.0)`.
  5. `Expanded` -> `ListView.separated`.
     - *Separator*: `SizedBox(height: 16.0)`.
     - *Items*: `HomeButton` (mapped for Fase 1, Fase 2, Fase 3).

---

### 2.3 PhaseDetailView
**Objective**: List the specific exercises for the selected phase.

- **Root Widget**: `Scaffold` (With standard `AppBar`, title: dynamic phase name, `automaticallyImplyLeading: true`).
- **Body Wrapper**: `SafeArea` -> `Padding(EdgeInsets.all(24.0))`.
- **Main Axis Structure**: `Column`.
- **Alignment directives**: `MainAxisAlignment.start`, `CrossAxisAlignment.stretch`.
- **Widget Flow**:
  1. `Text` ("Escolha o exercicio", `H2`).
  2. `SizedBox(height: 24.0)`.
  3. `Expanded` -> `ListView.separated`.
     - *Separator*: `SizedBox(height: 16.0)`.
     - *Items*: `SimpleListContainerTile` (Title: Exercício N).

---

### 2.4 ExerciseView
**Objective**: Display the unified exercise media, title, timer, and logical progression button.

- **Root Widget**: `Scaffold` (With standard `AppBar`, title: "Teste", `automaticallyImplyLeading: true`).
- **Body Wrapper**: `SafeArea` -> `Padding(EdgeInsets.all(24.0))`.
- **Main Axis Structure**: `Column`.
- **Alignment directives**: `MainAxisAlignment.spaceBetween`, `CrossAxisAlignment.stretch`.
- **Widget Flow**:
  1. **Top Section** (`Column`, `CrossAxisAlignment.center`):
     - `Text` ("Exercício [N]", `H1`).
     - `SizedBox(height: 24.0)`.
     - Content Container (`Container`, constrained height e.g., 240.0, rounded corners for video/image).
     - `SizedBox(height: 32.0)`.
     - Timer / Progress Tracking Element (Placeholder).
  2. **Spacer** (`Expanded` or `Spacer` to push button down).
  3. **Bottom Section**:
     - `SimpleButton` ("concluido").

---

### 2.5 CompletionView
**Objective**: Final success feedback after finishing all exercises in a phase.

- **Root Widget**: `Scaffold` (With standard `AppBar`, title: "Teste", `automaticallyImplyLeading: true`).
- **Body Wrapper**: `SafeArea` -> `Padding(EdgeInsets.symmetric(horizontal: 24.0))`.
- **Main Axis Structure**: `Center` -> `Column`.
- **Alignment directives**: `MainAxisAlignment.center`, `CrossAxisAlignment.stretch`.
- **Widget Flow**:
  1. `Icon` or Graphic (e.g., Check circle).
  2. `SizedBox(height: 24.0)`.
  3. `Text` ("Parabens ! Exercícios Hoje concluido !", `H1`, `textAlign: TextAlign.center`).
  4. `SizedBox(height: 48.0)`.
  5. `SimpleButton` ("Voltar ao Início").
