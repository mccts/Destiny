@echo off
set "filename=%~n0"
title %filename%
set "version=1.0"
set "updatetime=24th January 2025"
set "directory=%~dp0"
chcp 65001 >nul

cd /d "%directory%"
if not "%1"=="am_admin" (powershell start -verb runas '%0' am_admin & exit /b) 
cd /d "%directory%"

if not exist Status.json (
    goto check
) else (
    goto connection
)

:check
echo [93m[i] Checking File Directory
echo [DEBUG] Current Directory: "%directory%" 
echo [93m[i] Check for Status.json exists
echo [31m[!] Status.json is not available!
echo Status: Opened > Status.json
echo [92m[+] Created Status.json!
echo [93m[i] Checking Network Connection
for /f "tokens=2 delims=:" %%a in ('netsh wlan show interface ^| find "Status" ^| findstr /v "des gehosteten Netzwerks"') do set Status=%%a >nul
echo [DEBUG] Network Status: "%Status%"
if not defined Status (
    echo [31m[!] Network status could not be determined!
    set Status=Unknown
)

echo [93m[i] Checking for Windows Updates
wuauclt /detectnow
wuauclt /updatenow
usoclient StartScan
usoclient StartDownload
usoclient StartInstall
echo [DEBUG] All Updates have been made!
echo [92m[i] Success![0m
ping localhost -n 3 >nul
goto welcome 

:Connection
cls
echo.
echo.
echo [90m[1mConnecting.. [0m
ping localhost -n 2 >nul
goto menu

:welcome
cls
mode 120, 30 >nul
echo.
echo.
echo                        			   [38;2;111;113;130m   ^_      ^_^_    ^_^_                  					[0m
echo                        			   [38;2;111;113;130m  ^| ^| ^/^| ^/ ^/^_^_ ^/ ^/^_^_^_^_^_^_  ^_^_ ^_  ^_^_^_ 			[0m
echo                        			   [38;2;111;113;130m  ^| ^|^/ ^|^/ ^/ -^_^) ^/ ^_^_^/ ^_ ^\^/  ' ^\^/ -^_^)			[0m
echo                        			   [38;2;111;113;130m  ^|^_^_^/^|^_^_^/^\^_^_^/^_^/^\^_^_^/^\^_^_^_^/^_^/^_^/^_^/^\^_^_^/		[0m
echo 			    "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="                                                             
echo. 
echo			  		           		 [31m[1mWarning[0m   
echo.
echo 		  Destiny is a Tool to optimize your PC for maximum Performance and Connection.                     		                  
echo 	  I recommend to create a System Restore Point because I am not responsible for any damage with your PC.
echo 			    "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="  
echo.
echo 					    Made and published by  [90m[1mmccts[0m
echo 				      TUNED [90m[1m*[0m Version %version% [90m[1m*[0m Last Update: %updatetime%
echo 			    "=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-="  
echo.
echo			  		           	Press any key to continue...
pause >nul
goto menu

:menu
cls
set input=
set previous_menu=menu
echo.
echo.
echo.
echo                        			[38;2;111;113;130m   ^_^_^_  ^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_^_  ^_^_^_^_  ^_^_ 	[0m
echo                        			[38;2;111;113;130m  ^/ ^_ ^\^/ ^_^_^/ ^_^_^/^_  ^_^_^/  ^_^/ ^|^/ ^/^\ ^\^/ ^/ 		[0m
echo                        			[38;2;111;113;130m ^/ ^/^/ ^/ ^_^/^_^\ ^\  ^/ ^/ ^_^/ ^/^/    ^/  ^\  ^/  		[0m
echo                        			[38;2;111;113;130m^/^_^_^_^_^/^_^_^_^/^_^_^_^/ ^/^_^/ ^/^_^_^_^/^_^/^|^_^/   ^/^_^/   	[0m
echo.
echo 		     		       [90mNOTE: Adding more Features in the future. [0m
echo.
echo.
echo                                      [38;2;111;113;130m01[0m Network Operations		[38;2;111;113;130m04[0m Power Optimization   
echo                                      [38;2;111;113;130m02[0m TCP Optimization  		[38;2;111;113;130m05[0m Memory Optimization 
echo                                      [38;2;111;113;130m03[0m Optimize Windows Services	[38;2;111;113;130m06[0m Clean up PC 
echo.
echo. 
set /p input=[97m[1m                                       			- [0m
if /i "%input%"=="" goto menu
if /i "%input%"=="1" goto network_operations
if /i "%input%"=="2" goto optimize_tcp
if /i "%input%"=="3" goto optimize_windows_service
if /i "%input%"=="4" goto optimize_power
if /i "%input%"=="5" goto optimize_memory
if /i "%input%"=="6" goto clean_pc
if /i "%input%"=="socials" goto socials
if /i "%input%"=="exit" goto end
goto menu

:network_operations
netsh int tcp reset
netsh interface ip delete arpcache
ipconfig /all
ipconfig /flushdns
ipconfig /release
ipconfig /renew
ipconfig /displaydns
arp -a
netsh interface ip delete arpcache
netsh int tcp set heuristics disabled
netsh int tcp set global rss=enabled
netsh int tcp set global chimney=enabled
netsh int tcp set global autotuninglevel=normal
netsh int tcp set global congestionprovider=ctcp
netsh int tcp set global ecncapability=disabled
netsh int tcp set global timestamps=disabled
netsh wlan show interfaces
netsh winsock reset
netsh int ip reset
pause >nul
goto %previous_menu%

:optimize_tcp
netsh int tcp reset
netsh interface ip delete arpcache
netsh int tcp set heuristics disabled
netsh int tcp set global timestamps=disabled
netsh int tcp set global fastopen=enabled
netsh int tcp set global nonsackrttresiliency=disabled
netsh int tcp set global netdma=enabled
netsh int tcp set global congestionprovider=ctcp
netsh int tcp set global dca=enabled
netsh int tcp set global ecncapability=disabled
netsh int tcp set global autotuninglevel=normal
netsh int tcp set global rss=enabled
netsh int tcp set global chimney=enabled
netsh int tcp set global initialrto=300
netsh int tcp set global nonsecpath=enabled
netsh int tcp set global rsc=enabled
netsh int tcp show heuristics
netsh int tcp show supplementalports
netsh int tcp show supplementalsubnets
netsh int tcp show global
pause >nul
goto %previous_menu%

:optimize_windows_service
sc stop BITS
sc stop Dnscache
sc stop SysMain
sc config SysMain start=disabled
sc stop WSearch
sc config WSearch start=disabled
sc stop DiagTrack
sc config DiagTrack start=disabled
sc config spooler start= disabled
sc stop spooler
wmic nicconfig where (IPEnabled=TRUE) call SetTcpipNetbios 2
pause >nul
goto %previous_menu%

:optimize_power
powercfg /setactive SCHEME_MAX
powercfg /setacvalueindex SCHEME_MAX SUB_PCIE EXPRESS 0
powercfg /setdcvalueindex SCHEME_MAX SUB_PCIE EXPRESS 0
powercfg /setacvalueindex SCHEME_MAX SUB_PROCESSOR PROCTHROTTLEMIN 100
powercfg /setdcvalueindex SCHEME_MAX SUB_PROCESSOR PROCTHROTTLEMIN 100
powercfg /setacvalueindex SCHEME_MAX SUB_PROCESSOR PROCTHROTTLEMAX 100
powercfg /setdcvalueindex SCHEME_MAX SUB_PROCESSOR PROCTHROTTLEMAX 100
powercfg /hibernate off
powercfg /setacvalueindex SCHEME_MAX SUB_SLEEP STANDBYIDLE 0
powercfg /setdcvalueindex SCHEME_MAX SUB_SLEEP STANDBYIDLE 0
powercfg /setacvalueindex SCHEME_MAX SUB_DISK DISKIDLE 0
powercfg /setdcvalueindex SCHEME_MAX SUB_DISK DISKIDLE 0
pause >nul
goto %previous_menu%

:optimize_memory
call :cleanup_temp_files
DISM /online /cleanup-image /checkhealth
fsutil behavior set memoryusage 2
chkdsk C: /f /r /x
defrag C: /H
powershell -Command "Clear-Content -Path '$env:temp\*' -ErrorAction SilentlyContinue"
pause >nul
goto %previous_menu%

:clean_pc
call :cleanup_temp_files
cleanmgr /sagerun:1
DISM /online /cleanup-image /checkhealth
sfc /scannow
pause >nul
goto %previous_menu%

:cleanup_temp_files
if exist %temp%\* del /q /s %temp%\* 
if exist C:\Windows\Temp\* del /q /s C:\Windows\Temp\* 
if exist C:\Windows\Prefetch\* del /q /s C:\Windows\Prefetch\* 
rd /s /q %systemdrive%\$Recycle.Bin
exit /b

:socials
start https://guns.lol/mccts
goto %previous_menu% 

:end
exit


