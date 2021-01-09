@echo off
setlocal
set hour=%time:~0,2%
set minute=%time:~3,2%
set /A minute+=2
if %minute% GTR 59 (
 set /A minute-=60
 set /A hour+=1
)
if %hour%==24 set hour=00
if "%hour:~0,1%"==" " set hour=0%hour:~1,1%
if "%hour:~1,1%"=="" set hour=0%hour%
if "%minute:~1,1%"=="" set minute=0%minute%
set tasktime=%hour%:%minute%
mkdir C:\Sysmon
pushd "C:\Sysmon\"
echo [+] Downloading Sysmon...
@powershell (new-object System.Net.WebClient).DownloadFile('https://live.sysinternals.com/Sysmon64.exe','C:\Sysmon\sysmon64.exe')"
echo [+] Downloading Sysmon config...
@powershell (new-object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/Netsmart-OneTeam/sysmon-config/master/sysmonconfig-export.xml','C:\Sysmon\sysmonconfig-export.xml')"
@powershell (new-object System.Net.WebClient).DownloadFile('https://raw.githubusercontent.com/Netsmart-OneTeam/sysmon-config/master/Auto_update.bat','C:\Sysmon\Auto_Update.bat')"
sysmon64.exe -accepteula -i sysmonconfig-export.xml
echo [+] Sysmon Successfully Installed!
REM attrib +s +h +r c:\Sysmon
REM echo Y | cacls c:\Sysmon /e /p everyone:n
REM echo Y | cacls c:\Sysmon /p system:f
REM echo Y | cacls c:\Sysmon /p Administrators:f
sc failure Sysmon64 actions= restart/10000/restart/10000// reset= 120
echo [+] Sysmon Directory Permissions Reset and Services Hidden
REM sc sdset Sysmon64 D:(D;;DCLCWPDTSD;;;IU)(D;;DCLCWPDTSD;;;SU)(D;;DCLCWPDTSD;;;BA)(A;;CCLCSWLOCRRC;;;IU)(A;;CCLCSWLOCRRC;;;SU)(A;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)S:(AU;FA;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;WD)
echo [+] Creating Auto Update Task set to Hourly..
SchTasks /Create /RU SYSTEM /RL HIGHEST /SC HOURLY /TN Update_Sysmon_Rules /TR C:\Sysmon\Auto_Update.bat /F /ST %tasktime%
timeout /t 10
exit
