create table login (
    id    bigserial primary key,
    ativo boolean not null,
    email varchar(250) not null,
    senha varchar(250) not null
);

create table pessoa (
    id        bigserial primary key,
    ativo     boolean not null,
    nome      varchar(60) not null,
    documento varchar(60)
);

create table pessoa_foto_base64 (
    id          bigserial primary key,
    id_pessoa   bigint not null references pessoa(id) on delete cascade,
    foto_base64 text
);

create table pessoa_foto_binary (
    id           bigserial primary key,
    id_pessoa    bigint not null references pessoa(id) on delete cascade,
    foto_binary  bytea,
    nome_arquivo varchar(255),
    extensao     varchar(10)
);
