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
├── env/                   # Env files
├── src/
│   ├── core/
│   │   ├── common/        # Shared widgets & components
│   │   ├── db/            # Database layer
│   │   ├── error/         # Error handling
│   │   ├── extensions/    # Extension methods
│   │   ├── resources/     # Assets, strings, colors
│   │   ├── routing/       # GoRouter setup
│   │   ├── theme/         # App theming
│   │   └── utils/         # Helper methods
│   ├── features/          # Feature-based structure
│   ├── app.dart           # App widget
├── main.dart              # Entry point
└── test_screen.dart       # Sample screen for testing very specific cases
```

---

## 🚀 Getting Started

1. **Clone the repo**
   ```bash
   git clone https://github.com/your-username/flutter_boilerplate.git
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

---

## ✅ What to Do After Cloning

1. **Check Your Environment**  
   Run the following command to ensure your Flutter setup is complete and compatible:  
   ```bash
   flutter doctor
   ```

2. **Configure Environment Variables**  
   Create and fill the `.env` file located at `lib/env/.env` with the required keys. These are required for the app to run properly and access external services:

   - `SUPABASE_*` – Supabase project credentials  
   - `SENTRY_DSN` – Sentry connection string for error tracking  
   - `POWERSYNC_*` – PowerSync-related credentials (if applicable)