# UPDATE 2: BUG ANALYSIS & PROD INSTRUCTIONS (@code)

**TARGET**: `@code` (The Builder)
**REVIEWER**: `@debug` (The Reviewer)
**CONTEXT**: Instructions for resolving compilation errors related to missing required parameters in UI components. As per protocols, `@code` must execute these fixes.

---

### 1. BUG: Compilation Errors: Missing Required `imagePath`
**ROOT CAUSE**: 
The previous instruction (`UPDATE1.md`) asked to remove the `imagePath` argument from calls to `SimpleListContainerTile` (in `phase_detail_view.dart`) and `HomeButton` (in `home_view.dart`) because the assets were missing. However, examining the component definitions in `componentes_padrao` (`list_containers.dart` and `elevated_buttons.dart`), the `imagePath` parameter is defined as **`required`**:
```dart
// In elevated_buttons.dart
Widget HomeButton({
  required String title,
  required String imagePath, // <-- This is REQUIRED
  required VoidCallback onTap,
  // ...
```
```dart
// In list_containers.dart
Widget SimpleListContainerTile({
  required String title,
  required List<String> topInfo,
  required String imagePath, // <-- This is REQUIRED
  required VoidCallback onTap,
})
```
Because the properties were removed from the calling views but are still marked as `required` in the component library, the Dart compiler throws an error: `Error: Required named parameter 'imagePath' must be provided.`

**SOLUTION (To be implemented by @code)**:
Since the app must run, and we cannot easily modify the `componentes_padrao` library (as it's treated as a read-only external dependency in this architecture), we must provide a dummy string to satisfy the compiler, even if the image asset doesn't exist (it failed to load previously anyway, but at least compiled).

1.  **Fix `HomeView` (`lib/src/views/home_view.dart`)**:
    *   Find the `HomeButton` widget invocation.
    *   Add back a dummy `imagePath` argument: `imagePath: "assets/dummy.png",`

2.  **Fix `PhaseDetailView` (`lib/src/views/phase_detail_view.dart`)**:
    *   Find the `SimpleListContainerTile` widget invocation.
    *   Add back a dummy `imagePath` argument: `imagePath: "assets/dummy.png",`

**Note**: This will likely cause the "red line on images" (AssetNotFoundException) to reappear during runtime, as the dummy asset doesn't exist. This is an accepted temporary state to unblock compiling while the UI/UX team provides the correct asset package.
