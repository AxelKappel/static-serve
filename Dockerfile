FROM rust

RUN USER=root cargo new --bin static-serve
WORKDIR /static-serve

COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml

RUN cargo fetch

COPY ./src ./src

RUN cargo build --release
COPY config.toml ./config.toml

COPY start.sh ../bin/start
RUN chmod u+x ../bin/start

CMD ["start"]