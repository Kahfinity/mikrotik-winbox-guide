# 🗺️ 09 — Static & Dynamic Routing

> **Level:** 🟡 Menengah | **Estimasi Waktu:** 35 menit | [← Kembali ke README](../README.md)

---

## Konsep Routing

**Routing** adalah proses menentukan jalur terbaik untuk meneruskan paket data dari satu jaringan ke jaringan lain.

```
Jaringan A (192.168.10.0/24)
        │
    [Router A]
        │ link 10.10.10.0/30
    [Router B]
        │
Jaringan B (192.168.20.0/24)
```

Agar PC di Jaringan A bisa berkomunikasi dengan PC di Jaringan B, kedua router perlu tahu rute ke jaringan lawan.

---

## A. Static Routing

Static route dikonfigurasi manual oleh administrator. Cocok untuk topologi kecil dan sederhana.

### Skenario: Dua Router Terhubung

```
[Router A]                           [Router B]
LAN: 192.168.10.0/24    10.10.10.0/30    LAN: 192.168.20.0/24
GW:  192.168.10.1       10.10.10.1 ──── 10.10.10.2       192.168.20.1
                          ether1            ether1
```

### Konfigurasi di Router A

```
# Tambah IP pada interface link ke Router B
Menu: IP → Addresses → [ + ]
Address:   10.10.10.1/30
Interface: ether1

# Tambah static route ke jaringan B
Menu: IP → Routes → [ + ]
Dst. Address: 192.168.20.0/24
Gateway:      10.10.10.2         ← IP Router B di link
Distance:     1 (default)
[OK]
```

### Konfigurasi di Router B

```
# Tambah IP pada interface link ke Router A
Menu: IP → Addresses → [ + ]
Address:   10.10.10.2/30
Interface: ether1

# Tambah static route ke jaringan A
Menu: IP → Routes → [ + ]
Dst. Address: 192.168.10.0/24
Gateway:      10.10.10.1         ← IP Router A di link
[OK]
```

### Verifikasi Routing Table

```
Menu: IP → Routes

Dst-Address       Gateway        Distance   Interface
0.0.0.0/0         203.0.113.9    1          WAN-ISP      ← default route
192.168.10.0/24   bridge-local   0          bridge-local ← connected
192.168.20.0/24   10.10.10.2     1          ether1       ← static ✅
10.10.10.0/30     10.10.10.1     0          ether1       ← connected
```

---

## B. Default Route (Rute ke Internet)

Default route digunakan saat tidak ada rute spesifik yang cocok — biasanya untuk akses Internet.

```
Menu: IP → Routes → [ + ]

Dst. Address: 0.0.0.0/0        ← 0.0.0.0/0 = semua tujuan
Gateway:      203.0.113.9      ← IP gateway ISP
Distance:     1
Comment:      Default Route ke ISP
[OK]
```

> 💡 **Perhatian:** Jika menggunakan DHCP Client di WAN, default route biasanya ditambah otomatis oleh DHCP. Jangan sampai duplikat.

---

## C. Recursive Route (Floating Static Route)

Gunakan distance lebih tinggi sebagai backup route:

```
# Route utama (distance 1)
Dst. Address: 0.0.0.0/0
Gateway:      203.0.113.9    ← ISP 1
Distance:     1

# Route backup (distance 5 — aktif jika route utama down)
Dst. Address: 0.0.0.0/0
Gateway:      203.0.114.1    ← ISP 2
Distance:     5
```

---

## D. Dynamic Routing dengan OSPF

OSPF (Open Shortest Path First) otomatis mempelajari rute dari router tetangga. Cocok untuk jaringan dengan banyak router.

### Konfigurasi OSPF Dasar (Router A & B)

```
# Aktifkan OSPF Instance
Menu: Routing → OSPF → Instances → [ + ]
Name:       default
Router ID:  10.10.10.1     ← IP unik untuk tiap router

# Tambah Network yang di-advertise
Menu: Routing → OSPF → Networks → [ + ]
Network:  192.168.10.0/24   ← jaringan LAN lokal
Area:     backbone (0.0.0.0)

[ + ]
Network:  10.10.10.0/30     ← jaringan link antar router
Area:     backbone

[OK]
```

> Ulangi di Router B dengan Router ID berbeda (misal `10.10.10.2`) dan network `192.168.20.0/24`.

### Verifikasi OSPF Neighbor

```
Menu: Routing → OSPF → Neighbors

Router ID    Address      State      Priority
10.10.10.2   10.10.10.2   Full       1          ← ✅ terhubung
```

### Verifikasi Route yang Dipelajari OSPF

```
Menu: IP → Routes

Dst-Address       Gateway     Protocol   Distance
192.168.20.0/24   10.10.10.2  ospf       110      ← dipelajari dari OSPF ✅
```

---

## E. Route Filtering — Kontrol Rute yang Di-advertise

```
Menu: Routing → Filters → [ + ]

# Jangan advertise jaringan tertentu
Rule:    if (dst == 10.0.0.0/8) { reject; }
```

---

## Perintah Terminal Equivalen

```bash
# Tambah static route
/ip route add dst-address=192.168.20.0/24 gateway=10.10.10.2 comment="Ke Jaringan B"

# Tambah default route
/ip route add dst-address=0.0.0.0/0 gateway=203.0.113.9 comment="Default Route ISP"

# Cek routing table
/ip route print

# OSPF instance
/routing ospf instance set default router-id=10.10.10.1

# OSPF network
/routing ospf network add network=192.168.10.0/24 area=backbone
/routing ospf network add network=10.10.10.0/30 area=backbone

# Cek OSPF neighbor
/routing ospf neighbor print

# Traceroute untuk debug routing
/tool traceroute 192.168.20.1
```

---

## Troubleshooting Routing

| Masalah | Kemungkinan Penyebab | Solusi |
|---------|---------------------|--------|
| Ping antar jaringan gagal | Rute tidak ada di salah satu router | Tambahkan static route di kedua sisi |
| Route ada tapi traffic tidak jalan | Firewall memblokir | Cek firewall forward rule |
| OSPF neighbor tidak muncul | Interface belum di-advertise | Cek konfigurasi OSPF Network |
| Route flapping | Link tidak stabil | Cek kabel/interface fisik |

---
*Halaman 9 dari 10 | [← Sebelumnya](08-bandwidth-management.md) | [Kembali ke README](../README.md) | [Lanjut →](10-vpn-setup.md)*
