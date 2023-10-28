set time zone 'Europe/Berlin';

/**
 * Tables
 */
create table if not exists "user"
(
    uuid       uuid                     default gen_random_uuid() not null
        constraint users_pk
            primary key,
    email      varchar                                            not null,
    name       varchar(30),
    surname    varchar(30),
    password   varchar,
    created_at timestamp default current_timestamp
);

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
    created_at timestamp default current_timestamp
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
    created_at timestamp default current_timestamp
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
    address     varchar(100) not null,
    description text,
    created_at timestamp default current_timestamp
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
    processed_at    date                     default now(),
    receiver        varchar(80)      not null,
    description     text,
    transfer_amount double precision not null,
    created_at timestamp default current_timestamp
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
    receiver        varchar(80)      not null,
    description     text,
    transfer_amount double precision not null,
    created_at timestamp default current_timestamp
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
    created_at timestamp default current_timestamp
);

/**
 * Views
 */