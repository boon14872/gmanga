# Manga Reader App - Flutter

This project is a sample implementation of a modern manga reader application,
built following Clean Architecture principles and powered by Riverpod for state management.

## Architecture

The project follows a **Feature-based Clean Architecture**:

-   **`lib/core`**: Contains app-wide logic like Navigation (`GoRouter`) and Theming (`Material 3`).
-   **`lib/features`**: Each feature of the app (e.g., `browse`) has its own folder containing its `data`, `domain`, and `presentation` layers.
    -   **`domain`**: Contains the core business logic, models (entities), and repository interfaces. It has no dependencies on other layers.
    -   **`data`**: Implements the repositories defined in the domain layer. This is where API calls and database logic would reside. In this example, it contains a `MockMangaRepository` that simulates fetching data from a JavaScript extension.
    -   **`presentation`**: Contains the UI (Screens/Widgets) and State Management logic (`Riverpod` Providers). It depends on the `domain` layer.
-   **`lib/shared`**: Contains widgets or utilities that can be used across multiple features.

## Extension System (Concept)

The folder `extensions/` contains `example_source.js`, which serves as a blueprint for our extension system.

In a real-world application:
1.  The app would download these `.js` files from a user-provided repository URL.
2.  The `MangaRepository` implementation (in the `data` layer) would use a library like `flutter_js` to load and run this JavaScript code inside a background **Isolate**.
3.  The Dart code would call specific functions defined in the JS file (e.g., `source.getPopular(1)`).
4.  The JS code would perform web scraping and return the results as a `JSON String`.
5.  The Dart repository would parse this JSON into Dart objects (`Manga`, `Chapter`) and pass them up to the presentation layer.

This project **mocks** this behavior in `MockMangaRepository` to make the UI fully functional and demonstrate the data flow.

## How to Run

1.  Ensure you have the Flutter SDK installed.
2.  Clone the repository.
3.  Run `flutter pub get`.
4.  Run `flutter pub run build_runner watch --delete-conflicting-outputs` in your terminal and leave it running. This will automatically generate the necessary files for Riverpod.
5.  Run the app on an emulator or a physical device using `flutter run`.