#!/bin/bash

# This script demonstrates how to securely store your sudo password in a
# configuration file and use it to run commands non-interactively.

# --- ⚠️ SECURITY WARNING ---
# Storing your password in a configuration file, even with restricted
# permissions, is a major security risk. It should be avoided in production
# environments.
#
# A safer alternative is to configure the `/etc/sudoers` file to allow
# specific commands to be run without a password.
#
# Example `/etc/sudoers` entry:
# your_username ALL=(ALL) NOPASSWD: /path/to/your/command
#
# This allows 'your_username' to run '/path/to/your/command' with sudo
# without a password. Consult your system administrator before making
# changes to this file.
#
# This script is provided for demonstration purposes only.
# USE AT YOUR OWN RISK.

# --- Script ---
CONFIG_FILE="$HOME/.claude_code_config"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Error: Configuration file not found at $CONFIG_FILE"
  echo "Please create it and add your SUDO_PASSWORD."
  exit 1
fi

# Load the configuration file
source "$CONFIG_FILE"

if [ -z "$SUDO_PASSWORD" ]; then
  echo "Error: SUDO_PASSWORD is not set in $CONFIG_FILE"
  exit 1
fi

echo "--- Running command with sudo password from config file ---"

# The 'sudo -S' command reads the password from standard input.
echo "$SUDO_PASSWORD" | sudo -S echo "Sudo command executed successfully!"

echo ""
echo "To adapt this for your use case:"
echo "1. Understand the security risks mentioned above."
echo "2. If you still choose to proceed, create and secure the config file."
echo "3. Add 'source $CONFIG_FILE' to the beginning of your script."
echo "4. Use 'echo \"\$SUDO_PASSWORD\" | sudo -S your_command' to run sudo commands."
