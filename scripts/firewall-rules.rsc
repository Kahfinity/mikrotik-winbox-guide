# ============================================================
# MikroTik RouterOS — Firewall Rules Script
# Deskripsi : Kumpulan aturan firewall yang direkomendasikan
# Versi      : 1.0
# ============================================================

# ── BERSIHKAN RULE LAMA (HATI-HATI!) ────────────────────────
# /ip firewall filter remove [find]
# /ip firewall nat remove [find]

# ── FILTER RULES — INPUT CHAIN ───────────────────────────────
/ip firewall filter

# Izinkan koneksi yang sudah terbentuk
add chain=input connection-state=established,related \
    action=accept comment="[INPUT] Allow Established/Related" place-before=0

# Buang paket invalid
add chain=input connection-state=invalid \
    action=drop comment="[INPUT] Drop Invalid"

# Izinkan ICMP (ping) dari mana saja — opsional
add chain=input protocol=icmp \
    action=accept comment="[INPUT] Allow ICMP"

# Izinkan akses penuh dari LAN ke router
add chain=input in-interface=LAN-LOKAL \
    action=accept comment="[INPUT] Allow LAN Full Access"

# Izinkan Winbox dari LAN saja
add chain=input protocol=tcp dst-port=8291 in-interface=LAN-LOKAL \
    action=accept comment="[INPUT] Allow Winbox from LAN"

# Izinkan SSH dari LAN saja
add chain=input protocol=tcp dst-port=22 in-interface=LAN-LOKAL \
    action=accept comment="[INPUT] Allow SSH from LAN"

# Blokir semua yang masuk dari WAN ke router
add chain=input in-interface=WAN-ISP \
    action=drop comment="[INPUT] Block WAN to Router"

# ── FILTER RULES — FORWARD CHAIN ─────────────────────────────

# Izinkan koneksi yang sudah terbentuk
add chain=forward connection-state=established,related \
    action=accept comment="[FORWARD] Allow Established/Related"

# Buang paket invalid
add chain=forward connection-state=invalid \
    action=drop comment="[FORWARD] Drop Invalid"

# Blokir akses dari Internet ke jaringan lokal
add chain=forward in-interface=WAN-ISP connection-state=new \
    action=drop comment="[FORWARD] Block New from WAN"

# Izinkan LAN ke Internet
add chain=forward in-interface=LAN-LOKAL out-interface=WAN-ISP \
    action=accept comment="[FORWARD] Allow LAN to Internet"

# ── CONTOH BLOKIR SITUS ──────────────────────────────────────

# Blokir berdasarkan konten (layer 7 — perlu resource lebih)
# /ip firewall layer7-protocol add name=youtube regexp="youtube\\.com"
# /ip firewall filter add chain=forward layer7-protocol=youtube action=drop

# ── ADDRESS LIST — IP Berbahaya / Spam ──────────────────────
# /ip firewall address-list add list=BLOCKED-IPS address=1.2.3.4 comment="IP Spam"

:log info "=== Firewall Rules berhasil diterapkan ==="
:put "✅ Firewall aktif dan dikonfigurasi"
