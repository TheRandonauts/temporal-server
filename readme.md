# Temporal Server

Docker container that pulls and builds [Temporal](https://github.com/TheRandonauts/temporal) from source and serves its entropy on `localhost:3333/temporal/<bytes>` with a minimal Rust based http server.

## Installation

```
docker compose build
docker compose up
```
