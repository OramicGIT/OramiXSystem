@echo off
title Oramic Setup Server
set /p x=Archive (for example app.zip): 
set /p z=Folder (for example SxS): 

:: Проверяем, существует ли архив
if not exist "%x%" (
    echo Error: Archive "%x%" not found!
    pause
    exit
)

:: Создаём VBScript для распаковки
echo Set objShell = CreateObject("Shell.Application") > unzip.vbs
echo Set source = objShell.NameSpace("%CD%\%x%") >> unzip.vbs
echo Set target = objShell.NameSpace("%CD%\%z%") >> unzip.vbs
echo For Each file In source.Items >> unzip.vbs
echo target.CopyHere file, 16 >> unzip.vbs
echo Next >> unzip.vbs

:: Создаём папку для распаковки, если её нет
if not exist "%z%" mkdir "%z%"

:: Запускаем VBScript
cscript //nologo unzip.vbs

:: Удаляем временный VBS-скрипт
del unzip.vbs

echo Extraction completed!
pause