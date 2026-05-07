# 🌐 MikroTik Winbox — Panduan Konfigurasi Jaringan

<div align="center">

![MikroTik](https://img.shields.io/badge/MikroTik-RouterOS-blue?style=for-the-badge&logo=mikrotik&logoColor=white)
![Winbox](https://img.shields.io/badge/Winbox-v3.x-orange?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Active-green?style=for-the-badge)
![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)

**Panduan lengkap konfigurasi MikroTik menggunakan Winbox**  
*Dari tingkat dasar hingga menengah — cocok untuk pelajar, teknisi, dan network engineer.*

[Mulai](#-daftar-isi) • [Quick Start](#-quick-start) • [Diskusi](../../discussions) • [Laporan Bug](../../issues)

</div>

---

## Daftar Isi

| No | Topik | Level | Link |
|----|-------|-------|------|
| 1 | Pengenalan MikroTik & Winbox | 🟢 Dasar | [Baca →](docs/01-pengenalan-mikrotik.md) |
| 2 | Koneksi Pertama ke Router | 🟢 Dasar | [Baca →](docs/02-koneksi-pertama.md) |
| 3 | Konfigurasi IP Address | 🟢 Dasar | [Baca →](docs/03-konfigurasi-ip.md) |
| 4 | DHCP Server & Client | 🟢 Dasar | [Baca →](docs/04-dhcp-server-client.md) |
| 5 | NAT & Internet Sharing | 🟢 Dasar | [Baca →](docs/05-nat-internet-sharing.md) |
| 6 | Firewall Dasar | 🟡 Menengah | [Baca →](docs/06-firewall-dasar.md) |
| 7 | Wireless (WiFi) Setup | 🟡 Menengah | [Baca →](docs/07-wireless-setup.md) |
| 8 | Bandwidth Management (Queue) | 🟡 Menengah | [Baca →](docs/08-bandwidth-management.md) |
| 9 | Static & Dynamic Routing | 🟡 Menengah | [Baca →](docs/09-routing.md) |
| 10 | VPN Setup (PPTP/L2TP) | 🟡 Menengah | [Baca →](docs/10-vpn-setup.md) |

---

## Quick Start

### Persyaratan
- MikroTik Router (seri RB/CCR/hEX)
- Winbox versi terbaru ([Download di sini](https://mikrotik.com/download))
- Kabel LAN atau koneksi WiFi ke router

### Langkah Awal
```
1. Download & buka Winbox
2. Klik tombol [...]  → Scan neighbor devices
3. Klik MAC Address router yang muncul
4. Login: Username = admin | Password = (kosong / sesuai label router)
5. Klik Connect
```

---

## 📁 Struktur Repositori

```
mikrotik-winbox/
│
├── README.md                    ← Halaman utama (ini)
│
├── 📂 docs/                        ← Semua panduan konfigurasi
│   ├── 01-pengenalan-mikrotik.md
│   ├── 02-koneksi-pertama.md
│   ├── 03-konfigurasi-ip.md
│   ├── 04-dhcp-server-client.md
│   ├── 05-nat-internet-sharing.md
│   ├── 06-firewall-dasar.md
│   ├── 07-wireless-setup.md
│   ├── 08-bandwidth-management.md
│   ├── 09-routing.md
│   └── 10-vpn-setup.md
│
├── 📂 scripts/                     ← Script RouterOS (.rsc)
│   ├── basic-setup.rsc
│   ├── firewall-rules.rsc
│   ├── bandwidth-queue.rsc
│   └── backup-config.rsc
│
├── 📂 topologi/                    ← Diagram topologi jaringan
│   ├── basic-network.png
│   └── advanced-network.png
│
└── 📂 assets/                      ← Screenshot & gambar panduan
    └── screenshots/
```

---

## Target Pembaca

| Target | Keterangan |
|--------|------------|
| Mahasiswa IT/Networking | Belajar konfigurasi router dari nol |
| Teknisi Lapangan | Referensi cepat saat setup di lapangan |
| Network Engineer | Template konfigurasi standar |
| Instruktur SMK/Kampus | Materi ajar siap pakai |

---

## Perangkat yang Diuji

| Seri Router | RouterOS | Status |
|-------------|----------|--------|
| RB951Ui-2HnD | 6.49.x | ✅ Tested |
| RB750Gr3 (hEX) | 6.49.x | ✅ Tested |
| RB4011iGS | 7.x | ✅ Tested |
| CCR1009-7G-1C | 6.49.x | ✅ Tested |
| CHR (Cloud Hosted Router) | 7.x | ✅ Tested |

---

## Lisensi

Proyek ini dilisensikan di bawah **MIT License** — bebas digunakan untuk keperluan edukasi dan komersial.

---

<div align="center">
⭐ Jika repositori ini membantu, berikan bintang!
Semoga Bermanfaat.
</div>
