#!/bin/bash

# This is an example script to demonstrate how to run commands with sudo
# non-interactively, without being prompted for a password or confirmation.

# --- ⚠️ SECURITY WARNING ---
# Storing your password in a script or environment variable is a major
# security risk. It should be avoided in production environments.
#
# A safer alternative is to configure the `/etc/sudoers` file to allow
# specific commands to be run without a password.
#
# Example `/etc/sudoers` entry:
# your_username ALL=(ALL) NOPASSWD: /usr/bin/apt-get
#
# This allows 'your_username' to run 'apt-get' with sudo without a password.
# Consult your system administrator before making changes to this file.
#
# This script is provided for demonstration purposes only.
# USE AT YOUR OWN RISK.

# --- Configuration ---
if [ -z "$SUDO_PASSWORD" ]; then
  echo "Error: SUDO_PASSWORD environment variable is not set."
  echo "Usage: SUDO_PASSWORD=\"your_password\" ./scripts/non_interactive_sudo_example.sh"
  exit 1
fi

echo "--- Running command with non-interactive sudo ---"

# The 'sudo -S' command reads the password from standard input.
echo "$SUDO_PASSWORD" | sudo -S apt-get update

echo ""
echo "--- Running a command that asks for confirmation ---"

# Many commands have a '-y' or '--yes' flag to automatically answer "yes"
# to any prompts.
echo "$SUDO_PASSWORD" | sudo -S apt-get install -y some-package

echo ""
echo "--- How to adapt this for your use case ---"
echo "1. Understand the security risks mentioned above."
echo "2. If you still choose to proceed, find the 'sudo' command in your script."
echo "3. Prepend 'echo \"$SUDO_PASSWORD\" | sudo -S' to that command."
echo "4. Find commands that ask for confirmation and add a '-y' or '--yes' flag."
echo "5. Run your main script with the SUDO_PASSWORD environment variable set."
