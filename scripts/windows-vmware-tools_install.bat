if not exist "C:\Windows\Temp\7z920-x64.msi" (
    powershell -Command "(New-Object System.Net.WebClient).DownloadFile('http://downloads.sourceforge.net/sevenzip/7z920-x64.msi', 'C:\Windows\Temp\7z920-x64.msi')" <NUL
)
msiexec /qb /i C:\Windows\Temp\7z920-x64.msi

if exist "C:\Users\vagrant\windows.iso" (
    move /Y C:\Users\vagrant\windows.iso C:\Windows\Temp
)

cmd /c ""C:\Program Files\7-Zip\7z.exe" x "C:\Windows\Temp\windows.iso" -oC:\Windows\Temp\VMWare"
cmd /c C:\Windows\Temp\VMWare\setup.exe /S /v"/qn REBOOT=R\"

msiexec /qb /x C:\Windows\Temp\7z920-x64.msi