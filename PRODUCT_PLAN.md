# Life OS Product Plan

## Current application assessment

This repository is a Flutter mobile application. It now has a Life OS visual prototype, but it is not yet a production personal management system. The app still needs real navigation, data models, local storage, cloud sync, permissions, authentication, Health Connect / Google Fit integration, notifications, reports, and offline summary logic.

## Locked product decisions

- Product language: English only.
- Platform priority: Android first.
- Authentication: no login required for the first release; optional Google login can be added when Firebase sync starts.
- Storage: offline-first local storage plus automatic Firebase sync is required.
- First-version sensitive scope: do not include password vault, ID documents, SMS parsing, or location history.
- Finance: Indian Rupee currency, bank/UPI treated as the same account source, basic reports required, advanced categories/budget rules/tax/GST marked as coming soon.
- Health: manual entry plus Health Connect / Google Fit integration is required, with first-version priority on steps, sleep duration, water intake, weight, exercise/workout, mood, and medicine tracking.
- Prayer: support multiple calculation methods with automatic location, manual location, manual time adjustment, Hanafi/Shafi'i Asr options, timezone/daylight handling, and settings-based changes.
- Business: remove business-management features from the first personal version.
- AI: offline summaries first; OpenAI-powered or configurable AI providers can be added later.
- Design: modern Android-first Material 3 style, blue/indigo primary color, clean cards, dark-mode support later, dashboard priority set by daily use value.
- Logo: custom logo package required before final app branding; no text inside the icon.
- Backend: Firebase is the final backend for auth, database, file storage, synchronization, notifications, user management, and security rules.

## Final architecture decisions

### Logo assets

Create and place these files in the project assets folder before final branding is wired into launch icons and splash screens:

- `app_logo.svg` — master vector logo.
- `app_logo_1024.png` — 1024 x 1024 master PNG.
- `app_logo_512.png` — 512 x 512 PNG.
- `app_logo_192.png` — 192 x 192 PNG.
- `app_logo_180.png` — 180 x 180 PNG.
- `app_logo_96.png` — 96 x 96 PNG.
- `app_logo_72.png` — 72 x 72 PNG.
- `app_logo_48.png` — 48 x 48 PNG.
- `favicon.ico`, `favicon-32.png`, and `favicon-16.png`.
- `splash_logo.png` — 1024 x 1024 transparent PNG.
- `adaptive_foreground.png` — 1024 x 1024 transparent PNG.
- `adaptive_background.png` — 1024 x 1024 solid-background PNG.

Logo guidelines: modern, minimal, rounded, flat, high contrast, recognizable at small sizes, compatible with light and dark mode, and no text inside the icon.

### Firebase backend

Firebase is the final cloud provider and backend. It will be used for optional Google authentication, cloud database, cloud storage, backup and sync, push notifications, user management, security rules, optional analytics, and optional crash reporting. The app must remain offline-first: data is written locally first and synchronized automatically when internet access is available.

### Prayer calculation

The prayer system must not hardcode one method. It should support multiple calculation methods, automatic location-based calculation, manual location selection, manual prayer time adjustment, Hanafi/Shafi'i Asr options, automatic daylight/time-zone handling, and user-controlled method changes from Settings.

### Health metric priority

Primary first-version metrics are steps, sleep duration, water intake, weight, exercise/workout, mood, and medicine tracking. Secondary metrics are heart rate, blood pressure, blood sugar, calories burned, distance walked, active minutes, and BMI.

## Product direction

The target product is a personal Life Operating System: a private Android-first command center for daily planning, habits, goals, health, finance, prayer, notes, documents-lite, learning, reminders, reviews, and offline summaries.

## Recommended update roadmap

### Update 1: App foundation and navigation

Goal: replace the prototype-only screen with a scalable Android-first app shell.

Deliverables:

- Bottom navigation for Dashboard, Planner, Habits, Finance, Health, and More.
- Reusable cards, section headers, empty states, and coming-soon badges.
- English-only labels and consistent Material 3 styling.
- Remove first-version business modules from the main flow.

Next prompt:

```text
Build Update 1 for this Flutter Life OS app. Create an Android-first Material 3 app shell in English only with bottom navigation for Dashboard, Planner, Habits, Finance, Health, and More. Refactor the current single-screen prototype into reusable widgets and data classes. Keep Business, password vault, ID documents, SMS parsing, tax/GST, and location history out of the first version. Add coming-soon badges for future advanced features. Update widget tests for navigation and core section rendering.
```

### Update 2: Local-first data layer

Goal: make the app store real personal data locally before cloud sync.

Deliverables:

- Data models for tasks, habits, goals, finance entries, health entries, prayer records, notes, and reviews.
- Local repository interfaces and in-memory seed data for tests.
- Later-ready abstraction for SQLite/Isar/Hive plus a Firebase sync adapter without locking the UI to one storage engine.

Next prompt:

```text
Build Update 2 for the Flutter Life OS app. Add a local-first data layer with models and repository interfaces for tasks, habits, goals, finance entries in INR, health entries, prayer records, notes, and daily reviews. Use seed/in-memory repositories for now so the UI can read and write sample data without a backend. Keep the architecture ready for SQLite/Isar/Hive plus a Firebase sync adapter and future cloud sync. Add unit tests for the models and repositories.
```

### Update 3: Daily planner, tasks, goals, and habits MVP

Goal: make the app useful every day even before integrations.

Deliverables:

- Daily planner screen with morning routine, work/personal tasks, notes, evening review, and tomorrow planning.
- Task create/complete flow.
- Habit tracker with streak, completion state, reminder placeholder, and missed-day display.
- Goals with deadline, milestones, and progress.

Next prompt:

```text
Build Update 3 for the Flutter Life OS app. Implement the Daily Planner, Tasks, Goals, and Habits MVP using the local repositories from Update 2. Add create, complete, and edit flows where reasonable. Include morning routine, work tasks, personal tasks, notes, evening review, tomorrow planning, habit streaks, missed days, reminders placeholders, goal deadlines, milestones, and progress. Update tests for the main user flows.
```

### Update 4: Finance MVP for INR bank/UPI usage

Goal: track personal money without business/tax complexity.

Deliverables:

- INR income and expense entries.
- Bank/UPI account treated as one account type.
- Basic monthly summary, cash flow, pending bills, and reports.
- Advanced category budgets, tax, GST, credit cards, investments, and loans marked coming soon.

Next prompt:

```text
Build Update 4 for the Flutter Life OS app. Implement a personal Finance MVP using INR. Treat bank and UPI as the same account source. Add income, expense, bills, monthly summary, cash flow, and basic reports. Mark advanced categories, budget rules, tax/GST, investments, loans, and credit cards as coming soon. Do not add business features. Add tests for finance calculations and UI summaries.
```

### Update 5: Prayer module

Goal: support daily spiritual tracking clearly.

Deliverables:

- Five daily prayers completion tracking.
- Prayer calculation settings placeholder.
- Reminder settings placeholder.
- Quran pages/verses/session tracking.
- Dhikr, dua, Ramadan, and charity tracking placeholders.

Next prompt:

```text
Build Update 5 for the Flutter Life OS app. Implement the Prayer module with five daily prayers, completion tracking, prayer calculation settings placeholders, reminder settings placeholders, Quran tracking, dhikr, dua, Ramadan, and charity placeholders. Keep all labels English. Add dashboard summaries and tests for prayer progress.
```

### Update 6: Health Connect / Google Fit preparation

Goal: prepare Android health tracking with privacy-first permissions.

Deliverables:

- Health dashboard focused first on steps, sleep duration, water intake, weight, exercise/workout, mood, and medicine tracking.
- Secondary health metric placeholders for heart rate, blood pressure, blood sugar, calories burned, distance walked, active minutes, and BMI.
- Manual entry for fields that cannot be synced.
- Health Connect / Google Fit integration boundary with permission explanation screens.
- No background tracking without explicit permission.

Next prompt:

```text
Build Update 6 for the Flutter Life OS app. Implement the Health dashboard with manual entries and an integration boundary for Android Health Connect / Google Fit. Prioritize steps, sleep duration, water intake, weight, exercise/workout, mood, and medicine tracking. Add secondary placeholders for heart rate, blood pressure, blood sugar, calories burned, distance walked, active minutes, and BMI. Add permission explanation screens and do not track anything without explicit user consent. Add tests for health summaries and permission-state UI.
```

### Update 7: Reviews, reports, and offline summaries

Goal: provide useful feedback without online AI.

Deliverables:

- Daily closing report.
- Weekly review.
- Monthly review.
- Offline rule-based summaries for productivity, habits, finance, health, and prayer.
- Dashboard suggestions generated from local data.

Next prompt:

```text
Build Update 7 for the Flutter Life OS app. Add daily closing reports, weekly reviews, monthly reviews, and offline rule-based summaries. Generate local suggestions for productivity, habits, finance, health, and prayer using existing stored data. Do not call online AI services yet. Add tests for report generation and dashboard suggestion logic.
```

### Update 8: Cloud sync and optional Google login

Goal: add backup after local features are stable.

Deliverables:

- Optional Google login.
- Firebase backup/sync design.
- Conflict handling strategy.
- Export/import.
- Privacy settings.

Next prompt:

```text
Build Update 8 for the Flutter Life OS app. Add optional Google login and a Firebase-sync-ready architecture for backup across devices. Keep local-first behavior as the default. Add export/import, sync status UI, basic conflict handling strategy, and privacy settings. Do not force login. Add tests for signed-out and signed-in states.
```

### Update 9: Future sensitive and AI modules

Goal: add advanced modules only after security foundations are ready.

Deliverables:

- Password vault only after encryption and biometric unlock.
- ID documents only after secure storage.
- SMS parsing only after explicit consent and privacy review.
- Location history only after explicit opt-in.
- OpenAI-powered assistant or configurable provider after offline summaries are validated.

Next prompt:

```text
Build Update 9 for the Flutter Life OS app. Prepare future advanced modules behind secure feature flags: password vault, ID documents, SMS parsing, location history, and online AI assistant. Do not enable these by default. Add encryption/biometric requirements to the UI copy and architecture notes. Keep offline summaries as the active assistant mode until the user explicitly enables online AI later.
```

## What is still needed from the owner

No blocking decision is needed before Update 1. Before implementation reaches later phases, the owner should provide:

- Final logo image files matching the required asset specification.
- Firebase project credentials and package configuration when Firebase integration starts.
- Exact visual logo design approval before launcher icon and splash screen generation.
