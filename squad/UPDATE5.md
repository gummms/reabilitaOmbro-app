# UPDATE 5: RESPONSIVENESS, VIDEO CONTROLS & UI ENHANCEMENTS (@code)

**TARGET**: `@code` (The Builder)
**REVIEWER**: `@debug` (The Reviewer)
**CONTEXT**: Addressing several UI bugs regarding video layout overflow, absence of playback controls, hardcoded dimension responsiveness, and finally resolving the leftover "red error frame" caused by missing assets in the components library.

---

### 1 & 3: FIXING OVERFLOW AND HARDCODED RESIZING
The `ExerciseView`'s internal `Column` places widgets linearly. Because the `AspectRatio` forces width, it grows too tall for standard mobile vertical dimensions causing overflow.
**ACTION**: In `lib/src/views/exercise_view.dart`, wrap the `AspectRatio` node inside an `Expanded` widget to force the UI to respect the remaining available screen real estate without overflowing.
*Example structural refactor:*
```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Text(widget.exercise.title, style: H1(textColor: MY_BLACK)),
    const SizedBox(height: 24.0),
    Expanded( // Constrains height automatically 
      child: Center(
        child: AspectRatio(
          aspectRatio: 9 / 16,
          // ... (ClipRRect -> ColoredBox, etc)
        )
      )
    ),
    const SizedBox(height: 32.0),
    Text("00:00 / 02:00", style: BODY(textColor: MY_GREY)),
  ],
)
```

### 2: ADDING BASIC VIDEO CONTROLS
The user must be able to at least pause and play the video by tapping the screen.
**ACTION**: In `lib/src/views/exercise_view.dart`, wrap the `VideoPlayer` element with responsive interactive layers:
1.  Wrap the actual `FittedBox` or `VideoPlayer` in a `GestureDetector` that toggles the play state:
    `onTap: () => setState(() { _controller!.value.isPlaying ? _controller!.pause() : _controller!.play(); })`
2.  Change the rendering layer to overlay a Play Button icon when paused using a `Stack`.
    ```dart
    Stack(
      alignment: Alignment.center,
      children: [
        VideoPlayer(_controller!),
        if (!_controller!.value.isPlaying)
          const IgnorePointer(
            child: Icon(Icons.play_circle_fill, size: 64, color: Colors.white70),
          ),
      ]
    )
    ```
    *Be sure to also attach a UI state listener `_controller!.addListener(() { if (mounted) setState(() {}); });` inside your init initialization so the icons hide/show automatically on play.*

### 4: FIXING ASSET ERROR (RED SCREEN) IN BUTTONS
The "red line with strange characters" is Flutter crashing when calling `Image.asset("assets/dummy.png")` — a workaround hack implemented in UPDATE 2. We now need a permanent proper fix.
**SOLUTION**: We authorize a patch to the readonly library `componentes_padrao` to suppress the crash instead.
**ACTION**:
Open `squad/assets/componentes_padrao/lib/components/buttons/elevated_buttons.dart` (and `list_containers.dart` if applicable).
For every occurrence of `Image.asset(imagePath, ...)`, attach an `errorBuilder` argument that handles missing files gracefully by returning an empty widget:
```dart
Image.asset(
  imagePath,
  width: 120, // (retain existing width)
  errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
),
```
This forces the UI framework to draw a clean empty space instead of a red exception frame if the `imagePath` targets a missing local asset.
