#!/bin/bash
# DeckShare - Share your screenshots to Discord directly from SteamDeck
# Enforce current directory
CURRENT_DIR="/opt/DeckShare"

# Load .env file
set -o allexport
source $CURRENT_DIR/.env
set +o allexport

# Validate required variables
# Check if the webhook URL was read correctly
if [ -z "$webhook_url" ]; then
    echo "Webhook URL not found in environment"
    exit 1
fi

# Directory to monitor
MONITOR_DIR=$(python3 /opt/DeckShare/steampy/path.py)
echo "Monitor Directory: " $MONITOR_DIR

# Check if the directory exists, if not create it
if [ ! -d "$MONITOR_DIR" ]; then
    echo "Monitor Directory $MONITOR_DIR does not exist, (This is typical if you haven't taken a screenshot yet) creating it..."
    mkdir -p $MONITOR_DIR
    if [ $? -eq 0 ]; then
        echo "Monitor Directory created successfully: $MONITOR_DIR"
    else
        echo "Failed to create Monitor Directory: $MONITOR_DIR"
        exit 1
    fi
fi

# File to save the state
STATE_FILE=$CURRENT_DIR"/monitor.state"

# Function to process a file
process_file() {
  thumbnailSearch="thumbnail"
  # Check to see if this is a thumbnail
  if [[ "$1" == *"$thumbnailSearch"* ]]; then
    # Check to see if thumbnails are enabled
    if [[ "$thumbnails" == "1" ]]; then
      # If enabled, upload, otherwise skip
      upload_file $1
    fi
  else
    upload_file $1
  fi
}

upload_file() {
  # File to be uploaded
  filename=$1

  # Check if the file exists
  if [ ! -f "$filename" ]; then
      echo "File $filename does not exist"
      exit 1
  fi

  # Send the file using curl
  curl -F "content=Here is the latest screenshot" -F "file=@$filename" $webhook_url

  # Check the exit status of curl for success or failure
  if [ $? -eq 0 ]; then
      echo "Successfully uploaded $filename to Discord"
  else
      echo "Failed to upload $filename to Discord"
  fi
}

# State file handling
if [ -f "$STATE_FILE" ]; then
  LAST_FILE=$(cat "$STATE_FILE")
else
  touch $STATE_FILE
  if [ $? -ne 0 ]; then
    echo "Failed to create state file $STATE_FILE"
    exit 1
  fi
  LAST_FILE=$(cat "$STATE_FILE")
fi

# Process the directory using inotifywait if it exists
if command -v inotifywait >/dev/null 2>&1; then
    # inotifywait exists, use it to monitor the directory
    inotifywait -m -e create --format '%w%f' "$MONITOR_DIR" | while read FILE_CHANGED; do
        if [ "$FILE_CHANGED" != "$LAST_FILE" ]; then
            process_file "$FILE_CHANGED"
            echo "$FILE_CHANGED" > "$STATE_FILE"
            LAST_FILE="$FILE_CHANGED"
        fi
    done
else
    while true; do
        for FILE_CHANGED in $(find "$MONITOR_DIR" -type f -newer "$STATE_FILE"); do
            if [ "$FILE_CHANGED" != "$LAST_FILE" ]; then
                process_file "$FILE_CHANGED"
                echo "$FILE_CHANGED" > "$STATE_FILE"
                LAST_FILE="$FILE_CHANGED"
            fi
        done
        sleep 5
    done
fi
