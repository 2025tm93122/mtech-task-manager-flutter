# 2-minute YouTube demo script

The assignment asks the video to show login, task creation, update, delete, and logout. Use this sequence to fit in roughly two minutes.

## 0:00–0:12 — Introduction

> “This is my M.Tech SE ZG585 Task Manager application. It is built in Flutter, running on iOS, with Back4App Parse Server as Backend-as-a-Service.”

Show the iPhone Simulator and briefly show the Back4App Database tab in the browser side-by-side if possible.

## 0:12–0:30 — Register and login

If you have not registered yet, tap **Create account**, enter your name, student email and password, and submit.

If already registered, show **Sign in** and log in.

Say:
> “Authentication is handled by Back4App; the app does not implement a custom backend.”

## 0:30–0:55 — Create (C)

Tap **New task**.

Suggested task:
- Title: `Prepare M.Tech project presentation`
- Description: `Finalize slides and record the assignment demo.`
- Priority: `High`
- Due date: tomorrow

Tap **Create task**. Point out the dashboard counters and the new task.

## 0:55–1:10 — Read + real-time backend (R)

Show that the task appears in the list. Briefly switch to Back4App Database → `Task` and show the same task row. If Live Query is enabled, editing a row from another client/session can be shown updating the app without a full reload, but this is optional if time is tight.

## 1:10–1:30 — Update (U)

Open the task, change the description or priority, and tap **Save changes**. Toggle the task complete and show the Done counter increasing.

## 1:30–1:45 — Delete (D)

Use the task menu → **Delete task** → confirm. Show that it disappears from the list and Back4App after deletion.

## 1:45–1:55 — Logout

Tap the logout icon. Show the login screen again.

## 1:55–2:00 — Close

> “This demonstrates student authentication, complete CRUD operations, Back4App cloud storage, real-time-ready synchronization, and secure logout in the iOS Flutter application.”
