# 📡 04 — DHCP Server & Client

> **Level:** 🟢 Dasar | **Estimasi Waktu:** 20 menit | [← Kembali ke README](../README.md)

---

## Apa Itu DHCP?

**DHCP (Dynamic Host Configuration Protocol)** adalah protokol yang secara otomatis memberikan konfigurasi IP kepada perangkat yang terhubung ke jaringan, meliputi:
- IP Address
- Subnet Mask
- Default Gateway
- DNS Server

Tanpa DHCP, setiap perangkat harus dikonfigurasi IP-nya secara manual.

---

## A. Konfigurasi DHCP Server (untuk Client LAN)

### Metode Cepat: Menggunakan DHCP Setup Wizard

```
Menu: IP → DHCP Server → DHCP Setup

Step 1 - Select Interface:
  DHCP Server Interface: LAN-LOKAL (ether2)
  [Next]

Step 2 - DHCP Address Space:
  192.168.10.0/24    ← (otomatis terisi)
  [Next]

Step 3 - Gateway:
  192.168.10.1       ← (otomatis terisi)
  [Next]

Step 4 - IP Range untuk Client:
  192.168.10.2 - 192.168.10.254
  [Next]

Step 5 - DNS Server:
  8.8.8.8, 8.8.4.4
  [Next]

Step 6 - Lease Time:
  00:10:00    ← 10 menit (testing) atau 1d (production)
  [Next]

[Finish] ✅
```

---

### Verifikasi DHCP Server

```
Menu: IP → DHCP Server

Name        Interface    Address Pool         Lease Time
dhcp1       LAN-LOKAL    dhcp_pool1           10m         ← aktif ✅
```

### Cek DHCP Pool
```
Menu: IP → Pool

Name         Ranges
dhcp_pool1   192.168.10.2-192.168.10.254
```

---

## B. DHCP Leases — Monitor Client yang Terhubung

```
Menu: IP → DHCP Server → Leases

MAC Address        Address         Hostname      Status
AA:BB:CC:DD:EE:01  192.168.10.2   LAPTOP-ANDI   bound ✅
AA:BB:CC:DD:EE:02  192.168.10.3   HP-BUDI       bound ✅
AA:BB:CC:DD:EE:03  192.168.10.10  -             bound ✅
```

---

## C. IP Binding (IP Statis per MAC Address)

Agar client tertentu selalu mendapat IP yang sama:

```
Menu: IP → DHCP Server → Leases

1. Klik kanan pada client yang ingin di-bind
2. Pilih [Make Static]

Atau tambah manual:
Menu: IP → DHCP Server → Leases → [ + ]

Address:     192.168.10.100
MAC Address: AA:BB:CC:11:22:33
Client ID:   (opsional)
Comment:     PC-Server-Lokal
[OK]
```

---

## D. DHCP Client di Interface WAN

Sudah dikonfigurasi di bagian IP Address, namun ini untuk referensi:

```
Menu: IP → DHCP Client → [ + ]

Interface:         WAN-ISP (ether1)
Use Peer DNS:      ✅
Use Peer NTP:      ✅  
Add Default Route: yes
[OK]
```

Cek status:
```
Interface   IP Address      Gateway        Status
ether1      203.0.113.10/30 203.0.113.9   bound ✅
```

---

## Perintah Terminal Equivalen

```bash
# Buat DHCP pool
/ip pool add name=dhcp_pool1 ranges=192.168.10.2-192.168.10.254

# Buat DHCP server
/ip dhcp-server add name=dhcp1 interface=ether2 address-pool=dhcp_pool1 lease-time=10m disabled=no

# Buat DHCP network (gateway & DNS)
/ip dhcp-server network add address=192.168.10.0/24 gateway=192.168.10.1 dns-server=8.8.8.8,8.8.4.4

# IP binding statis
/ip dhcp-server lease add address=192.168.10.100 mac-address=AA:BB:CC:11:22:33 comment="PC-Server"

# Cek leases
/ip dhcp-server lease print
```

---

## Troubleshooting DHCP

| Masalah | Kemungkinan Penyebab | Solusi |
|---------|---------------------|--------|
| Client tidak dapat IP | DHCP server belum aktif | Cek status di IP → DHCP Server |
| Client dapat IP 169.254.x.x | DHCP server tidak menjawab | Cek interface DHCP sesuai port LAN |
| IP range habis | Pool terlalu kecil | Perluas range pool |
| Client dapat IP salah jaringan | Pool network salah | Cek konfigurasi DHCP Network |

---
*Halaman 4 dari 10 | [← Sebelumnya](03-konfigurasi-ip.md) | [Kembali ke README](../README.md) | [Lanjut →](05-nat-internet-sharing.md)*
