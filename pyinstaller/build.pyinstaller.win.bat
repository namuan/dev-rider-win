REM @echo off

setlocal

REM ......................setup variables......................
if [%1]==[] (
    SET ARCH=64
) else (
    SET ARCH=%1
)

if [%2]==[] (
    SET PASS="CHANGEIT"
) else (
    SET PASS=%2
)

if ["%ARCH%"]==["64"] (
    SET BINARCH=x64
    SET PYPATH=C:\Python36-x64
)

REM ......................get latest version number......................
for /f "delims=" %%a in ('%PYPATH%\python.exe version.py') do @set APPVER=%%a

REM ......................cleanup previous build scraps......................
rd /s /q build
rd /s /q dist
if not exist "..\..\bin\" ( mkdir ..\..\bin\ ) else ( del /q ..\..\bin\*.* )

REM ......................run pyinstaller......................
"%PYPATH%\scripts\pyinstaller.exe" --clean devrider.win%ARCH%.spec

REM ......................add metadata to built Windows binary......................
.\verpatch.exe dist\devrider.exe

if exist "dist\devrider.exe" (
    REM ......................add metadata to built Windows binary......................
    REM .\verpatch.exe dist\devrider.exe /va %APPVER%.0 /pv %APPVER%.0 /s desc "DevRider" /s name "DevRider" /s copyright "(c) 2019 DR" /s product "DevRider %BINARCH%" /s company "deskriders.dev"

    REM ................sign frozen EXE with self-signed certificate..........
    SignTool.exe sign /f "..\certs\DevRider.pfx" /t http://timestamp.comodoca.com/authenticode /p %PASS% dist\devrider.exe

    REM ......................call Inno Setup installer build script......................
     cd ..\InnoSetup
    "C:\Program Files (x86)\Inno Setup 5\iscc.exe" installer_%BINARCH%.iss

    REM ................sign final redistributable EXE with self-signed certificate..........
    SignTool.exe sign /f "..\certs\DevRider.pfx" /t http://timestamp.comodoca.com/authenticode /p %PASS% output\DevRider-%APPVER%-setup-win%ARCH%.exe

    cd ..\pyinstaller
)

endlocal