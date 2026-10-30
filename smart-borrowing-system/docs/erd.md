# Data model

```mermaid
erDiagram
  USER ||--o{ BORROWING : submits
  BORROWING ||--|{ BORROWING_ITEM : contains
  EQUIPMENT ||--o{ BORROWING_ITEM : requested_as
  CATEGORY ||--o{ EQUIPMENT : groups
  USER { string id PK; string email UK; enum role }
  EQUIPMENT { string id PK; string assetTag UK; int totalQuantity; int availableQuantity }
  BORROWING { string id PK; string borrowerId FK; enum status; datetime dueAt }
  BORROWING_ITEM { string id PK; string borrowingId FK; string equipmentId FK; int quantity }
  CATEGORY { string id PK; string name UK }
```

The Prisma schema is the source of truth. Borrowing items connect requests to equipment and store requested quantities; borrowing status tracks the request and loan lifecycle.

