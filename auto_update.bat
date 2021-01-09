@echo on
cd C:\Sysmon\
@powershell Invoke-WebRequest -Uri "https://raw.githubusercontent.com/Netsmart-OneTeam/sysmon-config/main/sysmonconfig-export.xml" -OutFile "C:\Sysmon\sysmonconfig-export.xml"
timeout 30
sysmon64 -c sysmonconfig-export.xml
exit