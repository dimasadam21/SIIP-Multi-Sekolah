@echo off
chcp 65001 >nul
echo ==============================================================================
echo    S I I P MULTI-SEKOLAH - REPOSITORI GITHUB TERHUBUNG
echo ==============================================================================
echo.
echo Repositori GitHub: https://github.com/dimasadam21/SIIP-Multi-Sekolah.git
echo Status: TERHUBUNG KE BRANCH MAIN
echo.
echo Menjalankan git add dan git push ke origin main...
git add -A
git commit -m "Auto-update: pembaruan berkas SIIP Multi-Sekolah"
git push -u origin main

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ==============================================================================
    echo [SUKSES] Seluruh perubahan berhasil diunggah ke GitHub!
    echo Repositori: https://github.com/dimasadam21/SIIP-Multi-Sekolah
    echo ==============================================================================
) else (
    echo.
    echo [INFO] Tidak ada perubahan baru atau git push telah selesai.
)

echo.
pause
