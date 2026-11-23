# Viva / presentation Q&A

**Why Back4App instead of a custom API?**  
The assignment focuses on Backend-as-a-Service. Back4App provides Parse authentication, object storage, sessions, and Live Query, so the mobile client can use cloud backend capabilities without maintaining a separate server.

**Where is CRUD implemented?**  
Create/update/delete are methods in `TaskService`; read and real-time updates are rendered through `ParseLiveListWidget` using a query scoped to the logged-in user.

**How are users separated?**  
Every Task stores `ownerId`, queries filter on it, and each Task receives an owner-only Parse ACL. The ACL is the authorization boundary; `ownerId` makes filtering efficient and explicit.

**Why is the Master Key not in the app?**  
A mobile binary is client-side and can be inspected. A Master Key would bypass normal access control, so only the client-safe Application ID and Client Key are supplied at runtime.

**How is real-time sync achieved?**  
Back4App Live Query uses a WebSocket subscription. The Flutter Parse SDK's live-list widget listens for matching object create/update/delete events and updates the displayed list.

**Why Flutter for an iOS app?**  
The assignment explicitly requires Flutter. Flutter compiles to an iOS application and runs in the iOS Simulator or on an iPhone, satisfying both the required framework and the chosen target platform.
