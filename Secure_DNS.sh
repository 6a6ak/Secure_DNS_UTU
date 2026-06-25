#!/bin/bash

# Fail fast on errors, undefined variables, and pipe failures
set -euo pipefail

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
  echo "⚠️  Please run this script with sudo."
  exit 1
fi

# Verify that systemd-resolved exists and is active
if ! systemctl list-unit-files | grep -q "systemd-resolved"; then
  echo "❌ systemd-resolved is not installed on this system."
  echo "   Install it first:  sudo apt install systemd-resolved"
  exit 1
fi

if ! systemctl is-active --quiet systemd-resolved; then
  echo "⚠️  systemd-resolved is not running. Attempting to start it..."
  systemctl start systemd-resolved || {
    echo "❌ Failed to start systemd-resolved."
    exit 1
  }
fi

# Make sure systemd-resolved is enabled so the config survives reboots
if ! systemctl is-enabled --quiet systemd-resolved; then
  systemctl enable systemd-resolved || {
    echo "⚠️  Could not enable systemd-resolved for boot. You may need to run:"
    echo "   sudo systemctl enable systemd-resolved"
  }
fi

echo "🔧 Enabling DNS over TLS using Cloudflare DNS..."

# Backup the existing resolved.conf file
# Only take a backup if one doesn't already exist, so re-running the script
# never overwrites the original saved configuration.
BACKUP="/etc/systemd/resolved.conf.backup"
if [[ ! -f "$BACKUP" ]]; then
  cp /etc/systemd/resolved.conf "$BACKUP" || {
    echo "❌ Failed to create backup of resolved.conf. Aborting to keep your config safe."
    exit 1
  }
  echo "📁 Original configuration backed up to $BACKUP"
else
  echo "📁 Backup already exists at $BACKUP — keeping the original."
fi

# Write new configuration for systemd-resolved
cat << EOF > /etc/systemd/resolved.conf
[Resolve]
DNS=1.1.1.1
FallbackDNS=1.0.0.1
DNSOverTLS=yes
EOF

# Restart systemd-resolved service to apply changes
echo "🔄 Restarting systemd-resolved..."
systemctl restart systemd-resolved || {
  echo "❌ Failed to restart systemd-resolved."
  echo "   Restore your original config with:"
  echo "   sudo cp $BACKUP /etc/systemd/resolved.conf && sudo systemctl restart systemd-resolved"
  exit 1
}

# Show current DNS configuration
echo "✅ Configuration applied. Current DNS status:"
resolvectl status | grep "DNS"

echo "🎉 Your DNS traffic is now encrypted using DNS-over-TLS."

# Changes are already active because we restarted systemd-resolved above.
# A reboot is NOT required, but is recommended to clear DNS caches and make
# sure every running application re-syncs with the new resolver.
echo "ℹ️  Changes are active right now — no reboot required."
echo "   To clear DNS caches and ensure all apps pick up the new DNS, you can optionally reboot:"
echo "      sudo reboot"
