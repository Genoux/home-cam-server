# Client Scripts

This directory contains scripts and configurations for the Linux/Raspberry Pi client that connects to the home-cam-server.

## Directory Structure

```
clients/
└── linux/               # Linux/Raspberry Pi client files
    ├── config/          # Linux-specific configurations
    │   └── webcam-stream.service
    ├── scripts/         # Linux shell scripts
    │   └── stream-webcam.sh
    └── install.sh       # Linux installation script
```

## Linux/Raspberry Pi Client

The Linux client uses shell scripts and systemd services. Files are located in `linux/`:

- `scripts/stream-webcam.sh`: Main streaming script. Reads configuration from environment variables or defaults.
- `config/webcam-stream.service`: Systemd service configuration. Loads environment variables from a file.
- `install.sh`: Installation script. Run with `sudo` to set up the service.

**Configuration using Environment Variables:**

The `stream-webcam.sh` script is designed to read configuration from environment variables. If an environment variable is not set, it uses a default value defined in the script.

**1. Running Manually:**

You can override defaults by setting variables before running the script:

```bash
# Example: Set RTMP host and stream key for this command
RTMP_HOST="10.0.0.5" STREAM_KEY="garage_cam" sudo ./scripts/stream-webcam.sh

# Example: Export variables for the current session
export RTMP_HOST="10.0.0.5"
export STREAM_KEY="garage_cam"
sudo ./scripts/stream-webcam.sh 
```

**2. Configuring the Systemd Service (Recommended):**

The systemd service (`webcam-stream.service`) is configured to load variables from an environment file located at `/etc/webcam-stream.conf`.

- **Location:** `/etc/webcam-stream.conf`
- **Creation:** The `install.sh` script automatically creates this file with default values if it doesn't exist.
- **Format:** Standard shell variable assignments (e.g., `VARIABLE=value`). Lines starting with `#` are comments.

  ```ini
  # /etc/webcam-stream.conf Example
  # Configuration for Webcam Stream Service
  
  RTMP_HOST=192.168.86.31
  RTMP_PORT=1936
  RTMP_APP=live
  STREAM_KEY=pi_camera_1 # Customize this for each Pi
  
  # Optional: Override video settings if needed
  # RESOLUTION=1280x720
  # FRAMERATE=25
  ```

- **Permissions:** The installation script sets permissions to `600` (read/write only for root) for security.
- **Applying Changes:** After editing `/etc/webcam-stream.conf`, you **must restart the service** for the changes to take effect:
  ```bash
  sudo systemctl restart webcam-stream.service
  ```

## Usage

1. Copy the `linux` directory to your client device (Raspberry Pi).
2. Open a terminal, navigate to the `linux` directory.
3. Run `sudo ./install.sh`.
4. Edit `/etc/webcam-stream.conf` as needed (e.g., set a unique `STREAM_KEY`).
5. Restart the service: `sudo systemctl restart webcam-stream.service`.

## Development

These scripts are kept in the server repository for development purposes but are meant to be deployed to Linux/Raspberry Pi client devices. 