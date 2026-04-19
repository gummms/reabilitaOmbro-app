# UPDATE 1: BUG ANALYSIS & PROD INSTRUCTIONS (@code)

**TARGET**: `@code` (The Builder)
**REVIEWER**: `@debug` (The Reviewer)
**CONTEXT**: Instructions for resolving the video playback issues and the "red line on images" fallback bugs. As per protocols, `@code` must execute these fixes.

---

### 1. BUG: Videos aren't loading
**ROOT CAUSE**: 
The `ExerciseModel.mockExercises` array points to local video files like `assets/videos/fase 1/ex1.mp4`. However, these `.mp4` files **do not exist** physically on the disk (the `fase 1/2/3` directories are completely empty). Because the files are missing, `VideoPlayerController.asset()` fails to initialize, preventing playback. Additionally, declaring empty directories in the `pubspec.yaml` (`assets:` section) triggers build evaluation errors in Flutter.

**SOLUTION (To be implemented by @code)**:
1.  **Refactor `ExerciseModel`**: Change the mocked data to use remote placeholder URLs instead of missing local paths.
    *   Rename the property: `final String localVideoPath` -> `final String videoUrl`.
    *   Update `mockExercises` to populate `videoUrl` with a reliable public `.mp4` sample (e.g., `"https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4"`).
2.  **Refactor `ExerciseView`**: 
    *   Update the `VideoPlayerController` initialization to use `VideoPlayerController.networkUrl(Uri.parse(widget.exercise.videoUrl))` instead of `.asset()`.
3.  **Clean `pubspec.yaml`**: Remove the trailing `/` bindings for the empty video folders in the `assets:` array (e.g., `- ./assets/videos/fase 1/`) to prevent the "unable to find directory entry" compilation errors until local videos are actually placed there.

---

### 2. BUG: "Red line on images" (AssetNotFoundException)
**ROOT CAUSE**: 
The "red line / yellow tape" error indicates an `Image` or `AssetImage` failed to load in Flutter.
In both `home_view.dart` and `phase_detail_view.dart`, the code invokes components (`HomeButton` and `SimpleListContainerTile`) passing explicitly: 
`imagePath: "packages/componentes_padrao/assets/components/consultas.png"`.
However, auditing the sub-module `./squad/assets/componentes_padrao/` reveals that its internal `assets/` folder is **completely missing from the repository**. Because the `.png` files do not exist inside the package on disk, Flutter renders the red error box when attempting to load them.

**SOLUTION (To be implemented by @code)**:
1.  **Fix Asset Loading in Views**: Since the original design system `.png` assets were not pushed to the repository, you cannot use them. 
    *   In `home_view.dart`, remove the `imagePath` property from `HomeButton`, or replace it with a valid local icon/asset you create. (If `HomeButton` forces an image, change it to a `SimpleButton` temporarily or use a fallback `Icon`).
    *   In `phase_detail_view.dart`, do the same for `SimpleListContainerTile` (removing the `imagePath: "packages/.../Frame128.png"` argument) to remove the broken asset calls.
2.  **Clean `pubspec.yaml`**: Remove `- ./squad/assets/componentes_padrao/` from the main `assets:` array. Local package assets are automatically imported if they exist; manually overriding them in the primary pubspec to a non-existent directory causes path resolution errors.

---

### 3. AUDIT: Compliance with `componentes_padrao/README.md`
**FINDINGS**: 
The application correctly imports and complies with the design system specifications.
*   **Typography & Colors**: Views are successfully utilizing `APP_BAR()`, `H1()`, `H2()`, `BODY()`, `MY_WHITE`, `MY_BLACK`, and `MY_GREY`.
*   **Widgets**: Standard interfaces (like `HomeButton`, `SimpleButton`, `SimpleListContainerTile`) are actively being used instead of recreating them from scratch.
*   **Dependencies**: Required libraries (`google_fonts`, `brasil_fields`, `email_validator`) are mapped in the pubspecs.

**ONGOING REQUIREMENT (To be implemented by @code)**:
Continue using the imported components exclusively. When building future input forms or profile edit screens, strictly use `SimpleTextField`, `ObscureTextField`, and the respective Date/Time variants defined in the library, avoiding raw `TextFormField` widgets.
