# ============================================================
# MikroTik RouterOS — Basic Setup Script
# Deskripsi : Konfigurasi dasar router (IP, DHCP, NAT, DNS)
# Versi      : 1.0
# Dibuat oleh: Network Engineer Portfolio
# Cara pakai : Import via Winbox → Files → Upload → New Terminal
#              /import file-name=basic-setup.rsc
# ============================================================

# ── 1. IDENTITAS ROUTER ──────────────────────────────────────
/system identity set name="Router-Utama"

# ── 2. BERI NAMA INTERFACE ───────────────────────────────────
/interface set ether1 name=WAN-ISP comment="Interface ke Internet/ISP"
/interface set ether2 name=LAN-LOKAL comment="Interface ke Jaringan Lokal"

# ── 3. IP ADDRESS ────────────────────────────────────────────
# IP LAN
/ip address add address=192.168.10.1/24 interface=LAN-LOKAL comment="IP Gateway LAN"

# DHCP Client di WAN (otomatis dapat IP dari ISP)
/ip dhcp-client add interface=WAN-ISP use-peer-dns=yes use-peer-ntp=yes \
    add-default-route=yes disabled=no comment="DHCP dari ISP"

# ── 4. DNS SERVER ────────────────────────────────────────────
/ip dns set servers=8.8.8.8,8.8.4.4 allow-remote-requests=yes

# ── 5. DHCP SERVER UNTUK CLIENT LAN ─────────────────────────
/ip pool add name=dhcp-pool ranges=192.168.10.2-192.168.10.254

/ip dhcp-server add name=dhcp-lan interface=LAN-LOKAL \
    address-pool=dhcp-pool lease-time=1d disabled=no

/ip dhcp-server network add address=192.168.10.0/24 \
    gateway=192.168.10.1 dns-server=8.8.8.8,8.8.4.4 \
    comment="DHCP Network LAN"

# ── 6. NAT MASQUERADE (INTERNET SHARING) ────────────────────
/ip firewall nat add chain=srcnat out-interface=WAN-ISP \
    action=masquerade comment="Internet Sharing - NAT Masquerade"

# ── 7. FIREWALL INPUT PROTECTION ────────────────────────────
/ip firewall filter
add chain=input connection-state=established,related action=accept \
    comment="Allow Established & Related"
add chain=input connection-state=invalid action=drop \
    comment="Drop Invalid Packets"
add chain=input src-address=192.168.10.0/24 in-interface=LAN-LOKAL \
    action=accept comment="Allow LAN Access to Router"
add chain=input in-interface=WAN-ISP action=drop \
    comment="Block All WAN to Router"

# ── 8. FIREWALL FORWARD ──────────────────────────────────────
/ip firewall filter
add chain=forward in-interface=WAN-ISP connection-state=new,invalid \
    action=drop comment="Block Unsolicited Traffic from Internet"
add chain=forward src-address=192.168.10.0/24 out-interface=WAN-ISP \
    action=accept comment="Allow LAN to Internet"

# ── 9. KEAMANAN DASAR ────────────────────────────────────────
# Nonaktifkan services yang tidak dibutuhkan
/ip service disable telnet
/ip service disable ftp
/ip service disable api
/ip service disable api-ssl

# Batasi akses Winbox & SSH hanya dari LAN
/ip service set winbox address=192.168.10.0/24
/ip service set ssh address=192.168.10.0/24

# ── 10. NTP CLIENT ──────────────────────────────────────────
/system ntp client set enabled=yes
/system ntp client servers add address=pool.ntp.org

# ── SELESAI ──────────────────────────────────────────────────
:log info "=== Basic Setup Selesai ==="
:put "✅ Konfigurasi dasar berhasil diterapkan!"
:put "   - IP LAN    : 192.168.10.1/24"
:put "   - DHCP Pool : 192.168.10.2 - 192.168.10.254"
:put "   - DNS       : 8.8.8.8 / 8.8.4.4"
:put "   - NAT       : Aktif (masquerade)"
:put "   - Firewall  : Aktif"
