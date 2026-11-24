/**
 * ==============================================================================
 * KONFIGURASI APLIKASI S I I P MULTI-SEKOLAH & SUPER ADMIN NASIONAL
 * ==============================================================================
 * 
 * Pengaturan ini menjamin pemisahan 100% dari aplikasi presensi sebelumnya:
 * - LocalStorage Mandiri (Prefix: siip_multi_)
 * - Supabase Table Prefix: "multi_"
 * - Storage Bucket Mandiri: "foto_absen_multi"
 * - Domain & Repositori terpisah total
 * ==============================================================================
 */

// Storage Mandiri Terisolasi Khusus Aplikasi Multi-Sekolah (Prefix: siip_multi_)
// Menjamin seluruh sesi, login siswa, login admin, login super admin, dan cache lokal
// tidak akan pernah bersentuhan atau bentrok dengan aplikasi presensi lainnya.
window.klonStorage = {
  _prefix: 'siip_multi_',
  getItem: function(key) {
    try { return localStorage.getItem(this._prefix + key); } catch(e) { return null; }
  },
  setItem: function(key, val) {
    try { localStorage.setItem(this._prefix + key, val); } catch(e) {}
  },
  removeItem: function(key) {
    try { localStorage.removeItem(this._prefix + key); } catch(e) {}
  },
  clear: function() {
    try {
      var keys = [];
      for (var i = 0; i < localStorage.length; i++) {
        var k = localStorage.key(i);
        if (k && k.indexOf(this._prefix) === 0) keys.push(k);
      }
      keys.forEach(function(k) { localStorage.removeItem(k); });
    } catch(e) {}
  }
};

window.APP_CONFIG = {
  // SUPABASE PROJECT CONFIGURATION
  // Anda dapat menggunakan project Supabase yang sama (dengan tabel terpisah ber-prefix 'multi_')
  // atau membuat project Supabase baru khusus untuk multi-sekolah.
  SUPABASE_URL: "https://pkjnbuzfknbcakmtfkif.supabase.co",

  // Supabase Public Anon Key
  SUPABASE_ANON_KEY: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBram5idXpma25iY2FrbXRma2lmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTExODI5OTAsImV4cCI6MjEwNjc1ODk5MH0.xdDDnoYJ05_Uq0m5IVz1H1rc-Fpon5ERXjUqrKfpmpY",

  // PREFIX TABEL KHUSUS MULTI-SEKOLAH (ISOLASI LENGKAP)
  // Menghasilkan tabel terpisah:
  // - multi_sekolah
  // - multi_siswa
  // - multi_absen_sholat
  // - multi_pengaturan
  TABLE_PREFIX: "multi_",

  // Nama Storage Bucket mandiri untuk foto selfie presensi multi-sekolah
  SUPABASE_STORAGE_BUCKET: "foto_absen_multi",

  // Identitas Aplikasi Multi-Sekolah
  APP_NAME: "S I I P Multi-Sekolah - Sistem Informasi Ibadah Pelajar",
  APP_EDITION: "Multi-Sekolah & Super Admin Nasional",
  APP_VERSION: "3.0.0-multi",

  // Target Domain Khusus Multi-Sekolah
  DOMAIN_TARGET: "siip-multi-sekolah.vercel.app"
};
