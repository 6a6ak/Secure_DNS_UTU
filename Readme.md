# Secure DNS for Ubuntu (DNS-over-TLS)

[![Latest Release](https://img.shields.io/github/v/release/6a6ak/Secure_DNS_UTU?style=flat-square&label=Release)](https://github.com/6a6ak/Secure_DNS_UTU/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=flat-square)](https://opensource.org/licenses/MIT)
[![Bash](https://img.shields.io/badge/Made%20with-Bash-4EAA25.svg?style=flat-square&logo=gnu-bash&logoColor=white)](https://www.gnu.org/software/bash/)
[![Stars](https://img.shields.io/github/stars/6a6ak/Secure_DNS_UTU?style=flat-square)](https://github.com/6a6ak/Secure_DNS_UTU/stargazers)

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
chmod +x Secure_DNS.sh


sudo ./Secure_DNS.sh

resolvectl status
```
## 🧾 Configuration Used
[Resolve]
DNS=1.1.1.1
FallbackDNS=1.0.0.1
DNSOverTLS=yes
## To restore the original DNS settings:

```bash
sudo cp /etc/systemd/resolved.conf.backup /etc/systemd/resolved.conf
sudo systemctl restart systemd-resolved

```
