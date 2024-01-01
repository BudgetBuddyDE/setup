# Setup

## ToC

- [Setup](#setup)
  - [ToC](#toc)
  - [Infrastructure](#infrastructure)
    - [Services](#services)
    - [Database](#database)
  - [Getting started](#getting-started)
    - [Docker-Compose](#docker-compose)
  - [Deployment](#deployment)
  - [Backups](#backups)
    - [Postgres](#postgres)
    - [Redis](#redis)

## Infrastructure

### Services

> [!NOTE]
> Boxes in red are "planned" features and not iomplemented in the current version (therefore not in set-up during deployment)

```mermaid
---
title: Budget-Buddy Infrastructure
---
flowchart TD

style file-analyzer-service fill:#FF7276;
style file-analyzer-service color:#fff;
style feedback-service fill:#FF7276;
style feedback-service color:#fff;

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
storage[Bucket/Storage/Volume]

click website href "https://github.com/BudgetBuddyDE/Website"
click webapp href "https://github.com/BudgetBuddyDE/Webapp"
click subscription-service href "https://github.com/BudgetBuddyDE/Subscription-Service"
click mail-service href "https://github.com/BudgetBuddyDE/Mail-Service"
click file-service href "https://github.com/BudgetBuddyDE/File-Service"
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

### Database

![](./database/db.png)

## Getting started

1. Log into the Github Image Registry

   ```bash
   echo <GH_PAT> | docker login ghcr.io -u <GH_USER> --password-stdin
   ```

Now you should be able to pull Docker images from Github

### Docker-Compose

```
docker-compose up -d
# or just the essential services
docker-compose up -d postgres redis backend subscription-service
```

## Deployment

> [!IMPORTANT]
> Make sure to grant access permission to the `restart_service.sh` with `sudo chown user:group restart_service.sh` and make the script executeable with `chmod +x restart_service.sh`

## Backups

### Postgres

**How to restore backed up data?**

```bash
psql -U <DB_USER> <DB_NAME> < backup.sql
```

### Redis

**How to restore backed up data?**

```bash

```
