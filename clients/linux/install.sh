#!/bin/bash

# Linux Installation Script
set -e

# Configuration
INSTALL_PATH="/usr/local/bin"
SERVICE_PATH="/etc/systemd/system"
LOG_PATH="/var/log"

# Create necessary directories
sudo mkdir -p "$INSTALL_PATH"
sudo mkdir -p "$LOG_PATH"

# Copy files
sudo cp "./scripts/stream-webcam.sh" "$INSTALL_PATH/"
sudo cp "./config/webcam-stream.service" "$SERVICE_PATH/"

# Set permissions
sudo chmod +x "$INSTALL_PATH/stream-webcam.sh"
sudo chown root:video "$INSTALL_PATH/stream-webcam.sh"

# Create log file
sudo touch "$LOG_PATH/webcam_stream.log"
sudo chmod 666 "$LOG_PATH/webcam_stream.log"

# Create default environment file if it doesn't exist
ENV_FILE="/etc/webcam-stream.conf"
if [ ! -f "$ENV_FILE" ]; then
    echo "Creating default environment file at $ENV_FILE"
    sudo bash -c "cat > $ENV_FILE" << EOF
# Configuration for Webcam Stream Service
# These values can be overridden here

RTMP_HOST=192.168.86.31
RTMP_PORT=1936
RTMP_APP=live
STREAM_KEY=webcam

#RESOLUTION=640x480
#FRAMERATE=30
#BITRATE=500k
#LOG_FILE=/var/log/webcam_stream.log
EOF
    sudo chown root:root "$ENV_FILE"
    sudo chmod 600 "$ENV_FILE"
else
    echo "Environment file $ENV_FILE already exists, skipping creation."
fi

# Reload systemd and enable service
sudo systemctl daemon-reload
sudo systemctl enable webcam-stream.service
sudo systemctl start webcam-stream.service

echo "Installation complete! The webcam stream service has been installed and started."
echo "You can check the status using: sudo systemctl status webcam-stream.service"
echo "Logs are available at: $LOG_PATH/webcam_stream.log"
echo "Configuration is available at: $ENV_FILE" 