# Flutter Boilerplate 🚀

A clean and scalable Flutter boilerplate using [Riverpod](https://riverpod.dev) for state management. This template is designed to help you quickly start new Flutter projects with a solid architecture and modern best practices.

---

## 🛠️ Tech Stack

- **Flutter**
- **Riverpod** for state management
- **GoRouter** for navigation
- **Custom theme setup**

---

## 📁 Folder Structure

```
lib/
├── env/                         # Env files
├── src/
│   ├── core/
│   │   ├── common/              # Shared widgets & components
│   │   ├── db/                  # Database layer
│   │   ├── error/               # Error handling
│   │   ├── extensions/          # Extension methods
│   │   ├── resources/           # Assets, strings, colors
│   │   ├── routing/             # GoRouter setup
│   │   ├── theme/               # App theming
│   │   └── utils/               # Helper methods
│   ├── features/                # Feature-based structure
│   │   └── [feature]/           # Name of desired feature
│   │       ├── service/         # Handles external services (APIs, Firebase, storage, etc.)
│   │       ├── data/            # Implements repositories, maps data between DTOs and domain models
│   │       ├── domain/          # Contains core business logic: entities, use cases, and repository contracts
│   │       └── presentation/    # UI layer: screens, widgets, controllers and state management
│   └── app.dart                 # App widget
├── main.dart                    # Entry point
└── test_screen.dart             # Sample screen for testing very specific cases
```

---

## 🚀 Getting Started

1. **Clone the repo**
   This repository is a **template** – you can use it directly or you can clone it:
   ```bash
   git clone https://github.com/your-username/flutter_boilerplate.git
   ```

2. **Check Your Environment**  
   Run the following command to ensure your Flutter setup is complete and compatible:  
   ```bash
   flutter doctor
   ```
3. **Configure Environment Variables**  
   Create `.env` file from file located at `lib/env/.env.example` and fill the `.env` with the required keys. These are required for the app to run properly and access external services:

   - `SUPABASE_*` – Supabase project credentials  
   - `SENTRY_DSN` – Sentry connection string for error tracking  
   - `POWERSYNC_*` – PowerSync-related credentials (if applicable)

4. **Generate Code with build_runner**
   Run the following command to generate necessary code for Riverpod and other code generation tools:
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

5. **Run the app**
   ```bash
   flutter run
   ```
