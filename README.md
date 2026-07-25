# Ghulam Zakariya — Developer Portfolio

A premium, responsive Flutter **web** portfolio for Ghulam Zakariya, Flutter
Developer & Software Engineer.

## Highlights

- **Premium, animated UI** — scroll-reveal choreography, floating gradient
  background, hover micro-interactions, animated skill bars, counters, a
  scroll-progress bar and a back-to-top button.
- **Sections** — Hero, About, Skills, Experience (timeline), Projects (with
  category filtering) and a working Contact form.
- **Light / dark mode** with the signature amber accent, theme-aware throughout.
- **Working contact form** — delivers straight to the inbox via
  [FormSubmit](https://formsubmit.co) (no backend, no API keys).
- **SEO & accessibility** — meta/OG/Twitter tags, JSON-LD structured data,
  semantic labels, tooltips and reduced-motion support.

## Architecture

Built on Clean Architecture, matching the team's engineering standards
(`kfc-mobile-revamp` reference), adapted for a static site:

```
lib/
├── core/            # analytics, logging, utils, constants, routes
├── data/            # ContactService impl (FormSubmit), static content repo, errors
├── domain/          # entities (Freezed), service interfaces, use cases
├── injection/       # get_it + injectable DI
└── presentation/
    ├── resources/   # design system — AppColors/AppPalette, text, dimensions, theme
    ├── widgets/     # shared animated widgets (reveal, glass card, buttons…)
    └── features/    # home, projects, contact, theme — each with bloc/ + widgets/
```

- **State management:** `flutter_bloc` (Cubit + Freezed states, `BaseStatus`).
- **DI:** `get_it` + `injectable` (`@injectable` / `@lazySingleton`).
- **Models & states:** `freezed` immutable classes (codegen committed).
- **Routing:** `go_router`.

## Contact form setup (one-time)

The form delivers to the owner's inbox via [Web3Forms](https://web3forms.com)
(no backend, reliable CORS). One-time setup:

1. Go to [web3forms.com](https://web3forms.com), enter `khanzakariya22@gmail.com`,
   and copy the **Access Key** they email you.
2. Run/build the app with the key injected (never hardcoded):

```bash
flutter run -d chrome --dart-define=web3forms_access_key=YOUR_ACCESS_KEY
```

The delivery address is set by the access key's account. Implementation:
`lib/data/services/web3forms_contact_service.dart`.

## Getting started

```bash
flutter pub get
dart run build_runner build   # regenerate Freezed/injectable code if needed
flutter run -d chrome \
  --dart-define=web3forms_access_key=YOUR_ACCESS_KEY \
  --dart-define=amplitude_api_key=YOUR_AMPLITUDE_KEY   # optional analytics
```

## Build for web

```bash
flutter build web --release --dart-define=web3forms_access_key=YOUR_ACCESS_KEY
```
