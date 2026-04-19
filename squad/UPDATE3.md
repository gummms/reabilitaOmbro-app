# UPDATE 3: MIGRATING VIDEOS TO FIREBASE STORAGE (@code)

**TARGET**: `@code` (The Builder)
**REVIEWER**: `@debug` (The Reviewer)
**CONTEXT**: We are moving from local files to a Firebase Storage bucket to improve the application footprint. Previous video assets located at `assets/videos` will now be fetched from Firebase Storage.

**Firebase Storage URL**: `gs://reabilita-ombro.firebasestorage.app`

---

### 1. DEPENDENCIES (`pubspec.yaml`)
**ACTION**: Add Firebase Storage to properties and explicitly remove local video assets bundle logic.
1. Add `firebase_storage: ^12.0.0` (or leave it empty/compatible with existing `firebase_core`) under the dependencies block.
2. Under the `flutter:` -> `assets:` block, **remove** the entries for `assets/videos/fase 1/`, `assets/videos/fase 2/`, and `assets/videos/fase 3/`.

### 2. MODEL PREPARATION (`lib/src/models/exercise_model.dart`)
**ACTION**: Update the `videoPath` for all mock exercises to use the Firebase Storage URI format instead of local asset paths.
- Replace the `.videoPath` prefix `assets/videos/` with `gs://reabilita-ombro.firebasestorage.app/videos/`.

Example transformation:
```dart
videoPath: 'assets/videos/fase 1/1.1PENDULAR.MOV'
// becomes
videoPath: 'gs://reabilita-ombro.firebasestorage.app/videos/fase 1/1.1PENDULAR.MOV'
```
*(Apply to all 11 defined exercises)*.

### 3. VIDEO RENDERER UPDATES (`lib/src/views/exercise_view.dart`)
**ACTION**: Replace standard local asset VideoPlayer initialization with an async Firebase URL fetch flow.

1. **Imports**: Make sure you import Firebase Storage:
   ```dart
   import 'package:firebase_storage/firebase_storage.dart';
   ```

2. **Refactor Initialization**:
   Replace the previous `VideoPlayerController.asset` allocation in `initState` with an asynchronous function that fetches the HTTP download URL first:
   ```dart
   @override
   void initState() {
     super.initState();
     _initializeFirebaseVideo();
   }

   Future<void> _initializeFirebaseVideo() async {
     try {
       // 1. Resolve Firebase gs:// URL to HTTP download URL
       final storageRef = FirebaseStorage.instance.refFromURL(widget.exercise.videoPath);
       final downloadUrl = await storageRef.getDownloadURL();

       // 2. Load the network URL
       _controller = VideoPlayerController.networkUrl(Uri.parse(downloadUrl))
         ..initialize().then((_) {
           if (mounted) {
             setState(() {}); 
             _controller.play(); 
             _controller.setLooping(true);
           }
         });
     } catch (error) {
       debugPrint('Error loading video from Firebase: $error');
     }
   }
   ```
*(Adding the `if (mounted)` check is recommended since fetching the URL takes network time).*
