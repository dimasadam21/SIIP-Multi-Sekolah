-- ==============================================================================
-- SKEMA & SETUP DATABASE APLIKASI S I I P (EDISI MULTI-SEKOLAH & SUPER ADMIN)
-- ==============================================================================
-- Seluruh tabel di sini ber-prefix "multi_" dan 100% TERISOLASI dari aplikasi lain.
-- 
-- CARA PENGGUNAAN:
-- 1. Buka Supabase Dashboard (https://supabase.com/dashboard)
-- 2. Buka menu "SQL Editor" di bilah kiri, lalu klik "New query"
-- 3. Salin seluruh isi skrip ini, tempel ke SQL Editor, lalu klik "Run"
-- ==============================================================================

-- 1. EXTENSIONS
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ==============================================================================
-- 2. TABEL MASTER SEKOLAH (MULTI-SEKOLAH)
-- ==============================================================================
CREATE TABLE IF NOT EXISTS public.multi_sekolah (
    sekolah_id VARCHAR(50) PRIMARY KEY,
    npsn VARCHAR(30) UNIQUE,
    nama VARCHAR(150) NOT NULL,
    jenjang VARCHAR(20) DEFAULT 'SMK',
    alamat TEXT DEFAULT '',
    admin_user VARCHAR(50) DEFAULT 'admin',
    admin_pass TEXT NOT NULL DEFAULT 'admin',
    radius_meter INTEGER DEFAULT 100,
    latitude DOUBLE PRECISION DEFAULT -7.4726,
    longitude DOUBLE PRECISION DEFAULT 110.2212,
    status VARCHAR(20) DEFAULT 'Aktif' CHECK (status IN ('Aktif', 'Nonaktif')),
    created_at TIMESTAMPTZ DEFAULT TIMEZONE('asia/jakarta', NOW()),
    updated_at TIMESTAMPTZ DEFAULT TIMEZONE('asia/jakarta', NOW())
);

-- Seed data 3 sekolah sampel awal
INSERT INTO public.multi_sekolah (sekolah_id, npsn, nama, jenjang, alamat, admin_user, admin_pass, radius_meter, latitude, longitude)
VALUES 
    ('smkn1_mgl', '20327618', 'SMK Negeri 1 Magelang', 'SMK', 'Jl. Cawang No. 2, Magelang', 'admin', 'admin', 150, -7.4726, 110.2212),
    ('sman1_mgl', '20327612', 'SMA Negeri 1 Magelang', 'SMA', 'Jl. Cempaka No. 1, Magelang', 'admin_sman1', 'admin123', 100, -7.4812, 110.2185),
    ('smpn1_mgl', '20327599', 'SMP Negeri 1 Magelang', 'SMP', 'Jl. Pahlawan No. 45, Magelang', 'admin_smpn1', 'admin123', 100, -7.4789, 110.2198)
ON CONFLICT (sekolah_id) DO NOTHING;

-- ==============================================================================
-- 3. TABEL PENGATURAN SISTEM (MULTI-SEKOLAH)
-- ==============================================================================
CREATE TABLE IF NOT EXISTS public.multi_pengaturan (
    id SERIAL PRIMARY KEY,
    sekolah_id VARCHAR(50) NOT NULL REFERENCES public.multi_sekolah(sekolah_id) ON DELETE CASCADE,
    parameter VARCHAR(100) NOT NULL,
    nilai TEXT NOT NULL,
    deskripsi TEXT,
    updated_at TIMESTAMPTZ DEFAULT TIMEZONE('asia/jakarta', NOW()),
    CONSTRAINT uq_multi_sekolah_parameter UNIQUE (sekolah_id, parameter)
);

-- ==============================================================================
-- 4. TABEL SISWA (MULTI-SEKOLAH)
-- ==============================================================================
CREATE TABLE IF NOT EXISTS public.multi_siswa (
    siswa_id VARCHAR(50) PRIMARY KEY DEFAULT 'MSIS' || LPAD(FLOOR(RANDOM() * 900000 + 100000)::TEXT, 6, '0'),
    sekolah_id VARCHAR(50) NOT NULL REFERENCES public.multi_sekolah(sekolah_id) ON DELETE CASCADE,
    nis VARCHAR(30) NOT NULL,
    nama VARCHAR(150) NOT NULL,
    kelas VARCHAR(30) NOT NULL,
    jurusan VARCHAR(50) DEFAULT '',
    jk VARCHAR(10) NOT NULL CHECK (jk IN ('L', 'P')),
    status VARCHAR(20) DEFAULT 'Aktif' CHECK (status IN ('Aktif', 'Nonaktif', 'Lulus', 'Pindah')),
    password TEXT NOT NULL,
    no_hp VARCHAR(30) DEFAULT '',
    created_at TIMESTAMPTZ DEFAULT TIMEZONE('asia/jakarta', NOW()),
    updated_at TIMESTAMPTZ DEFAULT TIMEZONE('asia/jakarta', NOW()),
    CONSTRAINT uq_multi_sekolah_nis UNIQUE (sekolah_id, nis)
);

-- ==============================================================================
-- 5. TABEL PRESENSI SHOLAT (MULTI-SEKOLAH)
-- ==============================================================================
CREATE TABLE IF NOT EXISTS public.multi_absen_sholat (
    absen_id VARCHAR(100) PRIMARY KEY DEFAULT 'MABS_' || (EXTRACT(EPOCH FROM NOW()) * 1000)::BIGINT::TEXT || '_' || LPAD(FLOOR(RANDOM() * 9000 + 1000)::TEXT, 4, '0'),
    sekolah_id VARCHAR(50) NOT NULL REFERENCES public.multi_sekolah(sekolah_id) ON DELETE CASCADE,
    nis VARCHAR(30) NOT NULL,
    nama VARCHAR(150) NOT NULL,
    kelas VARCHAR(30) NOT NULL,
    jk VARCHAR(10) NOT NULL,
    tanggal DATE NOT NULL DEFAULT CURRENT_DATE,
    sholat VARCHAR(20) NOT NULL CHECK (sholat IN ('Subuh', 'Dhuha', 'Dzuhur', 'Ashar', 'Maghrib', 'Isya')),
    jam TIME NOT NULL DEFAULT CURRENT_TIME,
    status VARCHAR(30) NOT NULL CHECK (status IN ('Hadir', 'Terlambat', 'Halangan')),
    keterangan TEXT DEFAULT '',
    latitude DOUBLE PRECISION,
    longitude DOUBLE PRECISION,
    jarak DOUBLE PRECISION,
    maps_link TEXT DEFAULT '',
    foto_url TEXT DEFAULT '',
    created_at TIMESTAMPTZ DEFAULT TIMEZONE('asia/jakarta', NOW()),
    
    CONSTRAINT uq_multi_sekolah_siswa_tanggal_sholat UNIQUE (sekolah_id, nis, tanggal, sholat)
);

-- ==============================================================================
-- 6. STORAGE BUCKET MANDIRI UNTUK FOTO MULTI-SEKOLAH
-- ==============================================================================
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'foto_absen_multi',
    'foto_absen_multi',
    true,
    5242880,
    ARRAY['image/jpeg', 'image/jpg', 'image/png', 'image/webp']
)
ON CONFLICT (id) DO UPDATE SET public = true;

-- Kebijakan Akses (RLS) Storage Bucket
DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'objects' AND policyname = 'Public Access Multi Absen'
    ) THEN
        CREATE POLICY "Public Access Multi Absen" 
        ON storage.objects FOR SELECT 
        USING (bucket_id = 'foto_absen_multi');
    END IF;

    IF NOT EXISTS (
        SELECT 1 FROM pg_policies 
        WHERE tablename = 'objects' AND policyname = 'Public Upload Multi Absen'
    ) THEN
        CREATE POLICY "Public Upload Multi Absen" 
        ON storage.objects FOR INSERT 
        WITH CHECK (bucket_id = 'foto_absen_multi');
    END IF;
END $$;

-- Enable RLS & Izinkan Akses Publik Anonim untuk Tabel Multi
ALTER TABLE public.multi_sekolah ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.multi_pengaturan ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.multi_siswa ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.multi_absen_sholat ENABLE ROW LEVEL SECURITY;

DO $$
BEGIN
    DROP POLICY IF EXISTS "Akses Penuh Multi Sekolah" ON public.multi_sekolah;
    CREATE POLICY "Akses Penuh Multi Sekolah" ON public.multi_sekolah FOR ALL USING (true) WITH CHECK (true);

    DROP POLICY IF EXISTS "Akses Penuh Multi Pengaturan" ON public.multi_pengaturan;
    CREATE POLICY "Akses Penuh Multi Pengaturan" ON public.multi_pengaturan FOR ALL USING (true) WITH CHECK (true);

    DROP POLICY IF EXISTS "Akses Penuh Multi Siswa" ON public.multi_siswa;
    CREATE POLICY "Akses Penuh Multi Siswa" ON public.multi_siswa FOR ALL USING (true) WITH CHECK (true);

    DROP POLICY IF EXISTS "Akses Penuh Multi Absen" ON public.multi_absen_sholat;
    CREATE POLICY "Akses Penuh Multi Absen" ON public.multi_absen_sholat FOR ALL USING (true) WITH CHECK (true);
END $$;
