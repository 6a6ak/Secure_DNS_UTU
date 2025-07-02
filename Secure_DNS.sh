#!/bin/bash

# Check if the script is run as root
if [[ $EUID -ne 0 ]]; then
  echo "⚠️  Please run this script with sudo."
  exit 1
fi

echo "🔧 Enabling DNS over TLS using Cloudflare DNS..."

# Backup the existing resolved.conf file
cp /etc/systemd/resolved.conf /etc/systemd/resolved.conf.backup

# Write new configuration for systemd-resolved
cat << EOF > /etc/systemd/resolved.conf
[Resolve]
DNS=1.1.1.1
FallbackDNS=1.0.0.1
DNSOverTLS=yes
EOF

# Restart systemd-resolved service to apply changes
echo "🔄 Restarting systemd-resolved..."
systemctl restart systemd-resolved

# Show current DNS configuration
echo "✅ Configuration applied. Current DNS status:"
resolvectl status | grep "DNS"

echo "🎉 Your DNS traffic is now encrypted using DNS-over-TLS."
