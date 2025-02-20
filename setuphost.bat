@echo off 
title OramicCOS Setup

:: ������ ����� ������
set /p archive=Enter setup image here (or load backup from e.g Backup001.zip, if 0, make new backup)
)
if %archive%==0 (cd C-\System16\backup
start MakeBackup.bat
cd..
cd..
cd..
exit
)

:: ������ ������� ����� (�� ��������� ������� �����)
set /p folder=Enter the folder to extract to (Leave blank to extract here):

:: ���� ����� �� �������, ���������� ������� ����������
if "%folder%"=="" set "folder=%CD%"

:: ���������, ���������� �� �����
if not exist "%archive%" ( 
    echo Error: Archive "%archive%" not found in the current directory!
    pause 
    exit 
)

:: ���������, ���������� �� 7z.exe � ������� �����
set "zipPath=%CD%\backup\7z.exe"
if not exist "%zipPath%" (
    echo Error: 7-Zip not found in the current directory!
    pause
    exit /b
)

echo Starting DVD copy...

:: ���������� 7-Zip ��� ���������� ������ � ������� �����
"%zipPath%" x "%archive%" -o"%folder%" -y

:: �������� ���������� ����������
if %errorlevel% neq 0 (
    echo Error: Failed to extract the archive.
    pause
    exit /b
)

:: ������� � ������������� ����� � ������ ���������
rmdir /s/q backup
cd "%folder%"
start C-\System16\oobe\oob.bat

echo Installer is unpacked into "%folder%".
pause