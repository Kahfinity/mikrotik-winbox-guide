# 🔀 05 — NAT & Internet Sharing

> **Level:** 🟢 Dasar | **Estimasi Waktu:** 15 menit | [← Kembali ke README](../README.md)

---

## Apa Itu NAT?

**NAT (Network Address Translation)** memungkinkan banyak perangkat di jaringan lokal berbagi satu IP publik untuk mengakses Internet.

```
[PC: 192.168.10.2]  ─┐
[HP: 192.168.10.3]  ─┤─ [MikroTik] ─ NAT ─ [Internet]
[TV: 192.168.10.4]  ─┘    203.0.113.10 (IP Publik)
```

Tanpa NAT, perangkat lokal tidak bisa akses Internet karena IP private (192.168.x.x) tidak bisa dirutekan di Internet.

---

## Jenis NAT di MikroTik

| Jenis | Chain | Fungsi |
|-------|-------|--------|
| **Masquerade** | srcnat | Internet sharing (paling umum) |
| **SNAT** | srcnat | Source NAT dengan IP statis |
| **DNAT** | dstnat | Port forwarding / redirect |

---

## A. Konfigurasi Masquerade (Internet Sharing)

```
Menu: IP → Firewall → NAT → [ + ]

Tab [General]:
  Chain:          srcnat
  Out. Interface: WAN-ISP (ether1)   ← interface menuju Internet

Tab [Action]:
  Action:         masquerade

[OK]
```

**Verifikasi:**
```
Menu: IP → Firewall → NAT

Chain   Action      Out. Interface
srcnat  masquerade  WAN-ISP          ← ✅ aktif
```

---

## B. Port Forwarding (DNAT) — Akses Server dari Internet

Contoh: Forward port 80 dari Internet ke web server lokal `192.168.10.100`

```
Menu: IP → Firewall → NAT → [ + ]

Tab [General]:
  Chain:           dstnat
  Protocol:        tcp (6)
  Dst. Port:       80
  In. Interface:   WAN-ISP (ether1)

Tab [Action]:
  Action:          dst-nat
  To Addresses:    192.168.10.100
  To Ports:        80

[OK]
```

### Contoh Port Forwarding Umum

| Layanan | Protocol | Port Publik | IP Server Lokal | Port Lokal |
|---------|----------|-------------|----------------|-----------|
| Web HTTP | TCP | 80 | 192.168.10.100 | 80 |
| Web HTTPS | TCP | 443 | 192.168.10.100 | 443 |
| Remote Desktop | TCP | 3389 | 192.168.10.50 | 3389 |
| SSH | TCP | 22 | 192.168.10.100 | 22 |
| FTP | TCP | 21 | 192.168.10.101 | 21 |
| Game Server | UDP | 27015 | 192.168.10.200 | 27015 |

---

## C. Redirect DNS (Transparant)

Paksa semua DNS request ke DNS router:

```
Menu: IP → Firewall → NAT → [ + ]

Tab [General]:
  Chain:    dstnat
  Protocol: tcp (6)
  Dst. Port: 53

Tab [Action]:
  Action:        redirect
  To Ports:      53

[OK]

# Ulangi untuk UDP
Tab [General]:
  Protocol: udp (17)
  Dst. Port: 53
```

---

## Verifikasi Internet Client

Dari PC client yang terhubung ke LAN:
1. Pastikan PC mendapat IP dari DHCP (192.168.10.x)
2. Ping ke gateway: `ping 192.168.10.1`
3. Ping ke Internet: `ping 8.8.8.8`
4. Buka browser → akses website

---

## Perintah Terminal Equivalen

```bash
# Masquerade (Internet sharing)
/ip firewall nat add chain=srcnat out-interface=ether1 action=masquerade comment="Internet Sharing"

# Port forwarding HTTP ke web server
/ip firewall nat add chain=dstnat protocol=tcp dst-port=80 in-interface=ether1 \
  action=dst-nat to-addresses=192.168.10.100 to-ports=80 comment="Forward HTTP ke Web Server"

# Cek semua aturan NAT
/ip firewall nat print
```

---

## Troubleshooting

| Masalah | Kemungkinan Penyebab | Solusi |
|---------|---------------------|--------|
| Client tidak bisa internet | NAT belum dibuat | Tambah rule masquerade |
| NAT ada tapi tidak jalan | Interface WAN salah | Sesuaikan Out. Interface |
| Port forwarding tidak jalan | Firewall memblokir | Tambah rule firewall allow |
| Bisa ping IP tapi tidak bisa browsing | DNS bermasalah | Cek DNS setting |

---
*Halaman 5 dari 10 | [← Sebelumnya](04-dhcp-server-client.md) | [Kembali ke README](../README.md) | [Lanjut →](06-firewall-dasar.md)*
