# Secure DNS for Ubuntu (DNS-over-TLS)

This repository contains a simple Bash script to enable **DNS-over-TLS** on Ubuntu-based systems using `systemd-resolved`.

By enabling encrypted DNS, your system will send all DNS queries securely, protecting your privacy from ISPs or network observers.

---

## 🔒 Why Secure DNS Matters

Without encryption, DNS queries are sent in plain text. This allows third parties (e.g. ISPs, network admins) to:

- Monitor what domains you visit
- Log or censor access to certain websites
- Redirect or spoof DNS responses

Using DNS-over-TLS solves these problems by encrypting DNS traffic between your device and the DNS server.

---

## 🖥️ Supported Systems

- ✅ Ubuntu 20.04 / 22.04
- ✅ Debian 11+
- ✅ Any system using `systemd-resolved`

> ⚠️ Not compatible with older or non-systemd-based distros.

---

## 📦 Requirements

- `systemd-resolved` must be active
- You must run the script with `sudo`
- Internet access

---

## ⚙️ What This Script Does

- Backs up `/etc/systemd/resolved.conf` to `.backup`
- Rewrites `resolved.conf` to use encrypted DNS (Cloudflare by default)
- Enables `DNSOverTLS=yes`
- Restarts the DNS service

---

## 🚀 How to Use

### Download the script

```bash

chmod +x secure-dns.sh


sudo ./secure-dns.sh

resolvectl status
```
## 🧾 Configuration Used
[Resolve]
DNS=1.1.1.1
FallbackDNS=1.0.0.1
DNSOverTLS=yes
## To restore the original DNS settings:


sudo cp /etc/systemd/resolved.conf.backup /etc/systemd/resolved.conf
sudo systemctl restart systemd-resolved