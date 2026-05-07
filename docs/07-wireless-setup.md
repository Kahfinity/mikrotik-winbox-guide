# 📶 07 — Wireless (WiFi) Setup

> **Level:** 🟡 Menengah | **Estimasi Waktu:** 25 menit | [← Kembali ke README](../README.md)

> ⚠️ **Catatan:** Menu Wireless hanya muncul jika router memiliki radio WiFi (misal: hAP, RB951, dll.)

---

## Topologi WiFi

```
Internet → [ether1 WAN] → MikroTik → [wlan1 AP] → Perangkat WiFi
                                   → [ether2 LAN] → PC via kabel
```

---

## A. Konfigurasi Access Point (WiFi Hotspot Sederhana)

### Langkah 1: Aktifkan Interface Wireless

```
Menu: Wireless → WiFi Interfaces

Klik 2x pada wlan1

Tab [Wireless]:
  Mode:          ap bridge          ← mode Access Point
  Band:          2GHz-B/G/N         ← atau 5GHz-A/N/AC untuk dual band
  Channel Width: 20/40MHz HT Above
  Frequency:     auto               ← atau pilih channel (1,6,11 untuk 2.4GHz)
  SSID:          Kantor-WiFi        ← nama WiFi
  
[OK]
```

### Langkah 2: Tambah Keamanan (Password WiFi)

```
Menu: Wireless → Security Profiles → [ + ]

Name:                wifi-password
Mode:                dynamic keys
Authentication Types: ✅ WPA2 PSK
Unicast Ciphers:     ✅ aes ccm
Group Ciphers:       ✅ aes ccm
WPA2 Pre-Shared Key: P@ssw0rdWiFi123   ← password WiFi
[OK]
```

**Terapkan ke interface:**
```
Wireless → WiFi Interfaces → wlan1 → Tab [Wireless]
Security Profile: wifi-password
[OK]
```

### Langkah 3: Bridge WiFi ke LAN (Agar WiFi Dapat IP DHCP)

```
Menu: Bridge → [ + ]
Name: bridge-local
[OK]

Menu: Bridge → Ports → [ + ]
Interface: ether2    → Bridge: bridge-local → [OK]
Interface: wlan1     → Bridge: bridge-local → [OK]
```

**Pindahkan IP dari ether2 ke bridge:**
```
Menu: IP → Addresses
Hapus IP 192.168.10.1/24 dari ether2
Tambah:  192.168.10.1/24 → Interface: bridge-local
```

**Update DHCP Server:**
```
Menu: IP → DHCP Server
Edit dhcp1 → Interface: bridge-local
[OK]
```

---

## B. Konfigurasi WiFi Multi-SSID

Buat 2 SSID berbeda (contoh: Staff & Guest):

### Buat Virtual AP untuk Guest

```
Menu: Wireless → WiFi Interfaces → [ + ] → Virtual

Master Interface: wlan1
SSID:             Tamu-WiFi
Security Profile: guest-profile   ← buat security profile terpisah
[OK]
```

### Isolasi Guest dari LAN Utama

```
# Buat bridge terpisah untuk guest
Menu: Bridge → [ + ]
Name: bridge-guest

# Tambah port
Bridge → Ports → [ + ]
Interface: wlan2 (virtual AP) → Bridge: bridge-guest

# Tambah IP untuk guest network
IP → Addresses: 192.168.20.1/24 → Interface: bridge-guest

# Buat DHCP Server untuk guest
IP → DHCP Server → Setup → Interface: bridge-guest
Range: 192.168.20.2-192.168.20.100
```

---

## C. Wireless Security Best Practices

| Pengaturan | Rekomendasi | Hindari |
|-----------|-------------|---------|
| Mode keamanan | WPA2 / WPA3 | WEP, Open |
| Password | Min 12 karakter, campuran | 12345678 |
| SSID | Nama netral | Jangan cantumkan nama/alamat |
| Channel | 1, 6, atau 11 (2.4GHz) | Auto jika ada interferensi |
| TX Power | Sesuai kebutuhan | Jangan set max tanpa perlu |

---

## D. Cek Perangkat WiFi yang Terhubung

```
Menu: Wireless → Registration Table

MAC Address        Signal    TX Rate   RX Rate   Uptime
AA:BB:CC:DD:EE:01  -65 dBm   54Mbps    54Mbps    01:23:45
AA:BB:CC:DD:EE:02  -72 dBm   36Mbps    36Mbps    00:05:12
```

> 💡 **Signal kualitas:** -50 dBm (sangat baik) | -70 dBm (baik) | -80 dBm (lemah) | < -85 dBm (buruk)

---

## Perintah Terminal Equivalen

```bash
# Konfigurasi wireless AP
/interface wireless set wlan1 mode=ap-bridge ssid="Kantor-WiFi" band=2ghz-b/g/n disabled=no

# Buat security profile
/interface wireless security-profiles add name=wifi-password mode=dynamic-keys \
  authentication-types=wpa2-psk wpa2-pre-shared-key="P@ssw0rdWiFi123"

# Terapkan security profile
/interface wireless set wlan1 security-profile=wifi-password

# Buat bridge
/interface bridge add name=bridge-local
/interface bridge port add interface=ether2 bridge=bridge-local
/interface bridge port add interface=wlan1 bridge=bridge-local

# Cek perangkat terhubung
/interface wireless registration-table print
```

---
*Halaman 7 dari 10 | [← Sebelumnya](06-firewall-dasar.md) | [Kembali ke README](../README.md) | [Lanjut →](08-bandwidth-management.md)*
