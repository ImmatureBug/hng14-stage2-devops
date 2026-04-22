# HNG14 Stage 2: Job Processing System

This is a simple job processing system with three moving parts: a Node.js frontend 
where you submit jobs, a FastAPI backend that creates and tracks them, and a Python 
worker that actually processes them. Redis sits in the middle as the queue. Everything 
runs in Docker.

## What You Need Before Starting

- Docker 24 or newer
- Docker Compose v2
- Git

## Getting It Running

Clone the repo:
```bash
git clone https://github.com/ImmatureBug/hng14-stage2-devops
cd hng14-stage2-devops
```

Set up your environment:
```bash
cp .env.example .env
```

Start everything:
```bash
docker compose up -d --build
```

## How to Know It Worked

```bash
docker compose ps
```

You want all four services — `redis`, `api`, `worker`, `frontend` — showing as `healthy`. 
If any of them show `starting` just wait a few seconds and run it again.

Once they're all healthy, open `http://localhost:3000` in your browser, hit 
**Submit New Job** and watch the status go from `queued` to `completed`.

## Shutting Down

```bash
docker compose down
```

## Ports

| Service  | Port | Notes |
|----------|------|-------|
| frontend | 3000 | This is the only one you access from your browser |
| api      | 8000 | Internal only |
| worker   | —    | No port, just reads from the queue |
| redis    | —    | Not exposed outside Docker |
