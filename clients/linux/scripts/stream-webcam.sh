#!/bin/bash

# Configuration (Read from Environment Variables with Defaults)
RTMP_HOST="${RTMP_HOST:-192.168.86.31}"  # Default: 192.168.86.31
RTMP_PORT="${RTMP_PORT:-1936}"         # Default: 1936
RTMP_APP="${RTMP_APP:-live}"           # Default: live
STREAM_KEY="${STREAM_KEY:-webcam}"      # Default: webcam
RTMP_URL="rtmp://${RTMP_HOST}:${RTMP_PORT}/${RTMP_APP}/${STREAM_KEY}"

# Video settings (Read from Environment Variables with Defaults)
RESOLUTION="${RESOLUTION:-640x480}"     # Default: 640x480
FRAMERATE="${FRAMERATE:-30}"          # Default: 30
BITRATE="${BITRATE:-500k}"           # Default: 500k

# Log file
LOG_FILE="${LOG_FILE:-/var/log/webcam_stream.log}" # Default: /var/log/webcam_stream.log

# Function to write logs
write_log() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    local message="[$timestamp] $1"
    echo "$message" | tee -a "$LOG_FILE"
}

# Function to check if FFmpeg is running
check_ffmpeg_running() {
    pgrep ffmpeg > /dev/null
    return $?
}

# Function to stop existing FFmpeg processes
stop_existing_stream() {
    if check_ffmpeg_running; then
        write_log "Stopping existing FFmpeg processes..."
        pkill ffmpeg
        sleep 2
    fi
}

# Function to check available video devices
check_video_devices() {
    write_log "Checking available video devices..."
    
    # Check for v4l2 devices
    if [ -d "/dev/v4l/by-id" ]; then
        write_log "Found v4l2 devices:"
        ls -l /dev/v4l/by-id/ | grep video | while read -r line; do
            write_log "  - $line"
        done
        return 0
    fi
    
    # Check for video devices directly
    if [ -e "/dev/video0" ]; then
        write_log "Found video device: /dev/video0"
        return 0
    fi
    
    write_log "No video devices found!"
    return 1
}

# Function to test if a specific device is available
test_video_device() {
    local device=$1
    write_log "Testing device: $device"
    
    if [ -e "$device" ]; then
        # Test if device is accessible
        if v4l2-ctl --device="$device" --all > /dev/null 2>&1; then
            write_log "Device $device is available and working"
            return 0
        fi
    fi
    
    write_log "Device $device is not available"
    return 1
}

# Function to check network connectivity
check_network() {
    write_log "Checking network connectivity..."
    if ping -c 1 $RTMP_HOST > /dev/null 2>&1; then
        write_log "Network connection to $RTMP_HOST is working"
        return 0
    else
        write_log "No network connection to $RTMP_HOST"
        return 1
    fi
}

# Main streaming function
start_stream() {
    local device=$1
    write_log "Starting new stream with device: $device"

    # Check for hardware acceleration
    if ffmpeg -encoders 2>/dev/null | grep -q h264_omx; then
        write_log "Using hardware acceleration (h264_omx)"
        ENCODER="h264_omx"
    else
        write_log "Using software encoding (libx264)"
        ENCODER="libx264"
    fi

    # Start FFmpeg with appropriate settings
    ffmpeg -f v4l2 \
        -framerate $FRAMERATE \
        -video_size $RESOLUTION \
        -i "$device" \
        -c:v $ENCODER \
        -pix_fmt yuv420p \
        -preset ultrafast \
        -tune zerolatency \
        -profile:v main \
        -b:v $BITRATE \
        -maxrate $BITRATE \
        -bufsize 200k \
        -g 15 \
        -r $FRAMERATE \
        -fflags nobuffer \
        -flags low_delay \
        -f flv \
        "$RTMP_URL" 2>&1 | tee -a "$LOG_FILE"
}

# Main loop
while true; do
    # Check network first
    if ! check_network; then
        write_log "Waiting for network connection..."
        sleep 10
        continue
    fi

    # Set the camera device directly based on v4l2-ctl output
    CAMERA_DEVICE="/dev/video0"
    write_log "Attempting to use camera device: $CAMERA_DEVICE"

    # Check if the specific device exists
    if [ ! -e "$CAMERA_DEVICE" ]; then
        write_log "Configured camera device $CAMERA_DEVICE does not exist! Retrying in 10 seconds..."
        sleep 10
        continue # Skip to the next iteration of the main while loop
    fi

    # Stop any existing streams
    stop_existing_stream

    # Start the stream
    start_stream "$CAMERA_DEVICE"

    # If we get here, the stream ended
    write_log "Stream ended. Restarting in 5 seconds..."
    sleep 5
done