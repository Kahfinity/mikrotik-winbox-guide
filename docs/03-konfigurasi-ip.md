# 🌐 03 — Konfigurasi IP Address

> **Level:** 🟢 Dasar | **Estimasi Waktu:** 20 menit | [← Kembali ke README](../README.md)

---

## Topologi Jaringan

```
Internet (ISP)
      │
   [Modem/ONT]
      │ IP Publik / IP dari ISP
   [ether1] ← WAN Interface
   [MikroTik Router]
   [ether2] ← LAN Interface
      │ 192.168.10.1/24
   [Switch]
      │
   [PC/Laptop/HP]
   192.168.10.x
```

---

## Skenario

| Interface | Peran | IP Address | Keterangan |
|-----------|-------|-----------|-----------|
| `ether1` | WAN | `DHCP dari ISP` | Mendapat IP otomatis dari ISP/modem |
| `ether2` | LAN | `192.168.10.1/24` | Gateway untuk client lokal |

---

## Langkah 1 — Beri Nama Interface (Best Practice)

Beri nama yang jelas agar mudah dikenali:
```
Menu: Interfaces
Klik 2x pada ether1 → Name: WAN-ISP → [OK]
Klik 2x pada ether2 → Name: LAN-LOKAL → [OK]
```

---

## Langkah 2 — Tambah IP Address pada Interface LAN

```
Menu: IP → Addresses → [ + ]

Address:   192.168.10.1/24
Network:   (otomatis terisi: 192.168.10.0)
Interface: LAN-LOKAL (ether2)
[OK]
```

**Verifikasi:**
```
Menu: IP → Addresses

Address          Network          Interface
192.168.10.1/24  192.168.10.0     LAN-LOKAL    ✅
```

---

## Langkah 3 — Konfigurasi WAN (IP dari ISP)

### Opsi A: WAN menggunakan DHCP (paling umum)
```
Menu: IP → DHCP Client → [ + ]

Interface:    WAN-ISP (ether1)
Use Peer DNS: ✅ (centang)
Use Peer NTP: ✅ (centang)
Add Default Route: yes
[OK]
```

Status akan berubah menjadi `bound` jika berhasil mendapat IP dari ISP.

### Opsi B: WAN menggunakan IP Statis
```
Menu: IP → Addresses → [ + ]

Address:   203.0.113.10/30    ← IP dari ISP
Interface: WAN-ISP (ether1)
[OK]

# Tambah default route
Menu: IP → Routes → [ + ]
Dst. Address: 0.0.0.0/0
Gateway:      203.0.113.9    ← IP gateway ISP
[OK]
```

---

## Langkah 4 — Setting DNS

```
Menu: IP → DNS → Settings

Servers:          8.8.8.8          ← Google DNS Primary
                  8.8.4.4          ← Google DNS Secondary
Allow Remote Requests: ✅ (centang) ← agar client bisa pakai DNS router
[OK]
```

> **Alternatif DNS:** Cloudflare (1.1.1.1), Cloudflare (1.0.0.1)

---

## Verifikasi Koneksi

### Test ping dari router
```
Menu: Tools → Ping

Ping To: 8.8.8.8
[Start]
```

Output sukses:
```
SEQ HOST           SIZE TTL TIME  STATUS
  0 8.8.8.8        56   118 3ms   
  1 8.8.8.8        56   118 4ms   
  2 8.8.8.8        56   118 3ms   
  sent=3 received=3 packet-loss=0%
```

### Perintah Terminal Equivalen
```bash
# Tambah IP address
/ip address add address=192.168.10.1/24 interface=ether2

# Tambah DHCP client di WAN
/ip dhcp-client add interface=ether1 disabled=no

# Set DNS
/ip dns set servers=8.8.8.8,8.8.4.4 allow-remote-requests=yes

# Test ping
/ping 8.8.8.8 count=4
```

---
*Halaman 3 dari 10 | [Kembali ke README](../README.md) | [Lanjut →](04-dhcp-server-client.md)*
