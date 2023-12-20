set time zone 'UTC+1';

/**
 * Tables
 */
create table if not exists role
(
    id          serial
        constraint role_pk
            primary key,
    role        varchar(20) not null,
    description text,
    permissions int default 100,
    created_at timestamp with time zone default current_timestamp
);

insert into public.role (id, role, description, permissions, created_at)
values
  (default, 'Basic', 'For members', 100, default),
  (default, 'Service-Account', 'For internal services', 200, default),
  (default, 'Admin', null, 1000, default);

create table if not exists "user"
(
    uuid       uuid                     default gen_random_uuid() not null
        constraint users_pk
            primary key,
    role       serial
        constraint user_role_id_fk
            references role
            on delete restrict,
    email      varchar                                            not null,
    name       varchar(30),
    surname    varchar(30),
    password   varchar,
    created_at timestamp with time zone default current_timestamp
);

alter table "user"
    add column is_verified boolean default false;

create unique index if not exists users_email_uindex
    on "user" (email);

create table if not exists user_avatar
(
    id         serial
        constraint user_avatar_pk
            primary key,
    owner      uuid        not null
        constraint user_avatar_user_uuid_fk
            references "user"
            on delete cascade,
    file_name  varchar     not null,
    mimetype   varchar(20) not null,
    created_at timestamp with time zone default now()
);

create unique index if not exists user_avatar_owner_uindex
    on "user_avatar" (owner);

create table if not exists user_feedback
(
    id         serial
        constraint feedback_pk
            primary key,
    owner      uuid
        constraint user_feedback_user_uuid_fk
            references "user"
            on delete cascade,
    rating      integer                  default 0
        constraint subscription_rating_check
            check ((rating >= 1) AND (rating <= 5)),
    title      varchar(120) not null,
    message    text,
    created_at timestamp with time zone default current_timestamp
);

create table if not exists category
(
    id          serial
        constraint category_pk
            primary key,
    owner       uuid                                   not null
        constraint category_user_uuid_fk
            references "user"
            on delete cascade,
    name        varchar(100)                           not null,
    description text,
    created_at timestamp with time zone default current_timestamp
);

create table if not exists payment_method
(
    id          serial
        constraint payment_method_pk
            primary key,
    owner       uuid         not null
        constraint payment_method_user_uuid_fk
            references "user"
            on delete cascade,
    name        varchar(100) not null,
    provider    varchar(100) not null,
    address     varchar(100) not null,
    description text,
    created_at timestamp with time zone default current_timestamp
);

create table if not exists transaction
(
    id              serial
        constraint transaction_pk
            primary key,
    owner           uuid             not null
        constraint transaction_user_uuid_fk
            references "user"
            on delete cascade,
    category        serial
        constraint transaction_category__fk
            references category
            on delete cascade,
    payment_method  serial
        constraint transaction_payment_method_id_fk
            references payment_method
            on delete cascade,
    processed_at    timestamp with time zone       default now(),
    receiver        varchar(120)     not null,
    description     text,
    transfer_amount double precision not null,
    created_at timestamp with time zone default current_timestamp
);

create table if not exists subscription
(
    id              serial
        constraint subscription_pk
            primary key,
    owner           uuid             not null
        constraint subscription_user_uuid_fk
            references "user"
            on delete cascade,
    category        serial
        constraint subscription_category__fk
            references category
            on delete cascade,
    payment_method  serial
        constraint subscription_payment_method_id_fk
            references payment_method
            on delete cascade,
    paused          boolean                  default false,
    execute_at      integer                  default 1
        constraint subscription_execute_at_check
            check ((execute_at >= 1) AND (execute_at <= 31)),
    receiver        varchar(120)      not null,
    description     text,
    transfer_amount double precision not null,
    created_at timestamp with time zone default current_timestamp
);

create table if not exists budget
(
    id              serial
        constraint budget_pk
            primary key,
    category        serial
        constraint budget_category__fk
            references category
            on delete cascade,
    owner           uuid             not null
        constraint budget_user_uuid_fk
            references "user"
            on delete cascade,
    budget double precision not null,
    created_at timestamp with time zone default current_timestamp
);

create table if not exists log 
(
    id serial constraint log_pk
        primary key,
    application varchar not null,
    type varchar default 'LOG',
    category varchar default 'uncategorized',
    content text not null,
    created_at timestamp with time zone default current_timestamp
);

/**
 * Views
 */
create or replace view public.v_budget_progress as
    select
        *,
        coalesce((select ABS(SUM(transaction.transfer_amount))
            from transaction
            where transaction.transfer_amount <= 0
            and transaction.category = budget.category
            and transaction.processed_at::DATE <= now()::DATE
            and extract(month FROM transaction.processed_at) = extract(month FROM now())
            and extract(year FROM transaction.processed_at) = extract(year FROM now())), 0) as amount_spent
        from budget;

/**
 * Functions
 */
create function f_get_daily_transactions(start_date date, end_date date, requested_data text, user_id uuid)
    returns TABLE(date date, amount double precision)
    language sql
as
$$
SELECT
    dates.transaction_date as date,
    (SELECT COALESCE(SUM(t.transfer_amount), 0)
     FROM transaction t
     WHERE t.owner = user_id
       AND date_trunc('day', t.processed_at) = dates.transaction_date
       AND requested_data = TRIM(requested_data)
       AND (
             (requested_data = 'INCOME' AND t.transfer_amount >= 0)
             OR (requested_data = 'SPENDINGS' AND t.transfer_amount <= 0)
             OR (requested_data = 'BALANCE')
         ))
FROM (
         SELECT generate_series(start_date, end_date, '1 day') AS transaction_date
     ) AS dates
GROUP BY
    dates.transaction_date
ORDER BY
    dates.transaction_date ASC;
$$;
