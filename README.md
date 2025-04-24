# Minimal RTMP Server

Receives RTMP stream (e.g., from Pi using `stream.sh`) and serves it to RTMP clients (e.g., VLC).

## Running

**Docker:**
```bash
docker-compose up --build
# RTMP URL: rtmp://localhost:1936/live/[stream-key]
```

**Local Dev:**
```bash
pnpm install
pnpm dev
# RTMP URL: rtmp://localhost:1935/live/[stream-key]
```

(Optional `.env` for local dev: `PORT=3000`, `NODE_ENV=development`)

## Notes

- Requires Node.js, pnpm, Docker.
- Client (e.g., Pi) needs to send stream (see `stream.sh`). 