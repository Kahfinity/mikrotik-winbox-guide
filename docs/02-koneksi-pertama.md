# 🔌 02 — Koneksi Pertama ke Router

> **Level:** 🟢 Dasar | **Estimasi Waktu:** 10 menit | [← Kembali ke README](../README.md)

---

## Topologi

```
[PC/Laptop] ──── (LAN kabel) ──── [MikroTik Router]
  192.168.88.x                       192.168.88.1
```

> **Catatan:** MikroTik baru (factory default) memiliki IP LAN: `192.168.88.1`

---

## Metode Koneksi

### Metode 1: Via MAC Address (Direkomendasikan untuk Pemula)

Tidak perlu mengatur IP pada PC — Winbox bisa langsung terhubung menggunakan MAC Address.

**Langkah-langkah:**

**1. Buka Winbox**

**2. Klik tombol `[...]`** di samping kolom *Connect To*

**3. Tunggu router terdeteksi** di tab *Neighbors*

```
MAC Address        IP Address      Identity    Version    Board
DC:2C:6E:XX:XX:XX  192.168.88.1   MikroTik    6.49.10    RB750Gr3
```

**4. Klik baris MAC Address** → kolom *Connect To* terisi otomatis

**5. Isi Login:** `admin`

**6. Kosongkan Password** (default kosong)

**7. Klik `Connect`**

---

### Metode 2: Via IP Address

**Prasyarat:** IP PC harus satu jaringan dengan router.

**Atur IP PC secara manual:**
- IP: `192.168.88.2`
- Subnet: `255.255.255.0`
- Gateway: `192.168.88.1`

**Lalu di Winbox:**
```
Connect To: 192.168.88.1
Login:      admin
Password:   (kosong)
```

---

## Reset Router ke Factory Default

Jika router sudah pernah dikonfigurasi dan Anda lupa password, lakukan reset:

### Cara 1: Tombol Reset Fisik
1. Matikan router
2. Tahan tombol **RESET** di badan router
3. Nyalakan router sambil tetap tahan tombol RESET
4. Tahan selama ±5 detik hingga LED berkedip
5. Lepaskan — router akan restart ke factory default

### Cara 2: Via Winbox (jika masih bisa login)
```
Menu: System → Reset Configuration
☑️ No Default Configuration  ← centang jika ingin mulai dari bersih
☑️ Do Not Backup             ← centang untuk reset total
Klik [Reset Configuration]
```

> **Perhatian:** Reset akan menghapus SEMUA konfigurasi yang ada!

---

## Tampilan Setelah Login Pertama

Setelah berhasil login, Winbox akan menampilkan:

### 1. Default Configuration Dialog
```
┌──────────────────────────────────────────────────┐
│  Router has default configuration.               │
│                                                  │
│  Would you like to keep it?                      │
│                                                  │
│  [Remove Configuration]    [OK]                  │
└──────────────────────────────────────────────────┘
```

- Klik **OK** — untuk menyimpan konfigurasi default (cocok untuk belajar)
- Klik **Remove Configuration** — untuk memulai dari nol

### 2. Ganti Password Admin (Sangat Dianjurkan!)

Segera ganti password default:
```
Menu: System → Users
Klik 2x pada user "admin"
Password: [isi password baru yang kuat]
Confirm Password: [ulangi password]
Klik [OK]
```

---

## Memeriksa Informasi Router

Setelah login, cek informasi dasar router:

### Cek Identitas Router
```
Menu: System → Identity
Name: MikroTik    ← ubah sesuai kebutuhan (contoh: Router-Kantor-01)
```

### Cek Versi RouterOS
```
Menu: System → Routerboard
Atau: System → Resources
```

Output yang akan terlihat:
```
Uptime            : 00:05:23
Version           : 6.49.10 (stable)
Build Time        : Nov/22/2023
Factory Software  : 6.49.10
Free Memory       : 980.6 MiB
Total Memory      : 1024.0 MiB
CPU               : ARMv7
CPU Count         : 4
CPU Frequency     : 716 MHz
```

### Cek Interface (Port)
```
Menu: Interfaces
```

```
Name       Type    MTU    Actual-MTU   MAC Address        
ether1     ether   1500   1500         DC:2C:6E:XX:XX:01   ← WAN (Internet)
ether2     ether   1500   1500         DC:2C:6E:XX:XX:02   ← LAN
ether3     ether   1500   1500         DC:2C:6E:XX:XX:03   ← LAN
ether4     ether   1500   1500         DC:2C:6E:XX:XX:04   ← LAN
ether5     ether   1500   1500         DC:2C:6E:XX:XX:05   ← LAN
```

---

## Tips & Troubleshooting

### ❌ Router tidak muncul di Neighbors
- Pastikan kabel LAN terpasang dengan benar
- Coba port LAN yang berbeda (ether2, ether3, dst)
- Matikan Windows Firewall sementara
- Jalankan Winbox sebagai Administrator

### ❌ Tidak bisa Connect setelah klik MAC Address
- Pastikan kabel tersambung ke port **LAN** (bukan WAN/ether1)
- Coba refresh (klik `[...]` lagi)

### ❌ Login ditolak
- Username: `admin` (huruf kecil semua)
- Password: kosong (tidak ada spasi)
- Jika sudah pernah diubah → lakukan reset factory

---

## Ringkasan Perintah Terminal Equivalen

Semua yang dilakukan di Winbox bisa juga dilakukan via terminal:

```bash
# Cek identity
/system identity print

# Cek resource
/system resource print

# Cek interface
/interface print

# Ganti identity
/system identity set name="Router-Kantor-01"

# Ganti password admin
/user set admin password="PasswordBaru123!"
```

---

## Langkah Selanjutnya

Router sudah terhubung dan Anda sudah bisa login. Selanjutnya:

[03 — Konfigurasi IP Address](03-konfigurasi-ip.md)

---
*Halaman 2 dari 10 | [Kembali ke README](../README.md)*
