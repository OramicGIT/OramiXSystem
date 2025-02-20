@echo off
:cmd
echo .....................
echo Welcome to Oramic Exploring
echo 1. Explore files
echo 2. Go to
echo 3. Leave
echo 4. Clear console
echo .....................
set /p x=
)
if %x%==1 (goto e)
)
if %x%==2 (goto g)
)
if %x%==3 (goto s)
)
if %x%==4 (cls)
)
goto cmd


:s
exit /b
:g
set /p g=Directory:
cd %g%
goto cmd
:e
dir
timeout /t 1 >nul
goto cmd
