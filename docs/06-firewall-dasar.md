# 🔥 06 — Firewall Dasar

> **Level:** 🟡 Menengah | **Estimasi Waktu:** 30 menit | [← Kembali ke README](../README.md)

---

## Konsep Firewall di MikroTik

Firewall MikroTik bekerja dengan **chain** dan **rules**. Traffic diproses secara berurutan dari rule teratas ke bawah. Rule pertama yang cocok akan dieksekusi.

### Chain Utama

| Chain | Keterangan |
|-------|-----------|
| **input** | Traffic yang masuk KE router itu sendiri |
| **output** | Traffic yang keluar DARI router |
| **forward** | Traffic yang melewati router (client ke internet) |

### Action Utama

| Action | Keterangan |
|--------|-----------|
| **accept** | Izinkan traffic |
| **drop** | Tolak tanpa pemberitahuan |
| **reject** | Tolak dengan pemberitahuan ICMP |
| **log** | Catat ke log |

---

## A. Proteksi Router dari Akses Luar

### Aturan Firewall Input Dasar

```
Menu: IP → Firewall → Filter Rules
```

**Rule 1: Izinkan koneksi yang sudah established**
```
[ + ] Tab General:
  Chain:           input
  Connection State: ✅ established, ✅ related

Tab Action:
  Action: accept
Comment: "Allow Established Related"
[OK]
```

**Rule 2: Drop invalid packets**
```
[ + ] Tab General:
  Chain:           input
  Connection State: ✅ invalid

Tab Action:
  Action: drop
Comment: "Drop Invalid"
[OK]
```

**Rule 3: Izinkan akses dari LAN ke router**
```
[ + ] Tab General:
  Chain:      input
  Src. Address: 192.168.10.0/24
  In. Interface: LAN-LOKAL

Tab Action:
  Action: accept
Comment: "Allow LAN to Router"
[OK]
```

**Rule 4: Block semua akses dari WAN ke router**
```
[ + ] Tab General:
  Chain:      input
  In. Interface: WAN-ISP

Tab Action:
  Action: drop
Comment: "Block WAN to Router"
[OK]
```

> ⚠️ **Urutan sangat penting!** Pastikan urutan rule sesuai seperti di atas.

---

## B. Firewall Forward — Proteksi Client

**Rule: Block akses dari Internet ke jaringan lokal**
```
[ + ] Tab General:
  Chain:       forward
  In. Interface: WAN-ISP
  Connection State: ✅ new, ✅ invalid

Tab Action:
  Action: drop
Comment: "Block Unsolicited From Internet"
[OK]
```

**Rule: Izinkan client LAN akses Internet**
```
[ + ] Tab General:
  Chain:        forward
  Src. Address: 192.168.10.0/24
  Out. Interface: WAN-ISP

Tab Action:
  Action: accept
Comment: "Allow LAN to Internet"
[OK]
```

---

## C. Blokir Website/IP Tertentu

**Blokir akses ke IP atau domain tertentu:**
```
[ + ] Tab General:
  Chain:        forward
  Src. Address: 192.168.10.0/24

Tab Advanced:
  Content: facebook.com     ← blokir berdasarkan konten URL

Tab Action:
  Action: drop
Comment: "Block Facebook"
[OK]
```

**Blokir menggunakan Address List:**
```
# Buat address list
Menu: IP → Firewall → Address Lists → [ + ]
Name:    BLOCKED-SITES
Address: 31.13.72.36    ← IP Facebook

# Gunakan di firewall rule
Tab General: Dst. Address: !BLOCKED-SITES (atau pilih address list)
```

---

## Perintah Terminal Equivalen

```bash
/ip firewall filter
# Izinkan established/related
add chain=input connection-state=established,related action=accept comment="Allow Established"
# Drop invalid
add chain=input connection-state=invalid action=drop comment="Drop Invalid"
# Allow LAN ke router
add chain=input src-address=192.168.10.0/24 in-interface=ether2 action=accept comment="Allow LAN"
# Block WAN ke router
add chain=input in-interface=ether1 action=drop comment="Block WAN"
# Block internet ke lokal
add chain=forward in-interface=ether1 connection-state=new,invalid action=drop comment="Block Unsolicited"
# Allow LAN ke internet
add chain=forward src-address=192.168.10.0/24 out-interface=ether1 action=accept comment="LAN to Internet"
```

---
*Halaman 6 dari 10 | [← Sebelumnya](05-nat-internet-sharing.md) | [Kembali ke README](../README.md) | [Lanjut →](07-wireless-setup.md)*
