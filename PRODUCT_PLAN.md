# Livelife Product Plan

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

Livelife is a personal Life Operating System: a private Android-first command center for daily planning, habits, goals, health, finance, prayer, notes, documents-lite, learning, reminders, reviews, and offline summaries.

## Implementation status

- Update 1 completed: Android-first Material 3 app shell with bottom navigation and reusable UI components.
- Update 2 completed: local-first model and repository interfaces with seeded in-memory data ready for future SQLite/Isar/Hive and Firebase sync adapters.
- Update 3 completed: Daily Planner, Tasks, Goals, and Habits MVP with create/edit/complete flows where reasonable.
- Update 4 completed: personal INR finance MVP with Bank/UPI, income, expenses, bills, monthly summary, cash flow, basic reports, and advanced finance marked coming soon.
- Update 5 completed: prayer module with five daily prayers, completion tracking, progress summary, and placeholders for calculation settings, reminders, Quran, dhikr, dua, Ramadan, and charity.
- App identity update completed: project/package references standardized to `livelife`, visible app name set to `Livelife`, Android package set to `com.dsd003.life`, and Firebase Android config added.

## Completed update log

### Completed foundation updates

- Update 1: Android-first Material 3 app shell, bottom navigation, reusable cards, section headers, empty states, and coming-soon badges.
- Update 2: local-first models and repository interfaces with seeded in-memory data, prepared for a future SQLite/Isar/Hive storage adapter and Firebase sync adapter.
- Update 3: Daily Planner, Tasks, Goals, and Habits MVP with create, edit, and complete flows where practical.
- Update 4: personal INR finance MVP with Bank/UPI account source, income, expenses, pending bills, cash flow, monthly summary, basic reports, and advanced finance marked coming soon.
- Update 5: Prayer module with five daily prayers, completion tracking, progress summary, and placeholders for calculation settings, reminders, Quran, dhikr, dua, Ramadan, and charity.
- App identity: renamed app/package references to Livelife/livelife and aligned Android `applicationId` / namespace with Firebase package `com.dsd003.life`.

## Next implementation roadmap

### Next Update 6: Health dashboard and Health Connect boundary

Goal: add priority health metrics and permission-first integration boundary.

Full prompt:

```text
Build Update 6 for the Flutter Livelife app. Implement the Health dashboard with manual entries and an integration boundary for Android Health Connect / Google Fit. Prioritize steps, sleep duration, water intake, weight, exercise/workout, mood, and medicine tracking. Add secondary placeholders for heart rate, blood pressure, blood sugar, calories burned, distance walked, active minutes, and BMI. Add permission explanation screens and do not track anything without explicit user consent. Add tests for health summaries and permission-state UI.
```

### Next Update 7: Reports and offline summaries

Goal: provide daily/weekly/monthly feedback without online AI.

Full prompt:

```text
Build Update 7 for the Flutter Livelife app. Add daily closing reports, weekly reviews, monthly reviews, and offline rule-based summaries. Generate local suggestions for productivity, habits, finance, health, and prayer using existing stored data. Do not call online AI services yet. Add tests for report generation and dashboard suggestion logic.
```

### Next Update 8: Real local persistence

Goal: replace seeded in-memory data with a real offline-first local database.

Full prompt:

```text
Build Update 8 for the Flutter Livelife app. Replace the seeded in-memory repository with a real offline-first local persistence layer while keeping the existing repository interfaces stable. The owner has no local database preference, so choose the best fit for this Flutter app, with Isar or Hive as primary candidates. Persist tasks, habits, goals, finance entries in INR, health entries, prayer records, notes, and daily reviews. Add IDs, createdAt/updatedAt fields where needed, serialization, and a basic migration/version strategy. Keep all labels English only and keep Business, password vault, ID documents, SMS parsing, tax/GST, and location history out of the enabled first version. Update tests to prove data can be created, updated, read back, and survive repository re-creation.
```

### Next Update 9: Firebase Android setup and optional Google login

Goal: initialize Firebase for Android package `com.dsd003.life` while keeping login optional and local-first usage default.

Full prompt:

```text
Build Update 9 for the Flutter Livelife app. Integrate Firebase for the Android-first Flutter app using the committed android/app/google-services.json file for project financial-b456b and Android package com.dsd003.life. Keep the app local-first and do not force login. Add Firebase core initialization, Android Gradle configuration, and optional Google login UI/state. Add signed-out default behavior, sign-in available state, Firebase initialization guards, and tests/mocks for signed-out and optional sign-in states. Do not implement cloud data sync yet; only prepare Firebase initialization and optional auth foundation.
```

### Next Update 10: Firebase backup and sync adapter

Goal: sync local data to Firebase only after local persistence and Firebase initialization are stable.

Full prompt:

```text
Build Update 10 for the Flutter Livelife app. Add a Firebase backup and sync adapter behind the existing repository interfaces. Keep the local database as the source of truth and sync automatically only when Firebase is configured and the user opts into backup/sign-in. Implement a sync queue for offline writes, last-sync status, retry handling, conflict detection, and a simple conflict review UI. Add export/import hooks and privacy controls to enable or disable sync. Add tests for local-only mode, queued sync, successful sync, failed sync retry, and conflict detection.
```

### Next Update 11: Full CRUD completion

Goal: make all current MVP modules editable, not just visible.

Full prompt:

```text
Build Update 11 for the Flutter Livelife app. Complete CRUD flows for the current enabled modules. Add create, edit, and delete for finance income, expenses, and bills; health manual entries for priority metrics; goals and milestones; notes; and daily reviews. Add editable prayer settings placeholders stored locally. Improve form validation, empty states, and tests for each CRUD flow. Keep advanced modules disabled and do not add Business, password vault, ID documents, SMS parsing, tax/GST, or location history as enabled features.
```

### Next Update 12: Notifications and reminders

Goal: make the app remind the user about daily life actions.

Full prompt:

```text
Build Update 12 for the Flutter Livelife app. Add local notifications and reminder scheduling for tasks, habits, prayers, bills, and daily closing reports. Implement Android notification permission handling, reminder settings UI, and safe defaults. Store reminder preferences locally and keep notifications disabled until the user grants permission. Add tests for reminder preference logic and permission-state UI.
```

### Next Update 13: Real Health Connect / Google Fit integration

Goal: replace health placeholders with permission-based Android health data integration.

Full prompt:

```text
Build Update 13 for the Flutter Livelife app. Implement real Android Health Connect / Google Fit integration with explicit user consent. Add permission explanation screens, permission request flow, and read support for steps, sleep duration, exercise/workout, and weight where available. Keep water intake, mood, and medicine tracking manual-first. Handle denied permissions, unavailable Health Connect/Google Fit, and partial permissions. Add tests for permission states and health summary updates.
```

### Next Update 14: Prayer calculation engine

Goal: calculate prayer times accurately instead of using seed placeholders.

Full prompt:

```text
Build Update 14 for the Flutter Livelife app. Replace placeholder prayer times with a real prayer calculation engine. Support multiple calculation methods, automatic location-based calculation, manual location selection, manual prayer time adjustment, Hanafi/Shafi'i Asr options, timezone/daylight handling, and a settings screen where the user can change the method at any time. Keep all labels English. Add tests for calculation settings, manual adjustments, and prayer progress display.
```

### Next Update 15: Branding, launcher icon, and splash screen

Goal: finalize app identity after logo assets are provided.

Full prompt after logo files are available:

```text
Build Update 15 for the Flutter Livelife app. Add the final custom logo assets into the assets folder using docs/LOGO_ASSETS.md. Configure Android launcher icons, adaptive icon foreground/background, splash screen, and app display name. Ensure the logo works in light mode and dark mode and does not contain text inside the icon. Update pubspec/assets configuration if needed and add tests or checks for asset paths.
```

## What is still needed from the owner

No blocking owner decision is needed for the next Health dashboard update. Before branding can be completed, the owner should provide:

- Final logo image files matching the required asset specification.
- Exact visual logo design approval before launcher icon and splash screen generation.
