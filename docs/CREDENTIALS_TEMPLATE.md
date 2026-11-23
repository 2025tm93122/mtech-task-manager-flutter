# Credentials and configuration template

## 1. Back4App keys (you must create these in your own account)

Back4App Dashboard → your app → **App Settings / Server Settings → Security & Keys / App ID and Keys**.

Fill `.back4app.env`:

```bash
BACK4APP_APP_ID="PASTE_APPLICATION_ID"
BACK4APP_CLIENT_KEY="PASTE_CLIENT_KEY"
BACK4APP_SERVER_URL="https://parseapi.back4app.com"
BACK4APP_LIVE_QUERY_URL="wss://YOUR-SUBDOMAIN.b4a.io"
STUDENT_EMAIL_DOMAIN="YOUR_COLLEGE_DOMAIN_IF_REQUIRED"
```

Do not use the Master Key in a mobile app. Do not commit `.back4app.env`.

## 2. Suggested demo user for your video

Create this account **inside the app** so registration is visibly demonstrated:

- Name: `Angshuman Pal`
- Email: your actual student email ID
- Password: choose a temporary strong demo password, for example `MTechDemo@2026` (change it after recording if it is a real account)

The repository intentionally does not contain a real password or live Back4App key.
