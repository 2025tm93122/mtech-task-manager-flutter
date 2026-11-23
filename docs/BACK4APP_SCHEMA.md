# Back4App database schema

You do **not** need to manually create the `Task` class before the first task is saved because Parse can create it automatically. For a clean demo, however, you can create it in Database > Create a class > Custom > `Task`.

## `_User` (built in by Parse)

| Field | Type | Purpose |
|---|---|---|
| username | String | The normalized student email |
| email | String | Student email |
| password | Secured by Parse | Never stored in your Flutter source |
| displayName | String | Name shown in the dashboard |

## `Task`

| Field | Type | Required | Purpose |
|---|---|---:|---|
| title | String | Yes | Task title |
| description | String | No | Task details |
| priority | String | Yes | Low / Medium / High |
| isCompleted | Boolean | Yes | Active/done state |
| dueDate | Date | No | Optional due date |
| ownerId | String | Yes | Current `_User.objectId` for query filtering |
| ownerEmail | String | Yes | Helpful for demo/debugging |
| ACL | ACL | Yes | Owner-only read/write access |
| createdAt | Date | Auto | Parse metadata |
| updatedAt | Date | Auto | Parse metadata |

## Security design

Each new `Task` gets `ParseACL(owner: owner)`, so only its owner can read/write it through normal client requests. The ownerId is also used in the query, giving both security and simple per-user filtering.
