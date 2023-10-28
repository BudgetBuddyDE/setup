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

## Getting started

### Local setup

### Docker

## Deployment
