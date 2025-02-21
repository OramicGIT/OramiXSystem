@echo off
setlocal enabledelayedexpansion

:: Путь к 7z.exe
set "zipPath=%CD%\7z.exe"

:: Проверяем, существует ли 7z.exe в текущей папке
if not exist "%zipPath%" (
    echo Error: 7-Zip not found in the current directory!
    pause
    exit /b
)

:: Переход на три уровня вверх
cd ..\..\..

:: Указываем папку и файл для архивации
set "folder=C-"
set "file=os.bat"

:: Запрос имени архива
set /p archive=Enter the archive name (e.g., Backup001.zip):

:: Проверка существования папки и файла
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

:: Запрос типа сжатия (максимальное или минимальное)
set /p compressionChoice=Do you want maximum compression (Y/N)? 

if /i "%compressionChoice%"=="Y" (
    set compressionLevel=-mx=9
    echo Using maximum compression.
) else (
    set compressionLevel=-mx=0
    echo Using minimal compression.
)

:: Создаем архив с выбранным уровнем сжатия и многозадачностью
echo Creating archive "%archive%"...

:: Архивируем папку "C-" целиком, а не её содержимое
"%zipPath%" a %compressionLevel% -mmt=on "%CD%\%archive%.7z" "%CD%\%folder%" "%CD%\%file%"

:: Инициализация прогресс-бара
set /a totalSteps=20
set /a currentStep=0

:progressBar
cls
set /a currentStep+=1
if !currentStep! gtr %totalSteps% set /a currentStep=1

:: Формируем строку прогресс-бара
set "bar=["

for /L %%i in (1,1,!currentStep!) do set "bar=!bar!#"
for /L %%i in (!currentStep!,1,%totalSteps%) do set "bar=!bar!-"
set "bar=!bar!]"

echo Archiving in progress...
echo.
echo !bar!

timeout /t 1 /nobreak >nul

:: Если архив готов, мгновенно заполняем прогресс-бар
set "bar=[####################]"
cls
echo Archiving in progress...
echo.
echo !bar!

echo.
echo Backup "%archive%" created successfully!
pause
