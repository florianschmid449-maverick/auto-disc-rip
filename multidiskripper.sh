#!/bin/bash

# =========================================
# Multi-Disc Automated DVD/Blu-ray Ripper
# =========================================

DVD_DEVICE="/dev/cdrom"
DESKTOP="$HOME/Desktop"

# Check ddrescue installation
if ! command -v ddrescue &>/dev/null; then
    echo "🛠 Installing ddrescue..."
    sudo apt update && sudo apt install -y gddrescue
fi

echo "🎬 Multi-disc ripper started. Insert a disc to begin."

while true; do
    # Wait for disc
    echo "📀 Waiting for disc to be inserted..."
    while [ ! -b "$DVD_DEVICE" ]; do
        sleep 2
    done

    # Detect disc type
    DISC_TYPE=$(blkid "$DVD_DEVICE" 2>/dev/null | grep -o "iso9660")
    if [ "$DISC_TYPE" == "iso9660" ]; then
        BS=2048
        echo "📀 DVD detected"
    else
        BS=1M
        echo "📀 Blu-ray or unknown disc detected"
    fi

    # Generate filename with timestamp
    DATE_STR=$(date +%Y%m%d_%H%M%S)
    BASE_NAME="disc_rip_$DATE_STR"
    FILENAME="$BASE_NAME.iso"
    COUNTER=1
    while [ -e "$DESKTOP/$FILENAME" ]; do
        FILENAME="${BASE_NAME}_$COUNTER.iso"
        ((COUNTER++))
    done
    OUTPUT_FILE="$DESKTOP/$FILENAME"
    LOG_FILE="$DESKTOP/${FILENAME}.log"

    # Check free space
    DISC_SIZE=$(blockdev --getsize64 "$DVD_DEVICE" 2>/dev/null || echo 4700000000)
    FREE_SPACE=$(df --output=avail "$DESKTOP" | tail -1)
    FREE_SPACE=$((FREE_SPACE * 1024))
    if [ "$FREE_SPACE" -lt "$DISC_SIZE" ]; then
        echo "❌ Not enough free space. Skipping disc."
        sudo eject "$DVD_DEVICE"
        continue
    fi

    # Start ripping
    echo "⏳ Ripping to $OUTPUT_FILE..."
    sudo ddrescue -b "$BS" -n "$DVD_DEVICE" "$OUTPUT_FILE" "$LOG_FILE"
    sudo ddrescue -b "$BS" -r 3 "$DVD_DEVICE" "$OUTPUT_FILE" "$LOG_FILE"

    # SHA256 verification
    ISO_SUM=$(sha256sum "$OUTPUT_FILE" | awk '{print $1}')
    echo "✅ Ripping complete. SHA256: $ISO_SUM"

    # Mount ISO
    MOUNT_DIR="$DESKTOP/${FILENAME%.iso}_mount"
    mkdir -p "$MOUNT_DIR"
    sudo mount -o loop "$OUTPUT_FILE" "$MOUNT_DIR"
    echo "📂 ISO mounted at $MOUNT_DIR"

    # Eject disc
    sudo eject "$DVD_DEVICE"
    echo "📀 Disc ejected."

    # Ask if user wants to rip another disc
    read -p "Do you want to rip another disc? (y/n): " NEXT
    if [[ "$NEXT" != "y" && "$NEXT" != "Y" ]]; then
        echo "🎉 Multi-disc ripping session completed."
        break
    fi
done

