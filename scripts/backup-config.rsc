# ============================================================
# MikroTik RouterOS — Auto Backup Script
# Deskripsi : Backup konfigurasi otomatis ke file lokal
# Versi      : 1.0
# Cara pakai : Tambahkan ke Scheduler untuk backup berkala
# ============================================================

# ── BACKUP MANUAL ────────────────────────────────────────────
# Export konfigurasi ke file .rsc (bisa dibaca/diedit)
/export file=("backup-" . [/system identity get name] . "-" . [/system clock get date])

# Backup binary (tidak bisa dibaca, lebih lengkap)
/system backup save name=("backup-" . [/system identity get name] . "-" . [/system clock get date])

:put "✅ Backup berhasil disimpan"
:put ("   File: backup-" . [/system identity get name] . "-" . [/system clock get date])

# ── SETUP AUTO BACKUP MINGGUAN ───────────────────────────────
# Jadwalkan backup setiap hari Minggu pukul 02.00
/system scheduler
add name="Auto-Backup-Mingguan" \
    start-date=jan/01/2024 \
    start-time=02:00:00 \
    interval=7d \
    on-event="/export file=(\"backup-\" . [/system identity get name] . \"-\" . [/system clock get date])" \
    comment="Backup konfigurasi otomatis mingguan"

:log info "=== Auto Backup Scheduler dikonfigurasi ==="
:put "✅ Auto backup setiap minggu pukul 02:00 diaktifkan"

# ── HAPUS BACKUP LAMA (simpan 5 terakhir) ───────────────────
# Script ini dijalankan terpisah jika storage penuh
# :local fileList [/file find name~"backup-"]
# :if ([:len $fileList] > 5) do={
#   /file remove ($fileList->0)
# }

# ── TIPS RESTORE ─────────────────────────────────────────────
# Restore .rsc : /import file-name=nama-file.rsc
# Restore .backup : System → Backup → Restore (di Winbox)
