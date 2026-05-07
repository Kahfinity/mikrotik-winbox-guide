# ============================================================
# MikroTik RouterOS — Bandwidth Management Script
# Deskripsi : Simple Queue per subnet dan PCQ setup
# Versi      : 1.0
# ============================================================

# ── SIMPLE QUEUE PER SUBNET ──────────────────────────────────
/queue simple

# Batasi seluruh LAN (10 Mbps down / 5 Mbps up)
add name="Batas-Total-LAN" target=192.168.10.0/24 \
    max-limit=5M/10M comment="Batas Total LAN"

# Batasi per IP tertentu
add name="Batas-PC-Tertentu" target=192.168.10.100/32 \
    max-limit=2M/5M comment="Batas khusus PC 192.168.10.100"

# Queue dengan burst (speed tinggi sesaat)
add name="Batas-Burst-User" target=192.168.10.101/32 \
    max-limit=1M/3M \
    burst-limit=2M/6M \
    burst-threshold=512k/1536k \
    burst-time=8s/8s \
    comment="User dengan burst"

# ── PCQ SETUP ────────────────────────────────────────────────

# PCQ Queue Types
/queue type
add name=PCQ-Download kind=pcq pcq-rate=5M pcq-classifier=dst-address
add name=PCQ-Upload kind=pcq pcq-rate=2M pcq-classifier=src-address

# Mangle untuk tandai traffic
/ip firewall mangle
add chain=forward src-address=0.0.0.0/0 dst-address=192.168.10.0/24 \
    action=mark-packet new-packet-mark=pkt-download passthrough=no \
    comment="Mark Download Traffic"
add chain=forward src-address=192.168.10.0/24 dst-address=0.0.0.0/0 \
    action=mark-packet new-packet-mark=pkt-upload passthrough=no \
    comment="Mark Upload Traffic"

# Queue Tree PCQ
/queue tree
add name=Total-Download parent=global \
    packet-mark=pkt-download queue=PCQ-Download max-limit=20M \
    comment="Total Download semua user (PCQ)"
add name=Total-Upload parent=global \
    packet-mark=pkt-upload queue=PCQ-Upload max-limit=10M \
    comment="Total Upload semua user (PCQ)"

:log info "=== Bandwidth Management diterapkan ==="
:put "✅ Queue berhasil dikonfigurasi"
