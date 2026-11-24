# 📋 Panduan Setup & Tata Kelola S I I P Multi-Sekolah

**Folder Proyek:** `d:\Adam\Anti Gravity\SIIP sekolah`  
**Status Pemisahan:** ✅ **100% Terpisah & Mandiri (Tidak Terhubung ke Aplikasi Lama)**

---

## 🌟 Ringkasan Pemisahan Total

| Aspek | Aplikasi Lama (`presensi-ibadah-kloning`) | Aplikasi Baru (`SIIP Multi-Sekolah`) |
| :--- | :--- | :--- |
| **Domain Vercel** | `https://presensi-ibadah-kloning.vercel.app` | Target: `https://siip-multi-sekolah.vercel.app` *(Domain Baru)* |
| **Repositori GitHub** | `dimasadam21/presensi-ibadah-SIIP` | Repositori Baru (misal: `SIIP-Multi-Sekolah`) |
| **Folder Komputer** | `d:\Adam\Anti Gravity\Presensi Ibadah Komplit (Kloning)` | `d:\Adam\Anti Gravity\SIIP sekolah` |
| **Prefix LocalStorage** | `kloning_` | `siip_multi_` *(Data login, sesi & cache 100% terpisah)* |
| **Prefix Database** | `kloning_` / tabel default | `multi_` (`multi_sekolah`, `multi_siswa`, `multi_absen_sholat`) |
| **Storage Bucket** | `foto_absen` / `foto_absen_kloning` | `foto_absen_multi` |
| **Identitas PWA** | `siip-presensi-ibadah` | `siip-multi-sekolah` |
| **Paket Android (APK)** | `com.siip.presensiibadah` (`SIIP_Presensi_Ibadah.apk`) | `com.siip.multisekolah` (`SIIP_Multi_Sekolah.apk`) |
| **Fitur Unggulan** | Single-Sekolah (SMKN 1 Magelang), Maskot Si Ipin | Multi-Sekolah, Portal Super Admin Nasional, Clean Centered |

---

## 🗄️ 1. Setup Database Supabase Mandiri (Multi-Sekolah)

1. Buka [Supabase Dashboard](https://supabase.com/dashboard) pada proyek Anda.
2. Buka menu **SQL Editor** di bilah navigasi kiri, lalu klik **New query**.
3. Buka file [`setup_database_multi_sekolah.sql`](./setup_database_multi_sekolah.sql), salin seluruh kodenya, tempel ke SQL Editor Supabase, lalu klik tombol **Run**.
4. Supabase akan secara otomatis membuat:
   - Tabel `multi_sekolah` (dengan 3 sekolah sampel: SMKN 1, SMAN 1, SMPN 1)
   - Tabel `multi_siswa` (terhubung ke masing-masing sekolah)
   - Tabel `multi_absen_sholat` (presensi terisolasi)
   - Tabel `multi_pengaturan` (konfigurasi per sekolah)
   - Storage Bucket `foto_absen_multi` (khusus foto selfie siswa multi-sekolah)

---

## 🚀 2. Mengunggah ke Repositori GitHub Baru & Deploy ke Domain Vercel Baru

### Langkah A: Buat Repositori Baru di GitHub
1. Buka [GitHub](https://github.com/new).
2. Buat repositori baru bernama: `SIIP-Multi-Sekolah` (atau `siip-sekolah`).
3. Biarkan opsi "Add a README file" **tidak tercentang**.
4. Salin URL repositori yang dihasilkan (contoh: `https://github.com/dimasadam21/SIIP-Multi-Sekolah.git`).

### Langkah B: Hubungkan dan Unggah
1. Di folder ini, jalankan berkas [`hubungkan_github_multi_sekolah.bat`](./hubungkan_github_multi_sekolah.bat).
2. Masukkan URL repositori GitHub baru yang baru saja Anda buat.
3. Skrip akan otomatis mengunggah seluruh kode ke repositori baru tersebut.

### Langkah C: Pasang di Vercel dengan Domain Baru
1. Buka [Vercel Dashboard](https://vercel.com/dashboard).
2. Klik tombol **"Add New..." > "Project"**.
3. Pilih repositori baru Anda (`SIIP-Multi-Sekolah`) lalu klik **"Import"**.
4. Pada **Project Name**, beri nama: `siip-multi-sekolah` (sehingga domain publik Anda menjadi `https://siip-multi-sekolah.vercel.app`).
5. Klik **"Deploy"**.
6. Selesai! Aplikasi Multi-Sekolah Anda kini online di domain baru tanpa mengganggu atau menyentuh domain `presensi-ibadah-kloning.vercel.app` sama sekali.

---

## 🔑 3. Kredensial Awal Sistem
* **Portal Super Admin Nasional:** Username: `superadmin` | Password: `superadmin2026`
* **Admin SMK Negeri 1 Magelang:** Username: `admin` | Password: `admin`
* **Admin SMA Negeri 1 Magelang:** Username: `admin_sman1` | Password: `admin123`
* **Admin SMP Negeri 1 Magelang:** Username: `admin_smpn1` | Password: `admin123`
