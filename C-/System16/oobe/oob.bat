@echo off
echo Go to C-\System16\oobe\gpl.txt and read this file!
set /p y=Agree?
)
if %y%==yes (goto os
)
if %y%==no (exit
)
:os
cd ..
title Setup your OS!
echo First, we need to create your profile!
whoami

:: Login Shell
:log
title User Accounts

rem Set the database file name
set "db_file=users.txt"

rem Create the database file if it doesn't exist (empty)
if not exist "%db_file%" (
    type nul > "%db_file%"
)

:signup
rem User registration
echo Enter a name:
set /p n=

rem Trim spaces (removes leading and trailing spaces)
for /f "tokens=* delims= " %%A in ("%n%") do set "n=%%A"

rem Check if n already exists
findstr /i "^%n%:" "%db_file%" >nul
if %errorlevel% equ 0 (
    echo The name "%n%" is already registered.
    pause
    goto signup
)

rem Ask for password
echo Enter a password (or just click enter to skip password creation):
set /p password=

rem Trim spaces from password
for /f "tokens=* delims= " %%A in ("%password%") do set "password=%%A"

rem Hash the password using CertUtil
echo|set /p=%password%> temp.txt
certutil -hashfile temp.txt SHA256 > hash.txt
for /f "tokens=2 delims= " %%A in ('findstr /v /c:"hashfile" hash.txt') do set "hashed_password=%%A"

rem Clean up temporary files
del temp.txt
del hash.txt

rem Save n and hashed password to the database
echo %n%:%hashed_password%>>"%db_file%"

echo Account created successfully!
pause
cls
goto shell1

:shell1
title Component Removal
echo We created your own profile!
timeout /t 1 >nul
cls
echo Next... components setup!
timeout /t 1 >nul
echo You need to find components manually.
timeout /t 1 >nul

:: New stages (placeholders, modify as needed)
:stage2
echo Stage 2: Configuring system settings...
timeout /t 2 >nul
goto stage3

:stage3
echo Stage 3: Installing necessary services...
timeout /t 2 >nul
goto stage4

:stage4
echo Stage 4: Finalizing setup...
timeout /t 2 >nul
cls
goto cmd

:: UltraRemover
:cmd
echo _______________________________
echo Welcome to Oramic UltraRemover
echo 1. Explore files
echo 2. Go to folder
echo 3. Leave
echo 4. Delete file
echo 5. Remove folder
echo _______________________________
set /p x=Choose an option: 

if "%x%"=="1" goto a
if "%x%"=="2" goto g
if "%x%"=="3" goto s
if "%x%"=="4" goto delete_file
if "%x%"=="5" goto delete_folder

goto cmd

:delete_file
set /p z=Enter the file to delete: 
del /s /q "%z%"
goto cmd

:delete_folder
set /p q=Enter the folder to remove: 
rmdir /s /q "%q%"
goto cmd

:s
goto wex

:g
set /p g=Enter directory path: 
cd /d "%g%"
goto cmd

:a
dir
timeout /t 1 >nul
goto cmd

:wex
echo Components removed!
pause
exit
