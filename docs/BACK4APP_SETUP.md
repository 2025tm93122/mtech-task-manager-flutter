# Back4App setup — exact steps

1. Sign in to Back4App and create a new **Backend as a Service / Parse** app. Suggested name: `MTechTaskManager`.
2. Open your app dashboard.
3. Locate **Application ID** and **Client Key** in the app's keys/security settings.
4. In this project folder run:
   ```bash
   cp .back4app.env.example .back4app.env
   ```
5. Paste your Application ID and Client Key into `.back4app.env`.
6. For basic CRUD, `BACK4APP_SERVER_URL=https://parseapi.back4app.com` works.
7. For the assignment's **real-time database syncing** demonstration:
   - Open Back4App → Server Settings → **Server URL and Live Query**.
   - Activate your Back4App subdomain.
   - Activate **Live Query**.
   - Enable Live Query for class `Task` after the class exists.
   - Put the HTTPS API subdomain into `BACK4APP_SERVER_URL` if Back4App instructs you to use it.
   - Put the corresponding WebSocket endpoint in `BACK4APP_LIVE_QUERY_URL`, typically `wss://YOUR-SUBDOMAIN.b4a.io`.
8. Run the app, register your student email, and create one task. Verify Back4App → Database → `Task` contains the row.
9. Verify Back4App → Database → `_User` contains the registered user.

## Important

The mobile app uses only **Application ID + Client Key**. Never place the **Master Key** in Flutter source code or a client-side config file.
