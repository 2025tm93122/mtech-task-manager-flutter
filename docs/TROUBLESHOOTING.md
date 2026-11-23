# Troubleshooting

## `flutter` command not found
Install Flutter stable and add `<flutter-sdk>/bin` to PATH, then restart Terminal.

## CocoaPods / pod install errors
```bash
sudo gem install cocoapods
pod repo update
cd ios && pod install --repo-update
```

## App shows “Back4App configuration required”
Your app was started without `BACK4APP_APP_ID` or `BACK4APP_CLIENT_KEY`. Run through `bash scripts/run_ios.sh`, not plain `flutter run`, unless you manually provide all `--dart-define` values.

## `Invalid session token`
Log out, clear/reinstall the simulator app, then log in again. Also ensure the Application ID and Client Key belong to the same Back4App app.

## Login fails even though the user exists
The app uses the email as Parse `username`. Register and login using the exact same email; the app normalizes it to lowercase.

## Tasks do not appear live
Basic CRUD can work even when Live Query is disabled. For true push syncing, enable Back4App **Server URL and Live Query**, activate the subdomain, enable Live Query for `Task`, and set `BACK4APP_LIVE_QUERY_URL`.

## iOS build signing asks for a team
For the iOS Simulator you normally do not need a paid developer account. If running on a physical iPhone, open `ios/Runner.xcworkspace`, select Runner → Signing & Capabilities, and choose your Apple Development Team.
