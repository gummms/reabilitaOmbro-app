# UPDATE 4: FIXING BUILD DIRECTORY ERROR & CLEANUP (@code)

**TARGET**: `@code` (The Builder)
**REVIEWER**: `@debug` (The Reviewer)
**CONTEXT**: The `flutter run` command is breaking with `Error: unable to find directory entry in pubspec.yaml: C:\src\lit\reabilitaOmbro-app\squad\assets\componentes_padrao\assets\`. This happens when a `pubspec.yaml` file declares an `assets:` path, but the folder physically does not exist on disk. Additionally, we need to completely wipe local videos since they moved to Firebase.

---

### 1. DIAGNOSIS & CAUSE
Flutter compiler requires that any directory path listed in the `flutter: -> assets:` block of *any* `pubspec.yaml` module be present on the filesystem. 
- The local package `componentes_padrao` has `- assets/` declared in its `pubspec.yaml`, but no such folder exists.
- The main application `pubspec.yaml` also has `- assets/`, which will crash similarly if you wipe the root `assets` directory.

### 2. LOCAL VIDEOS CLEANUP
It is **100% safe** to delete the local video files.
Since the app's views are now dynamically resolving `gs://...` URIs through the Firebase Storage network (`ExerciseView` + `getDownloadURL()`), keeping local `.MOV` or `.mp4` files inside the project only serves to bloat the git repository and inflate APK/IPA binary sizes uselessly.

**ACTION**: Completely delete the `c:\src\lit\reabilitaOmbro-app\assets\` folder and everything inside it using your shell or file manager tools.

### 3. PUBSPEC REPAIR INSTRUCTIONS

**ACTION 1**: Open `c:\src\lit\reabilitaOmbro-app\squad\assets\componentes_padrao\pubspec.yaml`.
- Under the `flutter:` block, find and comment out (or remove) the `assets:` section to prevent the error.
```yaml
  # To add assets to your application, add an assets section, like this:
  # assets:
  #   - assets/
```

**ACTION 2**: Open the root `c:\src\lit\reabilitaOmbro-app\pubspec.yaml`.
- Do exactly the same thing. Remove the `assets:` directory declaration since the folder will be deleted.
```yaml
  # To add assets to your application, add an assets section, like this:
  # assets:
  #   - assets/
```

*Executing these steps will permanently clear the folder existence assertions and allow the engine to proceed to compile successfully.*

---

### 4. VIDEOPLAYER UI UPDATES (@code)
**CONTEXT**: The current `ExerciseView` uses a hardcoded height of `240.0` for the video container, which does not match the portrait orientation of the new `.mp4` video files.

**ACTION**:
1.  **Refactor `lib/src/views/exercise_view.dart`**:
    *   Remove the fixed `height: 240.0` from the `Container` holding the video.
    *   The videoplayer should have a **default fixed dimension for portrait orientation**. Use a fixed AspectRatio of **9:16** for the container logic.
    *   **CRITICAL**: Do not let the player resize dynamically based on each specific video's metadata (this prevents UI flickering/jumping). Use a consistent layout ratio for all exercises.
    *   Ensure the video fits within the screen bounds comfortably using `BoxConstraints` or by relying on the `Expanded`/`Flexible` parent structure already present in the `Column`.
