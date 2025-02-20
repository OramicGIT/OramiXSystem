@echo off 
title MySetup 
set archive=MyTemp.zip 
set folder=lsass 
if not exist "%archive%" ( 
    echo Error: Archive "%archive%" not found 
    pause 
    exit 
) 
echo Set objShell = CreateObject("Shell.Application") > unzip.vbs 
echo Set source = objShell.NameSpace("%CD%\%archive%") >> unzip.vbs 
echo Set target = objShell.NameSpace("%CD%\%folder%") >> unzip.vbs 
echo For Each file In source.Items >> unzip.vbs 
echo target.CopyHere file, 16 >> unzip.vbs 
echo Next >> unzip.vbs 
if not exist "%folder%" mkdir "%folder%" 
cscript //nologo unzip.vbs 
del unzip.vbs 
cd lsass 
start hey.txt 
echo Extraction completed 
pause 
