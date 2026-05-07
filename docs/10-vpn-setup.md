# 🔐 10 — VPN Setup (PPTP / L2TP)

> **Level:** 🟡 Menengah | **Estimasi Waktu:** 35 menit | [← Kembali ke README](../README.md)

---

## Apa Itu VPN?

**VPN (Virtual Private Network)** membuat terowongan (tunnel) terenkripsi antara dua titik melalui internet publik. Digunakan untuk:
- Remote akses ke jaringan kantor dari rumah/luar
- Menghubungkan dua kantor (Site-to-Site)
- Keamanan komunikasi data

### Perbandingan Protokol VPN di MikroTik

| Protokol | Keamanan | Kecepatan | Kompatibilitas | Cocok Untuk |
|----------|----------|-----------|---------------|-------------|
| **PPTP** | ⚠️ Lemah | Cepat | Sangat luas | Lab / testing |
| **L2TP/IPSec** | ✅ Baik | Sedang | Luas | Kantor umum |
| **SSTP** | ✅ Baik | Sedang | Windows only | Kantor Windows |
| **OpenVPN** | ✅✅ Terbaik | Lebih lambat | Semua OS | Keamanan tinggi |
| **WireGuard** | ✅✅ Modern | Sangat cepat | Semua OS | Modern setup |

> ⚠️ **Rekomendasi:** Gunakan **L2TP/IPSec** atau **WireGuard** untuk produksi. PPTP hanya untuk latihan.

---

## A. PPTP VPN Server

### Topologi
```
[User di rumah] ──── Internet ──── [MikroTik PPTP Server] ──── [Jaringan Kantor]
  IP PPTP: 192.168.200.2             IP Publik: 203.0.113.10    192.168.10.0/24
```

### Langkah 1: Aktifkan PPTP Server

```
Menu: PPP → Interface → PPTP Server → tombol [PPTP Server]

☑️ Enabled
Default Profile: default-encryption
[OK]
```

### Langkah 2: Buat User VPN

```
Menu: PPP → Secrets → [ + ]

Name:     user-vpn-andi       ← username
Password: P@ssVPN2024!        ← password
Service:  pptp
Local Address:  192.168.200.1  ← IP server di tunnel
Remote Address: 192.168.200.2  ← IP yang diterima client
[OK]
```

### Langkah 3: Izinkan Port PPTP di Firewall

```
Menu: IP → Firewall → Filter Rules → [ + ]

Chain:       input
Protocol:    tcp (6)
Dst. Port:   1723              ← port PPTP
Action:      accept
Comment:     Allow PPTP VPN
[OK]

# Izinkan GRE protocol
[ + ]
Chain:       input
Protocol:    gre (47)
Action:      accept
Comment:     Allow GRE for PPTP
[OK]
```

### Langkah 4: Koneksi dari Client Windows

```
Windows → Settings → Network → VPN → Add VPN

VPN Provider:    Windows (built-in)
Connection Name: VPN-Kantor
Server Name:     203.0.113.10   ← IP Publik router
VPN Type:        PPTP
Username:        user-vpn-andi
Password:        P@ssVPN2024!

[Save] → [Connect]
```

---

## B. L2TP/IPSec VPN Server (Lebih Aman)

### Langkah 1: Aktifkan L2TP Server

```
Menu: PPP → Interface → L2TP Server → tombol [L2TP Server]

☑️ Enabled
☑️ Use IPSec: yes
IPSec Secret:  secretkey123     ← pre-shared key IPSec
Default Profile: default-encryption
[OK]
```

### Langkah 2: Buat User L2TP

```
Menu: PPP → Secrets → [ + ]

Name:           user-l2tp-budi
Password:       P@ssL2TP!
Service:        l2tp
Local Address:  192.168.200.1
Remote Address: 192.168.200.3
[OK]
```

### Langkah 3: Izinkan Port L2TP/IPSec di Firewall

```
Menu: IP → Firewall → Filter Rules → [ + ]

# UDP 500 (IKE)
Chain: input | Protocol: udp | Dst.Port: 500 | Action: accept
Comment: Allow IKE IPSec

# UDP 4500 (NAT Traversal)
Chain: input | Protocol: udp | Dst.Port: 4500 | Action: accept
Comment: Allow IPSec NAT-T

# UDP 1701 (L2TP)
Chain: input | Protocol: udp | Dst.Port: 1701 | Action: accept
Comment: Allow L2TP

# IPSec ESP
Chain: input | Protocol: ipsec-esp (50) | Action: accept
Comment: Allow IPSec ESP
```

### Langkah 4: Koneksi dari Client

**Windows:**
```
VPN Type: L2TP/IPSec with pre-shared key
Pre-shared Key: secretkey123
Username/Password: user-l2tp-budi / P@ssL2TP!
```

**Android:**
```
Settings → Network → VPN → Add VPN
Type: L2TP/IPSec PSK
Server: [IP Publik router]
IPSec pre-shared key: secretkey123
```

**iPhone/iPad:**
```
Settings → VPN → Add VPN Configuration
Type: L2TP
Server: [IP Publik router]
Account: user-l2tp-budi
Password: P@ssL2TP!
Secret: secretkey123
```

---

## C. VPN Site-to-Site (Hubungkan Dua Kantor)

```
[Kantor Pusat]                          [Kantor Cabang]
LAN: 192.168.10.0/24                    LAN: 192.168.20.0/24
IP Publik: 203.0.113.10                 IP Publik: 198.51.100.5
         │                                         │
         └────────── VPN PPTP Tunnel ──────────────┘
                   192.168.200.0/30
```

### Konfigurasi Kantor Pusat (sebagai Server)
Ikuti langkah PPTP Server di atas.

### Konfigurasi Kantor Cabang (sebagai Client)

```
Menu: PPP → Interface → [ + ] → PPTP Client

Tab [General]:
  Name: VPN-ke-Pusat

Tab [Dial Out]:
  Connect To:  203.0.113.10    ← IP Publik kantor pusat
  User:        user-vpn-cabang
  Password:    P@ssVPN!
  
[OK]
```

**Tambah route ke LAN Pusat via VPN:**
```
Menu: IP → Routes → [ + ]

Dst. Address: 192.168.10.0/24     ← LAN kantor pusat
Gateway:      <pptp-out1>         ← interface VPN (otomatis muncul)
[OK]
```

---

## D. Monitor Koneksi VPN Aktif

```
Menu: PPP → Active Connections

Name              Service  Call-ID  Address          Uptime
user-vpn-andi     pptp     1        192.168.200.2    01:23:45   ✅
user-l2tp-budi    l2tp     2        192.168.200.3    00:15:30   ✅
```

---

## Perintah Terminal Equivalen

```bash
# Aktifkan PPTP Server
/interface pptp-server server set enabled=yes

# Buat user PPTP
/ppp secret add name=user-vpn-andi password="P@ssVPN2024!" service=pptp \
  local-address=192.168.200.1 remote-address=192.168.200.2

# Aktifkan L2TP Server
/interface l2tp-server server set enabled=yes use-ipsec=yes ipsec-secret=secretkey123

# Buat user L2TP
/ppp secret add name=user-l2tp-budi password="P@ssL2TP!" service=l2tp \
  local-address=192.168.200.1 remote-address=192.168.200.3

# Buat PPTP Client (untuk cabang)
/interface pptp-client add name=VPN-ke-Pusat connect-to=203.0.113.10 \
  user=user-vpn-cabang password=P@ssVPN! disabled=no

# Cek koneksi aktif
/ppp active print

# Cek log VPN
/log print where topics~"ppp"
```

---

## Troubleshooting VPN

| Masalah | Kemungkinan Penyebab | Solusi |
|---------|---------------------|--------|
| Client tidak bisa connect | Port VPN diblokir firewall | Tambahkan firewall rule allow |
| Timeout saat connect | IP Publik salah atau router offline | Verifikasi IP Publik router |
| Terhubung tapi tidak bisa akses LAN | Routing VPN belum dikonfigurasi | Tambah static route via tunnel |
| L2TP/IPSec gagal | Pre-shared key salah | Samakan IPSec secret di server & client |
| VPN sering disconnect | Keepalive timeout | Set keepalive di PPP profile |

---
*Halaman 10 dari 10 | [← Sebelumnya](09-routing.md) | [Kembali ke README](../README.md)*
