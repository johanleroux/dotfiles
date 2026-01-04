#!/usr/bin/env bash

KEYRING_DIR="$HOME/.local/share/keyrings"
KEYRING_FILE="$KEYRING_DIR/Default_keyring.keyring"
DEFAULT_FILE="$KEYRING_DIR/default"

mkdir -p $KEYRING_DIR

# Create default keyring file if it doesn't exist
if [ -f "$KEYRING_FILE" ] && [ -f "$DEFAULT_FILE" ]; then
  echo "Default keyring already exists. Skipping creation."
  exit 0
fi

echo "Creating default keyring..."
cat << EOF | tee "$KEYRING_FILE"
[keyring]
display-name=Default keyring
ctime=$(date +%s)
mtime=0
lock-on-idle=false
lock-after=false
EOF

echo "Setting default keyring..."
cat << EOF | tee "$DEFAULT_FILE"
Default_keyring
EOF

chmod 700 "$KEYRING_DIR"
chmod 600 "$KEYRING_FILE"
chmod 644 "$DEFAULT_FILE"
