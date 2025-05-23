#!/bin/bash
set -e

echo "Current directory: $(pwd)"
echo "Files in real_estate/settings/:"
ls -la src/real_estate/settings/

# Verify settings file exists
SETTINGS_FILE="src/real_estate/settings/development.py"
if [ ! -f "$SETTINGS_FILE" ]; then
  echo "Error: Missing development.py at $SETTINGS_FILE" >&2
  exit 1
fi

# Rest of your script...