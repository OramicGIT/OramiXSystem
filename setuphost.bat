@echo off 
title OramicCOS Setup

:: Запрос имени архива
set /p archive=Enter setup image here (or load backup from e.g Backup001.zip, if 0, make new backup)
)
if %archive%==0 (cd C-\System16\backup
start MakeBackup.bat
cd..
cd..
cd..
exit
)

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

echo Starting DVD copy...

:: Используем 7-Zip для распаковки архива в целевую папку
"%zipPath%" x "%archive%" -o"%folder%" -y

:: Проверка завершения распаковки
if %errorlevel% neq 0 (
    echo Error: Failed to extract the archive.
    pause
    exit /b
)

:: Переход в распакованную папку и запуск установки
rmdir /s/q backup
cd "%folder%"
start C-\System16\oobe\oob.bat

echo Installer is unpacked into "%folder%".
pause