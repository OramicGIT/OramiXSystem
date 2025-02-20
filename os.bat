@echo off
:: Set the environment
color 0a
title OramicCOS - 0.7
set "folder=C-\"

:: Проверка существования папки
if not exist "%folder%" (
   call bspd.bat
)

:: Boot manager
echo ======================================
echo            COSBoot Manager
echo ======================================
echo 1. Windows
echo 2. OramicCOS
echo 3. Shell Shutdown if you made this as a shell
echo 4. Go to logon UI
echo 5. Go to backup
:mgr
set /p boot=X:\
)
if %boot%==1 (
    choice /c 12 /m "Is this a shell?:"

    if %errorlevel%==1 (
        start explorer
    ) else if %errorlevel%==2 (
        exit
    )
)
if %boot%==2 (
    cls
    goto boot
)
if %boot%==3 (
    shutdown /s /t 5
)
if %boot%==4 (
    logoff
)
if %boot%==5 (start setuphost.bat
)
goto mgr

:: Boot
:boot
echo Loading C:\ image
echo Loading X:\ image
echo Loading external images
echo Starting Autoload image
set "appFolder=C-\Autoload"

for %%a in ("%appFolder%\*.exe" "%appFolder%\*.bat" "%appFolder%\*.cmd" "%appFolder%\*.vbs" "%appFolder%\*.lnk") do (
    REM Start file
    start "" "%%a"
)
timeout /t 5 >nul
echo Loading Kernel
timeout /t 2 >nul
echo Ending loading...
timeout /t 12 >nul
echo Loading Desktop Host...
cls
goto log

:: Login Shell
:log

rem Set the database file name
set "db_file=C-\System16\users.txt"

rem Create the database file if it doesn't exist (empty)
if not exist "%db_file%" (
    type nul > "%db_file%"
)

rem Create the output file if it doesn't exist (empty)
set "output_file=C-\System16\output.txt"
if not exist "%output_file%" (
    type nul > "%output_file%"
)

rem Show menu
echo Choose an option:
echo 1 - Login
echo 2 - Sign up
set /p choice="Enter your choice: "

if "%choice%"=="1" goto login
if "%choice%"=="2" goto signup

echo Invalid choice.
pause
exit /b

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
    goto log
)

rem Ask for password
echo Enter a password (or just click enter to skip password creating):
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
echo Name "%n%" has been registered! >> "%output_file%"
pause
goto shell1  :: Add this line to proceed to the OS shell after registration

:login
rem User login
echo Enter your name:
set /p n=

rem Trim spaces
for /f "tokens=* delims= " %%A in ("%n%") do set "n=%%A"

rem Check if n exists
findstr /i "^%n%:" "%db_file%" >nul
if %errorlevel% neq 0 (
    echo Name not found.
    pause
    goto log  :: Ensure we go back to login if the name is not found
)

rem Ask for password
echo Enter your password:
set /p password=

rem Trim spaces from password
for /f "tokens=* delims= " %%A in ("%password%") do set "password=%%A"

rem Hash the entered password
echo|set /p=%password%> temp.txt
certutil -hashfile temp.txt SHA256 > hash.txt
for /f "tokens=2 delims= " %%A in ('findstr /v /c:"hashfile" hash.txt') do set "hashed_password=%%A"

rem Clean up temporary files
del temp.txt
del hash.txt

rem Verify password
for /f "tokens=2 delims=:" %%A in ('findstr /i "^%n%:" "%db_file%"') do set "stored_password=%%A"

if "%hashed_password%"=="%stored_password%" (
    echo Login successful!
    echo User "%n%" logged in successfully! >> "%output_file%"
    pause
    goto shell1  :: After successful login, go to the OS shell
) else (
    echo Incorrect password.
    echo Failed login attempt for "%n%" >> "%output_file%"
    pause
    goto log  :: Go back to login prompt after failed login
)
:: OS
:shell1
cd..
cd..
echo Hello, %n%! Enter 'help' to see all commands
goto shell
:shell
set /p x=C:\
)
if %x%==urf (
    title URF_OS - Thanks URF!
)
if %x%==help (
    echo run - Start apps, exp - Explore files, theme - Apply custom theme
)
if %x%==run (
    set /p app=Select an app to run:
    start %app%
)
if %x%==exp (
    start C-\System16\explorer.bat
)
if %x%==theme (
    color
    set /p theme=Select theme
    color %theme%
)
goto shell