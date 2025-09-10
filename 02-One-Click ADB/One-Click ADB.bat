@ECHO OFF&SETLOCAL enabledelayedexpansion
title Phicomm R1 One-Click ADB Connection 

CD /d %~dp0
::ECHO %~dp0
SET "ipd=192.168.1.166" REM Set default Phicomm R1 IP address
SET "apkd=h.apk" REM Set default APK file name

:main
::CD /d %~dp0hijack
@ECHO OFF
CLS
color 0F
ECHO.
ECHO.		Phicomm R1 One-Click ADB Connection  FB:ThanhQuangLe
ECHO.
ECHO.         1. ADB wireless connection to Phicomm R1 (ADB debugging)
ECHO.
ECHO.         2. Check device Get current version
ECHO.
ECHO.         3. Setup Auto DLNA
ECHO.
ECHO.         4. Setup Unisound ( Fix am thanh )
ECHO.
ECHO.         5. Disable Voice ( Xoa Tieng Trung )
ECHO.
ECHO.         6. Exit
ECHO.
SET /P psn=  Please enter the number corresponding to your selection and press Enter:

if /I "!psn!"=="1" goto a1
if /I "!psn!"=="2" goto a2
if /I "!psn!"=="3" goto a3
if /I "!psn!"=="4" goto a4
if /I "!psn!"=="5" goto a5
if /I "!psn!"=="6" goto EX
CLS 
ECHO.
ECHO Input error, press any key to return to the main menu.
PAUSE >nul
goto main

:a1
CLS 
ECHO.
ECHO.         ADB wireless connection to Phicomm R1 (ADB debugging)
ECHO.
ECHO. Cleaning up processes...
adb disconnect >nul
taskkill /f /t /im adb.exe >nul
adb devices >nul
::DIR
ECHO. 
SET /P ip=  Please enter the local network IP address of Phicomm R1 and press Enter (press Enter directly to use default %ipd%):
if "!ip!"=="" SET "ip=%ipd%"
ECHO.
ECHO. Connecting...
adb connect !ip!
adb devices |GOTO 2
:1
ECHO. Connection successful! Press any key to return to the main menu
PAUSE >NUL
SET "ip="
GOTO main

:2
ECHO. Connection failed, device is offline or ADB debugging is not enabled, please try again...
ECHO. Press any key to return to the main menu
PAUSE >nul
GOTO main

:a2
CLS
ECHO.
ECHO.         Check device Get current version
ECHO. 
ECHO. Checking device connection...
adb devices |GOTO error6
ECHO. Device is connected.
ECHO. Retrieving current version...
adb shell "cat /system/build.prop | grep ro.build.version.incremental"
ECHO. Press any key to return to the main menu.
PAUSE >nul
goto main

:error6
ECHO. Device is not connected. Please connect the device first using option 1.
ECHO. Press any key to return to the main menu.
PAUSE >nul
goto main

:a3
CLS
ECHO.
ECHO.         Setup Auto DLNA
ECHO.
SET /p ip=Please enter the speaker's IP address:
ECHO Cleaning up processes...
adb disconnect >nul
taskkill /f /t /im adb.exe >nul
adb devices >nul
ECHO Starting connection to the speaker...
adb connect %ip%
ECHO Allowing apps from unknown sources
adb shell settings put secure install_non_market_apps 1
set apk=AutoDLNA.apk
ECHO Uploading software
adb push %apk% /data/local/tmp/
ECHO Upload complete, starting installation...
adb shell /system/bin/pm install -r /data/local/tmp/%apk%
ECHO Installation complete, deleting software package...
adb shell rm /data/local/tmp/%apk%
ECHO Starting speaker reboot...
adb reboot

ECHO Press any key to exit...
pause > nul
goto main

:4
ECHO. Installation failed, please try again...
ECHO. Press any key to return to the main menu.
PAUSE >nul
goto main

:a4 
CLS   
ECHO.
ECHO.         Setup Unisound ( Fix am thanh )
ECHO.
set /p ip=Please enter the speaker's IP address:
echo Cleaning up processes...
adb disconnect >nul
taskkill /f /t /im adb.exe >nul
adb devices >nul
echo Starting connection to the speaker...
adb connect %ip%
echo Allowing apps from unknown sources
adb shell settings put secure install_non_market_apps 1
set apk=Unisound.apk
echo Uploading software
adb push %apk% /data/local/tmp/
echo Upload complete, starting installation...
adb shell /system/bin/pm install -r /data/local/tmp/%apk%
echo Installation complete, deleting software package...
adb shell rm /data/local/tmp/%apk%
echo Starting speaker reboot...
adb reboot

echo Press any key to exit...
pause > nul
goto main

:a5 
CLS   
ECHO.
ECHO.         Disable Voice
ECHO.
set /p ip=Please enter the speaker's IP address:
echo Cleaning up processes...
adb disconnect >nul
taskkill /f /t /im adb.exe >nul
adb devices >nul
echo Starting connection to the speaker...
adb connect %ip%
adb shell /system/bin/pm hide com.phicomm.speaker.device
ECHO. Press any key to return to the main menu.
PAUSE >nul
goto main

:EX
ECHO.
ECHO. Cleaning up processes...
adb disconnect >nul
taskkill /f /t /im adb.exe >nul
adb devices >nul
::DIR
ECHO.
EXIT