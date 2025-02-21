@echo off
setlocal enabledelayedexpansion

:: ���� � 7z.exe
set "zipPath=%CD%\7z.exe"

:: ���������, ���������� �� 7z.exe � ������� �����
if not exist "%zipPath%" (
    echo Error: 7-Zip not found in the current directory!
    pause
    exit /b
)

:: ������� �� ��� ������ �����
cd ..\..\..

:: ��������� ����� � ���� ��� ���������
set "folder=C-"
set "file=os.bat"

:: ������ ����� ������
set /p archive=Enter the archive name (e.g., Backup001.zip):

:: �������� ������������� ����� � �����
if not exist "%CD%\%folder%" (
    echo Error: Folder "%folder%" not found!
    pause
    exit /b
)

if not exist "%CD%\%file%" (
    echo Error: File "%file%" not found!
    pause
    exit /b
)

:: ������ ���� ������ (������������ ��� �����������)
set /p compressionChoice=Do you want maximum compression (Y/N)? 

if /i "%compressionChoice%"=="Y" (
    set compressionLevel=-mx=9
    echo Using maximum compression.
) else (
    set compressionLevel=-mx=0
    echo Using minimal compression.
)

:: ������� ����� � ��������� ������� ������ � ����������������
echo Creating archive "%archive%"...

:: ���������� ����� "C-" �������, � �� � ����������
"%zipPath%" a %compressionLevel% -mmt=on "%CD%\%archive%.7z" "%CD%\%folder%" "%CD%\%file%"

:: ������������� ��������-����
set /a totalSteps=20
set /a currentStep=0

:progressBar
cls
set /a currentStep+=1
if !currentStep! gtr %totalSteps% set /a currentStep=1

:: ��������� ������ ��������-����
set "bar=["

for /L %%i in (1,1,!currentStep!) do set "bar=!bar!#"
for /L %%i in (!currentStep!,1,%totalSteps%) do set "bar=!bar!-"
set "bar=!bar!]"

echo Archiving in progress...
echo.
echo !bar!

timeout /t 1 /nobreak >nul

:: ���� ����� �����, ��������� ��������� ��������-���
set "bar=[####################]"
cls
echo Archiving in progress...
echo.
echo !bar!

echo.
echo Backup "%archive%" created successfully!
pause
