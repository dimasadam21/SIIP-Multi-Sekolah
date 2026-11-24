@echo off
chcp 65001 >nul
echo ==============================================================================
echo    SCRIPT PENGHUBUNG REPOSITORI GITHUB BARU - S I I P MULTI-SEKOLAH
echo ==============================================================================
echo.
echo Proyek ini 100%% terpisah dari presensi-ibadah-kloning.
echo Buat repositori baru di GitHub (misal: SIIP-Multi-Sekolah atau siip-sekolah).
echo.
set /p REPO_URL="Masukkan URL Repositori GitHub Baru (contoh: https://github.com/dimasadam21/SIIP-Multi-Sekolah.git): "

if "%REPO_URL%"=="" (
    echo [ERROR] URL Repositori tidak boleh kosong!
    pause
    exit /b
)

echo.
echo [1/5] Menyiapkan Git Staging...
git add -A

echo.
echo [2/5] Melakukan Commit...
git commit -m "feat: inisialisasi aplikasi SIIP Multi-Sekolah dan Portal Super Admin"

echo.
echo [3/5] Menghubungkan remote origin baru...
git remote remove origin >nul 2>&1
git remote add origin %REPO_URL%

echo.
echo [4/5] Mengatur branch main...
git branch -M main

echo.
echo [5/5] Mengunggah (Push) ke GitHub...
git push -u origin main

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ==============================================================================
    echo [SUKSES] Repositori SIIP Multi-Sekolah berhasil diunggah ke GitHub!
    echo Sekarang Anda dapat mengimpor repositori ini ke Vercel dengan domain baru:
    echo Contoh: siip-multi-sekolah.vercel.app
    echo ==============================================================================
) else (
    echo.
    echo [PERHATIAN] Terjadi kendala saat push. Pastikan koneksi internet aktif
    echo dan repositori tersebut sudah dibuat di akun GitHub Anda.
)

echo.
pause
