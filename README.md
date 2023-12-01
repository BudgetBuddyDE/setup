# Setup

## Infrastructure (WIP)

> [!NOTE]
> Boxes in red are "planned" features and not iomplemented in the current version (therefore not in set-up during deployment)

```mermaid
---
title: Budget-Buddy Infrastructure
---
flowchart TD

style mail-service fill:#FF7276;
style mail-service color:#fff;
style file-service fill:#FF7276;
style file-service color:#fff;
style file-analyzer-service fill:#FF7276;
style file-analyzer-service color:#fff;
style feedback-service fill:#FF7276;
style feedback-service color:#fff;
style resend fill:#FF7276;
style resend color:#fff;
style storage fill:#FF7276;
style storage color:#fff;

webapp[Webapp]
website[Website]
subscription-service[Subscription-Service]
mail-service[Mail-Service]
feedback-service[Feedback-Service]
file-service[File-Service]
file-analyzer-service[File-Analyzer Service]
backend[Backend]
gh-api[GitHub GraphQL]
resend[Resend]
postgres[(Postgres)]
redis[(Redis)]
storage[Bucket/Storage]

click website href "https://github.com/BudgetBuddyDE/Website"
click webapp href "https://github.com/BudgetBuddyDE/Webapp"
click subscription-service href "https://github.com/BudgetBuddyDE/Subscription-Service"
click mail-service href "https://resend.com/"
click file-service href "https://github.com/kleithor/file-service"
click backend href "https://github.com/BudgetBuddyDE/Backend"

subgraph "Database"
  postgres
  redis
end

subgraph "Files/Storage"
  storage
end

subgraph "3rd Party Service"
  gh-api
  resend
end

subgraph "Communication-Layer"
  backend<-->postgres
  backend<-->redis
  feedback-service
  mail-service<-->resend
  file-analyzer-service
  file-service<-->storage
end

subgraph "Consumer-Layer"
  website<-->feedback-service
  website-->gh-api
  website-->mail-service
  webapp<-->feedback-service
  webapp-->mail-service
  webapp<-->backend
  webapp<-->file-service
  subscription-service<-->backend
end
```

## Database

```mermaid
erDiagram
  user {
    uuid uuid PK
    string email "UNIQUE"
    varchar(30) name
    varchar(30) surname
    varchar password
    timestamp created_at
  }
  user_avatar {
    serial id PK
    uuid owner FK
    varchar file_name
    varchar(20) mimetype
    timestamp created_At
  }
  user_feedback {
    serial id PK
    uuid owner FK
    int rating
    varchar(120) title
    text message
    timestamp created_At
  }
  category {
    serial id PK
    uuid owner FK
    varchar(100) name
    text description
    timestam created_at
  }
  payment_method {
    serial id PK
    uuid owner FK
    varchar(100) name
    varchar(100) provider
    varchar(100) address
    text description
    timestamp created_at
  }
  transaction {
    serial id PK
    uuid owner FK
    serial category FK
    serial payment_method FK
    timestamp processed_at
    varchar(120) receiver
    text description
    double transfer_amount
    timestamp created_at
  }
  subscription {
    serial id PK
    uuid owner FK
    serial category FK
    serial payment_method FK
    boolean paused "Defaule false"
    integer execute_at "between 1 and 31"
    varchar(120) receiver
    text description
    double transfer_amount
    timestamp created_at
  }
  budget {
    serial id PK
    serial category FK
    uuid owner FK
    double budget
    timestamp created_at
  }
  log {
    serial id PK
    varchar application
    varchar type "Default 'LOG'"
    varchar category "Default 'uncategorized'"
    text content
    timestamp created_at
  }
  v_budget_progress {
    serial id PK
    serial category FK
    uuid owner FK
    double budget
    timestamp created_at
    double amount_spent
  }
```

## Getting started

### Local setup

### Docker

## Deployment
