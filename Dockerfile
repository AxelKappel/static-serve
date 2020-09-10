FROM rust

# create a new empty shell project
RUN USER=root cargo new --bin static-serve
WORKDIR /static-serve

# copy over your manifests
COPY ./Cargo.lock ./Cargo.lock
COPY ./Cargo.toml ./Cargo.toml

# this build step will cache your dependencies
RUN cargo build --release
RUN rm src/*.rs

# copy your source tree
COPY ./src ./src

# build for release
RUN rm ./target/release/deps/*
RUN cargo build --release

# copy server config file
COPY config.toml ./config.toml

# copy start bash script
COPY start.sh ./start.sh

# set the startup command to run your binary
CMD ["./target/release/static-serve"]