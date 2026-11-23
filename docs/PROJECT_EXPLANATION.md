# Project explanation

## Architecture

The application follows a small layered architecture:

1. **Presentation layer** — Flutter screens and reusable widgets.
2. **Service layer** — `AuthService` and `TaskService` isolate Back4App/Parse calls from UI code.
3. **Model layer** — `TaskModel` maps Parse objects into strongly named task properties.
4. **BaaS layer** — Back4App hosts Parse `_User`, `Task`, sessions, ACLs and Live Query.

There is intentionally no custom Express/Spring/Django server because the assignment is designed to demonstrate BaaS.

## Authentication

Registration sends student email, password, and display name to Parse `_User`. The app uses normalized lowercase email as both username and email to keep sign-in simple. Successful login persists a Parse session locally, allowing `AuthGate` to restore the signed-in state when the app opens again.

## CRUD

`TaskService` contains the cloud operations:
- `createTask()` creates a Back4App `Task` object.
- `buildLiveQuery()` reads user-owned tasks and powers the live list.
- `updateTask()` edits task fields.
- `deleteTask()` deletes the task.
- `toggleCompleted()` provides a focused update action.

## Security

Every task receives a `ParseACL(owner: owner)`, which gives only the logged-in owner read/write permission. The Task also stores `ownerId` for query filtering. The Master Key is deliberately excluded from client code.

## Real-time behavior

`HomeScreen` uses `ParseLiveListWidget`. When Back4App Live Query is enabled for `Task`, matching create/update/delete events are delivered through the SDK's live-query WebSocket mechanism and the list can update dynamically.

## iOS target

Flutter remains the development framework required by the assignment. The generated platform runner is iOS, and the app is demonstrated in Apple's iPhone Simulator or on a physical iPhone.
