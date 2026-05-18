# CHANGELOG: REABILITA OMBRO (AI KNOWLEDGE BANK)

**CONTEXT**: This file is an AI-optimized log of the discovery, design, and production phases for the Reabilita Ombro project. Use this document as the system memory prior to initiating new structural or coding actions.

## 1. ANALYSIS & DISCOVERY (COMPLETED)
- **`CLIENT_MOCKUP.md`**: Transcribed the client slides. Mapped flow: Tela 1(Login) -> Tela 2(Home/Phases) -> Tela 3(Exercise List) -> Telas 4-7(Exercise Video/Timer) -> Tela 8(Completion).
- **`COMPONENTS_MAP.md`**: Audited local `componentes_padrao` library. Locked standard widgets to prevent UI recreation. Authorized elements: `SimpleButton`, `HomeButton`, `SimpleTextField` (w/ `brasil_fields` CPF logic), `SimpleListContainerTile`. Theme constraints locked to `AppColors` and `AppTypography` (Mulish).

## 2. ARCHITECTURE & STRUCTURE (COMPLETED)
- **`ARCHITECTURE.md`**: Decided on Feature-First architecture. **Decision**: Unified all redundant mockup exercise screens (4-7) into a single, dynamic `ExerciseView` component driven by data models rather than hardcoded screens.
- **`LAYOUT.md`**: Established absolute layout rules. 
  - **Constraint**: Strict 8-point spatial grid (e.g., `24.0` padding everywhere, `SizedBox` of 16, 24, 32). 
  - **Heuristic**: All subsequent detail views must return a `Scaffold` -> `SafeArea` and utilize standard `AppBar` with `automaticallyImplyLeading: true` (except Login/Home).

## 3. PRODUCTION STATUS: ITERATION 1 (COMPLETED — SUPERSEDED)
> **NOTE**: Most artifacts from Iteration 1 have been replaced or deleted by Iteration 2. This section remains for historical context only. `home_view.dart`, `exercise_model.dart`, and the mock data layer are all deleted. The video_player, firebase_storage, and file_picker dependencies are removed.

- **Views Implemented**: `login_view.dart`, `home_view.dart` (deleted), `phase_detail_view.dart`, `exercise_view.dart` (rewritten), `completion_view.dart`.
- **Data Model**: `ExerciseModel` with static `mockExercises` array (deleted — replaced by `LevelModel` + Firestore).

## 4. PRODUCTION STATUS: ITERATION 2 — PLAN.md UPDATEs 6–12 (COMPLETED 2026-05-15)

### 4.1. PLANNING PHASE

**`PLAN.md` authored** — 9 sequential UPDATEs (UPDATE 6 through UPDATE 12, including 10.5 and 10.6) decomposing the full app overhaul. Each UPDATE was designed as an isolated, self-contained unit with a STOP-AND-TEST gate at the end.

The plan was revised twice during execution:
1. **UPDATE 10.5 inserted**: Originally the plan went straight from UPDATE 10 to 11. When the decision to migrate from Firebase Storage to YouTube was made, UPDATE 10.5 was inserted to handle the dependency swap and view rewrites.
2. **UPDATE 10.6 inserted**: During testing of UPDATE 10.5, the user identified a critical UX flaw — levels were global (shared by all patients). UPDATE 10.6 was authored mid-session to migrate to per-patient level subcollections.

### 4.2. UPDATES 6–10: FOUNDATION (COMPLETED IN PRIOR SESSION)

These were completed before this session. Summary:
- **UPDATE 6**: Auth system — `AuthService`, `LoginView` rewrite (email/password, pt-BR errors), `PatientRegisterView` (6-field form), `AuthGate` (role-based routing: patient vs doctor).
- **UPDATE 7**: Data models — `UserModel` (with patient-specific fields), `LevelModel` (with `ExerciseItem` list), `SurveyModel`.
- **UPDATE 8**: `DatabaseService` — Full Firestore CRUD for users, levels, surveys. Manual Firestore setup (production rules, user doc with `role: doctor`).
- **UPDATE 9**: Patient home (`PatientHomeView`) — Streams levels + user data, status-aware level cards (blue=available, green=completed, grey=locked/waiting).
- **UPDATE 10**: Doctor dashboard — `DoctorHomeView` (two tabs: Pacientes + Níveis), `PatientDetailView` (dual-stream: patient metadata + level progress, "Liberar" button, survey access), `SurveyResultsView` (color-coded pain dot gauge).

### 4.3. UPDATE 10.5: YOUTUBE VIDEO MIGRATION (COMPLETED THIS SESSION)

**Context**: The original plan used Firebase Storage for video hosting with `video_player` for playback. Google Drive was considered as an alternative but rejected due to: (1) API credential complexity, (2) virus-scan interstitials on files >100MB, (3) rate limiting, (4) no adaptive streaming. YouTube was chosen for free CDN-backed streaming, adaptive bitrate, and a simple URL-based workflow.

**Execution steps (3 sub-steps)**:

1. **10.5.1 — Dependency swap (`pubspec.yaml`)**:
   - Removed: `firebase_storage`, `file_picker`, `video_player` (and 14 transitive deps).
   - Added: `youtube_player_flutter: ^9.1.3` (and 8 transitive deps including `flutter_inappwebview`).
   
2. **10.5.2 — `ExerciseView` rewrite**:
   - Replaced `VideoPlayerController` + Firebase Storage URL resolution with `YoutubePlayerController`.
   - Video ID extracted via `YoutubePlayer.convertUrlToId()`.
   - Wrapped `Scaffold` in `YoutubePlayerBuilder` for proper fullscreen support.
   - Added pause-on-exit-dialog behavior.
   - Fixed `_confirmExit` to use `popUntil(isFirst)` instead of the removed `/patient_home` named route.

3. **10.5.3 — `LevelManagerView` rewrite**:
   - Removed `FilePicker`, `FirebaseStorage`, `dart:io` entirely.
   - `_ExerciseEntry` now has `videoUrlController` instead of upload progress/filename fields.
   - Added YouTube URL text field with **live thumbnail preview** (`mqdefault.jpg`) that appears as the doctor types.
   - Validation via `convertUrlToId()` — returns null for invalid URLs, shows SnackBar.

**Bug fixed during analysis**: `SimpleTextField.onChanged` signature is `String? Function(String?)` (returns the value, not void). Fixed closure to `(val) { onUrlChanged(); return val; }`. Also fixed `___` parameter names (Dart lint: unnecessary underscores).

### 4.4. UPDATE 10.6: PER-PATIENT LEVEL ASSIGNMENT (COMPLETED THIS SESSION)

**Context**: During testing, the user discovered that all levels were globally shared — every patient saw the same exercises. This violated the clinical requirement for individualized rehabilitation protocols.

**Architectural decision**: Replace the global `levels` top-level collection with per-patient subcollections at `users/{patientUid}/levels/{levelId}`. Merge `LevelProgress` (status/completedAt) directly into `LevelModel` to eliminate cross-referencing between two data sources.

**Execution steps (8 sub-steps)**:

1. **10.6.1 — `LevelModel` update**: Added `String status` (default `'locked'`) and `DateTime? completedAt`. Updated `fromFirestore`, `toFirestore`, `copyWith`.

2. **10.6.2 — `UserModel` cleanup**: Deleted the `LevelProgress` class entirely. Removed `Map<String, LevelProgress>? levels` field. Removed all levels-related code from `fromFirestore`/`toFirestore`.

3. **10.6.3 — `DatabaseService` major rewrite**:
   - Removed: `_levels` collection reference, `createLevel`, `updateLevel`, `deleteLevel`, `_reorderLevels`, `reorderLevels`, `getLevelsStream`, `getLevels`, `getNewLevelId`, `updateLevelStatus` (11 members total).
   - Added: `_patientLevels(patientUid)` helper, `createPatientLevel`, `updatePatientLevel`, `deletePatientLevel`, `_reorderPatientLevels` (also updates title on reorder), `getPatientLevelsStream`, `updatePatientLevelStatus` (queries by order field, then updates).

4. **10.6.4 — `DoctorHomeView` simplification**: Removed `DefaultTabController`, `TabBar`, `TabBarView`, `_NiveisTab`, `_LevelAdminCard`, `_NiveisFab`. Converted to a single-view patient list. Levels are now managed per-patient from `PatientDetailView`.

5. **10.6.5 — `PatientDetailView` rewrite**: Replaced dual-StreamBuilder (UserModel + global levels) with single `StreamBuilder<List<LevelModel>>` on `getPatientLevelsStream()`. Added `FloatingActionButton.extended` ("+ Novo nível") for creating levels. Added edit (pencil icon → LevelManagerView) and delete (trash icon → confirmation dialog) per card. "Liberar" button now calls `updatePatientLevelStatus`.

6. **10.6.6 — `LevelManagerView` update**: Added `String patientUid` to `LevelManagerArgs` (required). `_save()` calls `createPatientLevel`/`updatePatientLevel`. First level (nextOrder == 1) auto-set to `status: 'available'`; subsequent levels start `'locked'`.

7. **10.6.7 — `PatientHomeView` rewrite**: Replaced dual-StreamBuilder with `getPatientLevelsStream(uid)`. Level cards now read `level.status` and `level.completedAt` directly from the `LevelModel`. No more `patient.levels?[key]?.status` cross-referencing.

8. **10.6.8 — `patient_register_view.dart` cleanup**: Removed `LevelProgress` initialization (`levels: { '1': LevelProgress(status: 'available') }`). New patients start with zero levels — the doctor assigns them.

### 4.5. UPDATE 11: SURVEY VIEW & LEVEL COMPLETION (COMPLETED THIS SESSION)

**Execution steps (3 sub-steps)**:

1. **11.1 — `SurveyView` created** (`lib/src/views/survey_view.dart`):
   - Three pain questions, each with a row of 5 tappable circles.
   - Circles are **color-coded green→red** spectrum (green = no pain, red = severe) with selection animation.
   - Submit button disabled (opacity 0.4) until all 3 answered.
   - On submit: writes `SurveyModel` → marks level `completed` → transitions next level to `waiting` (if exists, using one-shot `stream.first`) → navigates to `/completion`.
   - No back button — `pushReplacement` from exercise prevents returning to mid-exercise state.

2. **11.2 — `CompletionView` fixed**: Changed `pushNamedAndRemoveUntil('/patient_home', ...)` to `popUntil((route) => route.isFirst)`. The `/patient_home` named route never existed — AuthGate at the root handles it declaratively.

3. **11.3 — `main.dart` route wiring**: Activated `SurveyView` import (previously commented out), wired `/survey` case in `onGenerateRoute` (reads `Map<String, dynamic>` args: `patientUid`, `levelOrder`, `levelTitle`).

### 4.6. UPDATE 12: FINAL CLEANUP & VALIDATION (COMPLETED THIS SESSION)

**Execution steps (4 sub-steps)**:

1. **12.1 — Route audit**: All 7 dynamic routes confirmed present and correctly typed in `main.dart`. No changes needed.

2. **12.2 — Dead code removal**:
   - Deleted `lib/src/models/exercise_model.dart` (replaced by `LevelModel` + `ExerciseItem`).
   - Deleted `lib/src/views/home_view.dart` (replaced by `PatientHomeView`).
   - Grep audit confirmed zero references to: `ExerciseModel`, `mockExercises`, `LevelProgress` (class), `getLevelsStream()` (global), `firebase_storage`, `file_picker`, `video_player`.

3. **12.3 — Firestore security rules**: Written to `firestore.rules` at project root. Rules cover:
   - `users/{uid}`: any auth'd user reads; self or doctor writes.
   - `users/{uid}/levels/{levelId}`: patient reads own; doctor reads/writes all.
   - `surveys/{surveyId}`: any auth'd user reads/writes.
   - **Manual step required**: User must paste rules into Firebase Console → Firestore → Rules tab.

4. **12.4 — Build validation**:
   - `flutter analyze lib\` → **No issues found** (1.3s).
   - `flutter build apk --debug` → **✓ Built `app-debug.apk`** (35.9s).

---

## 5. CURRENT ARCHITECTURE SUMMARY (POST-ITERATION 2)

### Firestore Schema
```
users/{uid}
├── uid, email, name, role, createdAt
├── (patient only) dateOfBirth, age, dateOfSurgery, doctorUid
└── levels/{levelId}     ← per-patient subcollection
    ├── order, title, exercises[{title, videoUrl}]
    ├── status ("available"|"completed"|"waiting"|"locked")
    ├── completedAt, createdAt, createdBy

surveys/{surveyId}
├── patientUid, levelOrder
├── painBefore, painDuring, painAfter (1-5)
├── submittedAt
```

### Dependencies (Core)
- `firebase_core`, `firebase_auth`, `cloud_firestore` — Firebase platform
- `youtube_player_flutter: ^9.1.3` — Video playback (replaced firebase_storage + video_player)
- `componentes_padrao` — Local UI component library (path dependency)

### File Manifest
```
lib/
├── main.dart                          — App entry, theme, all 7 routes
├── firebase_options.dart              — Auto-generated Firebase config
└── src/
    ├── models/
    │   ├── level_model.dart           — LevelModel + ExerciseItem (status+completedAt merged)
    │   ├── survey_model.dart          — SurveyModel (1-5 pain scales)
    │   └── user_model.dart            — UserModel (doctor | patient, no levels map)
    ├── services/
    │   ├── auth_service.dart          — FirebaseAuth wrapper, pt-BR error translation
    │   └── database_service.dart      — Firestore CRUD (per-patient level subcollections)
    └── views/
        ├── auth_gate.dart             — Role-based declarative routing
        ├── login_view.dart            — Email/password login
        ├── patient_register_view.dart — 6-field patient registration
        ├── patient_home_view.dart     — Level cards with status coloring
        ├── phase_detail_view.dart     — Exercise list within a level
        ├── exercise_view.dart         — YouTube embedded player
        ├── survey_view.dart           — 3-question pain survey (1-5 circles)
        ├── completion_view.dart       — Post-level congratulations
        └── doctor/
            ├── doctor_home_view.dart      — Patient list (single view, no tabs)
            ├── patient_detail_view.dart   — Per-patient level management + progress
            ├── level_manager_view.dart    — Level editor (YouTube URL + thumbnail)
            └── survey_results_view.dart   — Pain gauge visualization

firestore.rules                        — Security rules (manual deploy to Firebase Console)
```

### Key Design Decisions Log
| Decision | Rationale |
|----------|-----------|
| YouTube over Firebase Storage | Free CDN streaming, adaptive bitrate, no virus-scan interstitials, simple URL workflow |
| YouTube over Google Drive | Drive needs API credentials, rate-limited, no adaptive streaming, interstitials on large files |
| Per-patient subcollection over global levels | Each patient needs unique exercises; doctor assigns individually from PatientDetailView |
| Merged status into LevelModel | Eliminates cross-referencing between UserModel.levels map and global levels collection |
| No tabs on DoctorHomeView | Levels are per-patient; global level tab became meaningless after 10.6 architecture change |
| popUntil(isFirst) for navigation | AuthGate is the declarative root; no named route exists for /patient_home or /doctor_home |
| First level auto-available | When doctor creates the first level (order=1) for a patient, status is 'available'; subsequent levels start 'locked' |

## NEXT ACTIONABLE STEPS
1. **Deploy Firestore rules**: Paste `firestore.rules` into Firebase Console → Firestore → Rules tab and publish. → **✓ Done**
2. **Run integration checklist**: Execute the 14-point checklist in PLAN.md UPDATE 12.4 against a real device. → **✓ Done, but issues were found in step 5.11 (survey submission error), 5.12 (level 1 completed, level 2 waiting) and 5.13 (doctor release level 2).**
3. **Future considerations**: Push notifications when doctor releases a level, patient progress analytics dashboard, export survey data as CSV. → **NOT IMPORTANT FOR NOW.**

---

## 6. PRODUCTION STATUS: ITERATION 3 — PLAN.md UPDATEs 13–14 (COMPLETED 2026-05-18)

### 6.1. UPDATE 13: BUG FIX — SURVEY PERMISSION + UI POLISH (COMPLETED)

**Context**: Integration testing revealed that survey submission crashed with `[cloud_firestore/permission-denied]` — the patient could not mark their own level as completed because `firestore.rules` restricted level subcollection writes to doctors only.

**Execution steps (3 sub-steps)**:

1. **13.1 — Firestore security rules fix** (`firestore.rules`):
   - Added `request.auth.uid == uid` to the levels subcollection write rule, allowing patients to update their own level status (mark as completed, transition next level to waiting).
   - **Manual step**: Updated rules must be pasted into Firebase Console → Firestore → Rules tab and published.

2. **13.2 — ExerciseView layout** (`exercise_view.dart`):
   - Moved exercise title **above** the YouTube player (was below).
   - Wrapped player in `Center()` for proper horizontal centering.

3. **13.3 — Placeholder text color** (`componentes_padrao/.../text_fields.dart`):
   - All 4 light-mode text field widgets (`SimpleTextField`, `ObscureTextField`, `DatePickerTextField`, `TimePickerTextField`) now use dark-gray `#777777` for hint text instead of black — provides proper contrast against the light-blue `#BFDEFF` field background.

### 6.2. UPDATE 14: CONFIRM PASSWORD FIELD (COMPLETED)

**Context**: Registration form lacked password confirmation, risking user typos.

**Execution steps (3 sub-steps)**:

1. **14.1 — Controller + dispose**: Added `_confirmPasswordController` to `_PatientRegisterViewState`.
2. **14.2 — UI widget**: Inserted `ObscureTextField` labeled "CONFIRME SUA SENHA" with hint "Digite sua senha novamente", placed between the primary password field and the register button.
3. **14.3 — Match validation**: Added early-return check in `_handleRegister()` — if `_passwordController.text != _confirmPasswordController.text`, shows error "As senhas não coincidem." and blocks registration.

### 6.3. SECURITY AUDIT (COMPLETED 2026-05-18)

Full codebase audit for sensitive data exposure:

| Check | Status |
|-------|--------|
| `firebase_options.dart` (API keys) | ✅ `.gitignore`d, not tracked by git |
| `google-services.json` | ✅ `.gitignore`d, not present on disk |
| `GoogleService-Info.plist` | ✅ `.gitignore`d |
| Keystores (`.jks`, `.keystore`) | ✅ Covered by root + android `.gitignore` |
| `.env` files | ✅ `.gitignore`d, none exist |
| Hardcoded secrets in `lib/` | ✅ None found |
| Git history leak | ✅ No sensitive files ever committed |

**Verdict**: No changes needed. The `.gitignore` setup from the prior security audit (conversation `f9c7fcd6`) remains comprehensive and correct.
