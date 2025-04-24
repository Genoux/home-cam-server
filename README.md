# Home Cam RTMP Server

This project is a simple RTMP (Real-Time Messaging Protocol) server built with Node.js using the `node-media-server` library. It's designed to receive live video streams (e.g., from Raspberry Pi webcam clients) and make them available for viewing with RTMP-compatible players (like VLC).

## Features

*   Receives RTMP streams from clients.
*   Serves RTMP streams to viewers.
*   Configurable RTMP port.
*   Can be run using Docker or directly with Node.js/pnpm.

## Prerequisites

*   **For Docker:** Docker and Docker Compose installed.
*   **For Local Development:** Node.js (check `package.json` for version) and pnpm installed.

## Running the Server

Choose one of the following methods:

**1. Using Docker Compose (Recommended):**

This is the easiest way to get the server running with the correct dependencies and ports exposed.

```bash
# Build and start the service in detached mode
docker-compose up --build -d

# View logs
docker-compose logs -f

# Stop the service
docker-compose down
```

*   The RTMP stream will be available at: `rtmp://<server_ip>:1936/live/<stream_key>` (where `<stream_key>` is defined by the client).
*   Check `docker-compose.yml` for port mappings.

**2. Local Development:**

```bash
# Install dependencies
pnpm install

# Build TypeScript (if needed, check package.json scripts)
# pnpm build 

# Start the development server (check package.json scripts)
pnpm dev 
```

*   The RTMP stream URL will likely be similar to the Docker setup, potentially using port `1935` or as configured by the server script. Check the server's startup logs for details.
*   You might need a `.env` file for local configuration (e.g., `PORT`, `NODE_ENV`).

## Configuration

*   **Docker:** Ports are configured in `docker-compose.yml`.
*   **Local:** Configuration might be handled via environment variables or a config file within the `src` directory. Check the source code for details.

## Client Setup

The client-side scripts (for Raspberry Pi/Linux) responsible for sending the webcam stream to this server are located in a separate repository:

[Link to your home-cam-client repository here](https://github.com/YOUR_USER/home-cam-client) (Replace with the actual link)

Refer to that repository's README for instructions on setting up the streaming clients. 