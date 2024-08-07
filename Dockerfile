FROM rust:latest AS builder
WORKDIR /opt/temporal_server
COPY . .
RUN cargo build --release

FROM debian:bookworm
RUN apt-get update && apt-get install -y build-essential git && rm -rf /var/lib/apt/lists/*
RUN which gcc
RUN git clone https://github.com/TheRandonauts/temporal /opt/temporal
WORKDIR /opt/temporal
RUN sed -i 's/sudo//g' make.sh
RUN chmod +x make.sh && ./make.sh
RUN mv result/Linux/temporal /usr/local/bin/temporal
RUN rm -R build
RUN rm -R result

COPY --from=builder /opt/temporal_server/target/release/temporal_server /usr/local/bin/temporal_server

CMD ["temporal_server"]