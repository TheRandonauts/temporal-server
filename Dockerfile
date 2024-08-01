# Use the official Rust image as the build environment
FROM rust:latest AS builder

# Install musl tools
RUN apt-get update && apt-get install -y musl-tools

# Create a new directory for our project and copy the source code
WORKDIR /usr/src/temporal_server
COPY . .

# Set the target to musl for static linking
RUN rustup target add x86_64-unknown-linux-musl
RUN cargo install --target x86_64-unknown-linux-musl --path .

# Use a minimal image for the final container
FROM debian:buster-slim

# Copy the statically linked binary from the builder stage
COPY --from=builder /usr/src/temporal_server/target/x86_64-unknown-linux-musl/release/temporal_server /usr/local/bin/temporal_server

# Copy the binary executable that generates the hex digits
COPY ./temporal /usr/local/bin/temporal

# Expose the port that the server will run on
EXPOSE 3333

# Set the binary as the entrypoint
CMD ["temporal_server"]
