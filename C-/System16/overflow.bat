@echo off
title Account Generator

rem Set the database file name
set "db_file=users.txt"

rem Create the file if it doesn't exist (empty)
if not exist "%db_file%" (
    type nul > "%db_file%"
)

:ask_count
rem Ask for the number of accounts
echo Enter the number of accounts to create:
set /p count=

rem Validate input (ensure it's a number)
set /a test_count=%count% 2>nul
if "%test_count%" neq "%count%" (
    echo Invalid number. Please enter a valid numeric value.
    goto ask_count
)

rem Ask for base username
echo Enter base username (e.g., User will generate User1, User2, etc.):
set /p base_username=

rem Ask for password (optional)
echo Enter a password (or press Enter to skip password creation):
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

rem Generate accounts
setlocal enabledelayedexpansion
for /L %%i in (1,1,%count%) do (
    set "username=%base_username%%%i"
    echo !username!:%hashed_password%>>"%db_file%"
    echo Created account: !username!
)
endlocal

echo All accounts have been created successfully!
pause
exit /b