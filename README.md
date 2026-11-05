# AgenticAI

**AgenticAI** is an Android-first AI mentor for Indian government-job aspirants.

## Vision
A personal preparation agent for SSC CGL/CHSL, RRB NTPC, Banking and State PSC exams that plans study, analyses performance, manages revision and gives actionable mentoring.

## Step 1 — Foundation
- Flutter / Dart + Material 3 foundation
- Home dashboard
- Bottom navigation for Home, Study Plan, AI Mentor and Progress
- Preparation hub placeholders for Mock/PYQ, Mistake Book and GK/Current Affairs
- Clean feature-ready `lib/src` structure
- SharedPreferences dependency reserved for local preferences/onboarding

## Roadmap
1. Foundation ✅
2. Aspirant onboarding/profile
3. AI Mentor
4. Adaptive study planner
5. Exam preparation engine
6. Mock tests + PYQ
7. Performance intelligence
8. GK + current affairs
9. Agentic decision layer
10. Production testing + Android release

## Run
Install Flutter, then:

```bash
flutter pub get
flutter run
```

> Step 1 intentionally keeps the app lightweight. Platform scaffolding can be generated with `flutter create . --platforms=android` before the first Android build.


## V3 Online AI (in review)
- Gemini-powered online mentor and live web-grounded current affairs.
- Google Search grounding is enabled for requests marked as live-web queries.
- Configure a personal Gemini API key in Online AI Setup. Internet access is required; quotas and pricing depend on Google's current terms.
- Android CI runs for pushes to `main` and `v3-online-agenticai` and for pull requests targeting `main`.
