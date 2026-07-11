# Life OS Product Plan

## Current application assessment

This repository is a Flutter mobile application. It now has a Life OS visual prototype, but it is not yet a production personal management system. The app still needs real navigation, data models, local storage, cloud sync, permissions, authentication, Health Connect / Google Fit integration, notifications, reports, and offline summary logic.

## Locked product decisions

- Product language: English only.
- Platform priority: Android first.
- Authentication: no login required for the first release; optional Google login can be added when cloud sync starts.
- Storage: local plus cloud sync is required.
- First-version sensitive scope: do not include password vault, ID documents, SMS parsing, or location history.
- Finance: Indian Rupee currency, bank/UPI treated as the same account source, basic reports required, advanced categories/budget rules/tax/GST marked as coming soon.
- Health: manual entry plus Health Connect / Google Fit integration is required.
- Prayer: include prayer calculation settings, reminders, Quran tracking, Ramadan tracking, and charity tracking.
- Business: remove business-management features from the first personal version.
- AI: offline summaries first; OpenAI-powered or configurable AI providers can be added later.
- Design: modern Android-first Material 3 style, blue/indigo primary color, clean cards, dark-mode support later, dashboard priority set by daily use value.

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
- Later-ready abstraction for SQLite/Isar/Hive without locking the UI to one storage engine.

Next prompt:

```text
Build Update 2 for the Flutter Life OS app. Add a local-first data layer with models and repository interfaces for tasks, habits, goals, finance entries in INR, health entries, prayer records, notes, and daily reviews. Use seed/in-memory repositories for now so the UI can read and write sample data without a backend. Keep the architecture ready for SQLite/Isar/Hive and future cloud sync. Add unit tests for the models and repositories.
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

- Health dashboard for steps, sleep, water, weight, BMI, heart rate, calories, mood, medicine, blood pressure, and sugar.
- Manual entry for fields that cannot be synced.
- Health Connect / Google Fit integration boundary with permission explanation screens.
- No background tracking without explicit permission.

Next prompt:

```text
Build Update 6 for the Flutter Life OS app. Implement the Health dashboard with manual entries and an integration boundary for Android Health Connect / Google Fit. Include steps, sleep, water, weight, BMI, heart rate, calories, mood, medicine, blood pressure, and sugar. Add permission explanation screens and do not track anything without explicit user consent. Add tests for health summaries and permission-state UI.
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
- Cloud backup/sync design.
- Conflict handling strategy.
- Export/import.
- Privacy settings.

Next prompt:

```text
Build Update 8 for the Flutter Life OS app. Add optional Google login and a cloud-sync-ready architecture for backup across devices. Keep local-first behavior as the default. Add export/import, sync status UI, basic conflict handling strategy, and privacy settings. Do not force login. Add tests for signed-out and signed-in states.
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

- App logo preference or permission to generate a simple Life OS logo.
- Google account/cloud provider preference when Update 8 starts.
- Prayer calculation preference when Update 5 starts.
- Exact health metrics to prioritize when Update 6 starts.
- Whether cloud sync should use Firebase, Supabase, or a custom backend.
