# START HERE — M.Tech Task Manager iOS project

This folder is designed to take you from ZIP file to a recorded assignment demo with the fewest possible decisions.

## What is already complete

- Flutter application source
- iOS-first responsive interface
- Back4App/Parse authentication
- Task Create / Read / Update / Delete
- Search and All/Active/Done filters
- Priority and due date
- Owner-only ACL security
- Live Query-compatible dynamic task list
- Secure logout
- Validation tests
- README and GitHub structure
- Back4App schema/setup instructions
- 2-minute video recording script
- Viva questions and answers
- PowerPoint presentation

## What only you must provide

1. A Mac with Xcode + Flutter + CocoaPods.
2. Your own free Back4App app.
3. Your Back4App **Application ID** and **Client Key**.
4. Your actual student email for the demo.
5. Your GitHub/YouTube/Taxila accounts for submission.

No one can safely pre-generate your private cloud keys inside a distributable project; the package intentionally uses runtime configuration.

## Run in this exact order

```bash
# 1. From this project folder
bash scripts/bootstrap_ios.sh

# 2. Create private credential file
cp .back4app.env.example .back4app.env

# 3. Open it and paste Application ID + Client Key
open .back4app.env

# 4. Follow docs/BACK4APP_SETUP.md to enable Live Query for Task

# 5. Open iOS Simulator
open -a Simulator

# 6. Run
bash scripts/run_ios.sh
```

If Flutter sees multiple devices:

```bash
flutter devices
bash scripts/run_ios.sh <DEVICE_ID>
```

## Before you record

Create/confirm the `Task` class, enable Live Query for it, and keep Back4App's Database screen open in a browser tab. Follow `docs/VIDEO_SCRIPT_2_MIN.md` exactly.

## Before you submit

- Replace or supplement the included design mockups with real iPhone Simulator screenshots.
- Put your BITS ID on the title slide if required.
- Push the repository without `.back4app.env`.
- Upload the 2-minute video to YouTube.
- Submit YouTube link + GitHub URL + PPT in Taxila.
