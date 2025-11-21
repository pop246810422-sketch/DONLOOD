@echo off
:: ==== ملف: reset_network_silent.bat ====
:: يتأكد من عمله كمدير (Admin). إذا لم يكن، يعيد تشغيل نفسه بصلاحيات مرتفعة.
net session >nul 2>&1
if %errorlevel% neq 0 (
    powershell -Command "Start-Process -FilePath '%~f0' -Verb runAs"
    exit /b
)

mode con:cols=50 lines=11
title RESET NETWORK - ALPOP.GAMING (SILENT)

:loop
cls
color 60
echo Preparing network reset...

:: (تمت إزالة التنبيه الصوتي لعمل النسخة الصامتة)

:: تأخير صغير قبل تنفيذ أوامر الشبكة
timeout /t 4 >nul

cls
color 40
echo Running network reset commands...
echo.

:: أوامر إعادة تعيين الشبكة — تتطلب صلاحيات مدير
netsh winsock reset
if %errorlevel% neq 0 echo Warning: winsock reset failed.

netsh int ip reset
if %errorlevel% neq 0 echo Warning: int ip reset failed.

echo Registering DNS...
ipconfig /registerdns

echo Releasing IP...
ipconfig /release

echo Flushing DNS cache...
ipconfig /flushdns

echo Renewing IP...
ipconfig /renew

echo.
echo Network commands finished.
timeout /t 1 >nul

:: تأخير طويل قبل التكرار (يمكن تغييره حسب رغبتك)
color 47
echo Waiting 180 seconds before next cycle. Press Ctrl+C to stop.
timeout /t 250 >nul

goto loop
