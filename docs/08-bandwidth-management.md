# 📊 08 — Bandwidth Management (Queue)

> **Level:** 🟡 Menengah | **Estimasi Waktu:** 30 menit | [← Kembali ke README](../README.md)

---

## Mengapa Bandwidth Management Penting?

Tanpa manajemen bandwidth, satu pengguna bisa memborong semua kapasitas internet sehingga pengguna lain menjadi lambat. Dengan Queue, kita dapat:
- Membatasi kecepatan per user / per IP
- Membagi bandwidth secara adil (fair sharing)
- Memprioritaskan traffic tertentu (VoIP, video call)

---

## Jenis Queue di MikroTik

| Jenis | Keterangan | Cocok Untuk |
|-------|-----------|-------------|
| **Simple Queue** | Mudah, berbasis IP/interface | Kantor kecil, pembatasan per user |
| **Queue Tree** | Kompleks, menggunakan mangle | ISP, manajemen kompleks |
| **PCQ** | Per Connection Queue — otomatis bagi rata | ISP dengan banyak user |

---

## A. Simple Queue — Limit Per User

### Skenario: Batasi user `192.168.10.100` max 5 Mbps download / 2 Mbps upload

```
Menu: Queues → Simple Queues → [ + ]

Tab [General]:
  Name:        Limit-PC-Andi
  Target:      192.168.10.100/32    ← IP spesifik user
  Max Limit:   Upload: 2M / Download: 5M

[OK]
```

### Skenario: Batasi semua user LAN max 2 Mbps per orang

```
Menu: Queues → Simple Queues → [ + ]

Tab [General]:
  Name:    Limit-Semua-LAN
  Target:  192.168.10.0/24    ← seluruh subnet LAN
  Max Limit: Upload: 2M / Download: 2M

[OK]
```

---

## B. Simple Queue dengan Burst (Izinkan Speed Tinggi Sementara)

Burst memungkinkan user mendapat speed lebih tinggi untuk waktu singkat (misalnya saat buka halaman web pertama kali).

```
Menu: Queues → Simple Queues → [ + ]

Tab [General]:
  Name:      User-Dengan-Burst
  Target:    192.168.10.101/32
  Max Limit: Upload: 1M / Download: 3M

Tab [Advanced]:
  Burst Limit:     Upload: 2M / Download: 6M    ← speed saat burst
  Burst Threshold: Upload: 512k / Download: 1.5M ← batas rata-rata untuk burst
  Burst Time:      Upload: 8s / Download: 8s    ← durasi burst

[OK]
```

---

## C. PCQ — Fair Sharing untuk Banyak User

PCQ membagi bandwidth secara otomatis dan merata ke semua pengguna aktif.

### Langkah 1: Buat PCQ Queue Type

```
Menu: Queues → Queue Types → [ + ]

Name:       PCQ-Download
Kind:       pcq
Rate:       5M         ← max per user
Classifier: dst-address

[ + ]
Name:       PCQ-Upload
Kind:       pcq
Rate:       2M
Classifier: src-address

[OK]
```

### Langkah 2: Buat Mangle untuk Tandai Traffic

```
Menu: IP → Firewall → Mangle → [ + ]

# Mark paket download (dari internet ke client)
Tab General:
  Chain:        forward
  Src. Address: 0.0.0.0/0 (internet)
  Dst. Address: 192.168.10.0/24

Tab Action:
  Action:       mark-packet
  New Packet Mark: download-traffic

[ + ]

# Mark paket upload (dari client ke internet)
Tab General:
  Chain:        forward
  Src. Address: 192.168.10.0/24
  Dst. Address: 0.0.0.0/0

Tab Action:
  Action:       mark-packet
  New Packet Mark: upload-traffic
```

### Langkah 3: Buat Queue Tree

```
Menu: Queues → Queue Tree → [ + ]

# Queue untuk semua download
Name:         Total-Download
Parent:       global
Packet Marks: download-traffic
Queue Type:   PCQ-Download
Max Limit:    20M           ← total bandwidth download semua user

[ + ]

# Queue untuk semua upload
Name:         Total-Upload
Parent:       global
Packet Marks: upload-traffic
Queue Type:   PCQ-Upload
Max Limit:    10M           ← total bandwidth upload semua user

[OK]
```

---

## D. Prioritas Traffic (QoS)

Prioritaskan traffic VoIP / Video Call agar tidak terputus:

```
Menu: Queues → Queue Tree → [ + ]

# Parent queue (total bandwidth)
Name:      Total-WAN
Parent:    ether1 (WAN)
Max Limit: 20M

[ + ]
# Queue prioritas tinggi: VoIP
Name:     VoIP-Priority
Parent:   Total-WAN
Priority: 1           ← 1 = tertinggi, 8 = terendah
Dst. Port: 5060       ← SIP port (VoIP)
Max Limit: 2M

[ + ]
# Queue normal: HTTP/HTTPS
Name:     Web-Traffic
Parent:   Total-WAN
Priority: 4
Max Limit: 15M
```

---

## E. Monitor Bandwidth Real-time

```
# Cek penggunaan per queue
Menu: Queues → Simple Queues
Lihat kolom Rate (Tx/Rx) untuk melihat kecepatan aktual

# Bandwidth Test antar router
Menu: Tools → BTest Server (aktifkan di router tujuan)
Menu: Tools → Bandwidth Test
  Test To: [IP router tujuan]
  [Start]

# Monitor traffic per interface
Menu: Interfaces → klik 2x interface → Tab [Traffic]
```

---

## Perintah Terminal Equivalen

```bash
# Simple Queue limit per user
/queue simple add name="Limit-PC-Andi" target=192.168.10.100/32 max-limit=2M/5M comment="Batas Andi"

# Simple Queue limit semua LAN
/queue simple add name="Limit-LAN" target=192.168.10.0/24 max-limit=2M/2M

# Cek semua queue dan rate-nya
/queue simple print stats

# Reset counter
/queue simple reset-counters [id]

# PCQ queue type
/queue type add name=PCQ-Download kind=pcq pcq-rate=5M pcq-classifier=dst-address
/queue type add name=PCQ-Upload kind=pcq pcq-rate=2M pcq-classifier=src-address
```

---

## Tips Bandwidth Management

> 💡 **Rumus Max Limit:** Jangan set Max Limit melebihi bandwidth real dari ISP. Cek dengan `/tool bandwidth-test` atau cek tagihan ISP.

> 💡 **Upload vs Download:** Upload = client → internet (kiri). Download = internet → client (kanan) di Winbox.

> 💡 **Monitoring:** Gunakan **The Dude** (software monitoring MikroTik gratis) untuk visualisasi bandwidth secara grafis.

---
*Halaman 8 dari 10 | [← Sebelumnya](07-wireless-setup.md) | [Kembali ke README](../README.md) | [Lanjut →](09-routing.md)*
