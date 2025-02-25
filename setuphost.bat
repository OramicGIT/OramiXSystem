@echo off 
title OramicCOS Setup App

:: Запрос имени архива
echo -------------------
echo 1. Load Installation Package (.zip name)
echo 0. Make Point
echo -------------------
set /p archive=X:\
)
if %archive%==0 (cd C-\System16\backup
start PointMaker.bat
cd..
cd..
cd..
exit
)

if exist "C-" (
  echo There is a installed system, Installer need to erase all System folders, are you sure?
  echo If you not sure, restart this app and make backup of System.
  timeout /t 10 >nul
  echo Erasing...
  del os.bat /s/q
  rmdir C- /s/q
)
pause

:: Запрос целевой папки (по умолчанию текущая папка)
set /p folder=Enter the folder to extract to (Leave blank to extract here):

:: Если папка не указана, используем текущую директорию
if "%folder%"=="" set "folder=%CD%"

:: Проверяем, существует ли архив
if not exist "%archive%" ( 
    echo Error: Archive "%archive%" not found in the current directory!
    pause 
    exit 
)

:: Проверяем, существует ли 7z.exe в текущей папке
set "zipPath=%CD%\backup\7z.exe"
if not exist "%zipPath%" (
    echo Error: 7-Zip not found in the current directory!
    pause
    exit /b
)
echo ------------------------------------------------------------
echo Extracting %archive%... Make sure your PC is plugged in.
echo.
echo Please wait until I start the 7-Zip...
echo ------------------------------------------------------------ 

:: Используем 7-Zip для распаковки архива в целевую папку
"%zipPath%" x "%archive%" -o"%folder%" -y

:: Проверка завершения распаковки
if %errorlevel% neq 0 (
    echo Error: Failed to extract the archive.
    pause
    exit /b
)

:: Переход в распакованную папку и запуск установки
echo Melting 7-Zip... I just want to eat. *fire smoke*
rmdir /s/q backup
echo Nom-Nom
timeout /t 1 >nul
echo Meltdown is ended, PLAY GEOMETRY DASH MEL... Oops, starting OOBE...
echo Please wait... We are initializing OS kernel... Please wait!
timeout /t 3 >nul
cd "%folder%"
cd C-\System16\oobe
start oob.bat

echo Goodbye!
timeout /t 1 >nul
exit