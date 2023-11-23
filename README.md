# Setup

## Infrastructure (WIP)

> [!NOTE]
> Boxes in red are "planned" features and not iomplemented in the current version (therefore not in set-up during deployment)

```mermaid
---
title: Budget-Buddy Infrastructure
---
flowchart TD

style bucket fill:#FF7276;
style bucket color:#fff;
style file-service fill:#FF7276;
style file-service color:#fff;
style feedback-service fill:#FF7276;
style feedback-service color:#fff;

subgraph "Database"
  postgres[(Postgres)]
  redis[(Redis)]
end

subgraph "File Storage/Bucket"
  bucket[Bucket/Storage]
end

subgraph "3rd Party Service"
  gh-api[GitHub GraphQL]
end

subgraph "Communication-Layer"
  postgres <--> backend[Backend]
  redis <--> backend[Backend]
  bucket <--> file-service[File-Service]
  postgres <--> feedback-service[Feedback-Service]
end

subgraph "Conusmer-Layer"
  gh-api -->|Retrieve repositories| website[Website]
  backend <-->|View & Maintain| webapp[Webapp]
  file-service <-->|View & Maintain| webapp[Webapp]
  backend <-->|Select & Insert| sub-service[Subscription-Service]
  feedback-service --> website
  feedback-service <--> webapp
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
