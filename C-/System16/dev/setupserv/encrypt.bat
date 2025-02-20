@echo off
setlocal enabledelayedexpansion
title Oramic Installer Creator

:: Запрос параметров
set /p folder=Enter the folder to archive (e.g., MyApp): 
set /p archive=Enter the archive name (e.g., MyApp.zip): 
set /p installer=Enter the installer name (e.g., Setup_MyApp.bat):
set /p title=Enter the installer title (e.g; Setup_APP):
set /p fold=Enter the installer folder (this is a procentfoldprocent)
set /p run=Enter app cmdline (e.g; cmd.exe /b):

:: Проверяем, существует ли папка
if not exist "%folder%" (
    echo Error: Folder "%folder%" not found!
    pause
    exit
)

:: Создаём VBS-скрипт для архивации
set vbsFile=zip.vbs
echo Set Args = Wscript.Arguments > %vbsFile%
echo source = Args(0) >> %vbsFile%
echo target = Args(1) >> %vbsFile%
echo Set objFSO = CreateObject("Scripting.FileSystemObject") >> %vbsFile%
echo Set zip = objFSO.OpenTextFile(target, 2, vbtrue) >> %vbsFile%
echo zip.Write "PK" ^& Chr(5) ^& Chr(6) ^& String(18, Chr(0)) >> %vbsFile%
echo zip.Close >> %vbsFile%
echo Set objShell = CreateObject("Shell.Application") >> %vbsFile%
echo Wscript.Sleep 500 >> %vbsFile%
echo objShell.NameSpace(target).CopyHere objShell.NameSpace(source).Items >> %vbsFile%
echo Wscript.Sleep 5000 >> %vbsFile%

:: Запускаем VBS-архивацию
cscript //nologo %vbsFile% "%CD%\%folder%" "%CD%\%archive%"

del %vbsFile%

:: Создаём установщик (BAT)
echo @echo off > "%installer%"
echo title %title% >> "%installer%"
echo set archive=%archive% >> "%installer%"
echo set folder=%fold% >> "%installer%"
echo if not exist "%%archive%%" ( >> "%installer%"
echo     echo Error: Archive "%%archive%%" not found! >> "%installer%"
echo     pause >> "%installer%"
echo     exit >> "%installer%"
echo ) >> "%installer%"
echo echo Set objShell = CreateObject("Shell.Application") ^> unzip.vbs >> "%installer%"
echo echo Set source = objShell.NameSpace("%%CD%%\%%archive%%") ^>^> unzip.vbs >> "%installer%"
echo echo Set target = objShell.NameSpace("%%CD%%\%%folder%%") ^>^> unzip.vbs >> "%installer%"
echo echo For Each file In source.Items ^>^> unzip.vbs >> "%installer%"
echo echo target.CopyHere file, 16 ^>^> unzip.vbs >> "%installer%"
echo echo Next ^>^> unzip.vbs >> "%installer%"
echo if not exist "%%folder%%" mkdir "%%folder%%" >> "%installer%"
echo cscript //nologo unzip.vbs >> "%installer%"
echo del unzip.vbs >> "%installer%"
echo cd %fold% >> "%installer%"
echo start %run% >> "%installer%"
echo echo Extraction completed! >> "%installer%"
echo pause >> "%installer%"

echo Installer "%installer%" created successfully!
pause