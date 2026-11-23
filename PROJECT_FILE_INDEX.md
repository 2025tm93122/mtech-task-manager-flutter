# Project file index

## Start here
- `START_HERE.md` — shortest setup path
- `README.md` — repository overview

## Flutter source
- `lib/main.dart` — app entry point
- `lib/app.dart` — Material app, configuration guard and auth gate
- `lib/config/back4app_config.dart` — runtime Back4App config
- `lib/services/auth_service.dart` — register/login/logout/session
- `lib/services/task_service.dart` — task CRUD, ACL, query and statistics
- `lib/models/task_model.dart` — Parse-to-task mapping
- `lib/screens/auth/` — login/register screens
- `lib/screens/home/home_screen.dart` — dashboard, filters and Live Query list
- `lib/screens/tasks/task_form_screen.dart` — create/edit form
- `lib/widgets/` + `lib/core/` — reusable UI/theme components

## iOS/run support
- `scripts/bootstrap_ios.sh` — safely generates the standard Flutter iOS runner and installs pods
- `scripts/run_ios.sh` — runs with private Back4App `--dart-define` configuration
- `scripts/check_project.sh` — analyze + test
- `.back4app.env.example` — credential template

## Assignment documentation
- `docs/ASSIGNMENT_REQUIREMENT_MAPPING.md`
- `docs/BACK4APP_SETUP.md`
- `docs/BACK4APP_SCHEMA.md`
- `docs/CREDENTIALS_TEMPLATE.md`
- `docs/IOS_SETUP.md`
- `docs/VIDEO_SCRIPT_2_MIN.md`
- `docs/PRE_RECORDING_CHECKLIST.md`
- `docs/GITHUB_SUBMISSION.md`
- `docs/TROUBLESHOOTING.md`
- `docs/ACADEMIC_VIVA_QA.md`
- `docs/PROJECT_EXPLANATION.md`

## Deliverables/assets
- `MTech_Task_Manager_Presentation.pptx`
- `assets/screenshots/*.png` — clearly labeled design mockups
- `test/validators_test.dart`
- `.github/workflows/flutter-ci.yml`
