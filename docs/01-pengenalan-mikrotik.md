# 01 — Pengenalan MikroTik & Winbox

> **Level:** 🟢 Dasar | **Estimasi Waktu:** 15 menit | [← Kembali ke README](../README.md)

---

## Apa Itu MikroTik?

**MikroTik** adalah perusahaan Latvia yang memproduksi perangkat keras dan perangkat lunak jaringan. Produk unggulannya adalah **RouterOS** — sistem operasi berbasis Linux yang dioptimalkan untuk routing, firewall, bandwidth management, dan berbagai fungsi jaringan lainnya.

MikroTik sangat populer di Indonesia karena:
- Harga terjangkau dibanding kompetitor (Cisco, Juniper)
- Fitur lengkap sekelas enterprise
- Komunitas pengguna yang besar
- Banyak digunakan di ISP lokal, kampus, dan perkantoran

---

## Seri Router MikroTik yang Umum Digunakan

| Seri | Contoh Model | Kegunaan |
|------|-------------|----------|
| **hAP** | hAP ac², hAP lite | Home & SOHO (WiFi) |
| **hEX** | RB750Gr3, RB760iGS | Home & SOHO (non-WiFi) |
| **RB** | RB951, RB2011 | Small-medium office |
| **CRS** | CRS326, CRS354 | Switch manageable |
| **CCR** | CCR1009, CCR2004 | ISP / Core Router |
| **LHG/SXT** | LHG 5, SXT Lite | Point-to-Point wireless |
| **CHR** | Cloud Hosted Router | Virtual / server |

---

## Apa Itu Winbox?

**Winbox** adalah aplikasi GUI (Graphical User Interface) untuk mengkonfigurasi router MikroTik secara visual. Winbox berjalan di Windows, dan bisa dijalankan di Linux/macOS menggunakan Wine.

### Mengapa Menggunakan Winbox?

| Metode Akses | Kelebihan | Kekurangan |
|-------------|-----------|-----------|
| **Winbox** | Visual, mudah dipahami, drag & drop | Perlu aplikasi terinstall |
| **WebFig** | Berbasis browser, tidak perlu install | Fitur lebih terbatas |
| **Terminal (SSH)** | Sangat powerful, bisa diskrip | Butuh hafal command |
| **CLI (Serial)** | Tidak butuh jaringan | Butuh kabel serial khusus |

> **Rekomendasi:** Gunakan Winbox untuk belajar dan konfigurasi sehari-hari. Pelajari CLI setelah paham konsep dasarnya.

---

## Download & Instalasi Winbox

### Windows
1. Buka [https://mikrotik.com/download](https://mikrotik.com/download)
2. Unduh **Winbox** (file `.exe`)
3. Jalankan langsung — tidak perlu instalasi

### Linux/macOS
```bash
# Install Wine terlebih dahulu
sudo apt install wine  # Ubuntu/Debian

# Jalankan Winbox
wine winbox.exe
```

---

### Menu Utama Winbox

| Menu | Fungsi |
|------|--------|
| **Quick Set** | Setup cepat (wizard) untuk pemula |
| **Interfaces** | Manajemen port fisik & virtual |
| **IP** | Konfigurasi IP, DHCP, DNS, Firewall |
| **Routing** | Static route, OSPF, BGP |
| **MPLS** | Multi-Protocol Label Switching |
| **Wireless** | Konfigurasi WiFi |
| **Bridge** | Bridging antar interface |
| **System** | Identitas router, log, reboot |
| **Tools** | Ping, traceroute, bandwidth test |
| **Queues** | Manajemen bandwidth |

---

## Konsep Dasar Jaringan yang Perlu Dipahami

Sebelum masuk ke konfigurasi, pastikan Anda memahami konsep berikut:

### IP Address & Subnet Mask
```
IP Address  : 192.168.1.1
Subnet Mask : /24 = 255.255.255.0
Network     : 192.168.1.0/24
Broadcast   : 192.168.1.255
Host Range  : 192.168.1.1 - 192.168.1.254
```

### Alur Jaringan Dasar
```
Internet → Modem/ONT → [WAN] MikroTik [LAN] → Switch → PC/Laptop
                        (Router)
```

### Istilah Penting

| Istilah | Penjelasan |
|---------|-----------|
| **WAN** | Wide Area Network — sisi Internet |
| **LAN** | Local Area Network — sisi lokal |
| **Gateway** | Router yang menghubungkan jaringan ke Internet |
| **DNS** | Domain Name System — menerjemahkan nama domain ke IP |
| **DHCP** | Dynamic Host Configuration Protocol — otomatis memberi IP |
| **NAT** | Network Address Translation — berbagi 1 IP publik ke banyak klien |

---

## Langkah Selanjutnya

Setelah memahami pengenalan ini, lanjutkan ke:

[02 — Koneksi Pertama ke Router](02-koneksi-pertama.md)

---
*Halaman 1 dari 10 | [Kembali ke README](../README.md)*
