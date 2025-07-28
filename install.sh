#!/bin/bash
#Needs Better Format and colors

set -e

# --- Build the Vue.js Project ---
echo "Building the theme..."
npm run build

# --- Installation ---
THEME_DIR="/usr/share/web-greeter/themes/lightdm-frost-light"
LIGHTDM_CONFIG_FILE="/etc/lightdm/lightdm.conf"

# Check for root privileges
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Please use sudo." >&2
    exit 1
fi

echo "Installing theme to $THEME_DIR..."

# Remove old directory if it exists
if [ -d "$THEME_DIR" ]; then
    rm -rf "$THEME_DIR"
fi

# Create theme directory and copy files
mkdir -p "$THEME_DIR"
# The 'dist' directory contains the built theme, so we copy its contents
cp -r dist/* "$THEME_DIR"

# --- Configuration ---
echo "Configuring LightDM to use nody-greeter..."

# Ensure the lightdm config file exists
if [ ! -f "$LIGHTDM_CONFIG_FILE" ]; then
    echo "Error: Configuration file $LIGHTDM_CONFIG_FILE not found." >&2
    echo "Please ensure LightDM is installed correctly." >&2
    exit 1
fi

# Set the greeter session to nody-greeter under [Seat:*]
# This logic is more robust: it finds the [Seat:*] section and either
# replaces the existing greeter-session line or adds it if it's not there.
if grep -q "^[
Seat:*
]" "$LIGHTDM_CONFIG_FILE"; then
    # [Seat:*] section exists, now check for greeter-session
    if grep -q "^greeter-session=" "$LIGHTDM_CONFIG_FILE"; then
        # It exists, so replace it
        sed -i 's/^greeter-session=.*/greeter-session=nody-greeter/' "$LIGHTDM_CONFIG_FILE"
    else
        # It doesn't exist, so add it under the seat config
        sed -i '/^[
Seat:*
]/a greeter-session=nody-greeter' "$LIGHTDM_CONFIG_FILE"
    fi
else
    # [Seat:*] section does not exist, so append it to the file
    echo -e "\n[
Seat:*
]\ngreeter-session=nody-greeter" >> "$LIGHTDM_CONFIG_FILE"
fi

echo ""
echo "Installation complete!"
echo "The theme 'lightdm-frost' has been installed."
echo ""
echo "IMPORTANT: Before restarting LightDM, please manually verify that 'nody-greeter' is installed and functional."
echo "You can then restart the lightdm service (e.g., 'sudo systemctl restart lightdm') or reboot."

exit 0
