@echo off
echo Your device has encountered a critical error and needs to be reinstalled or recovered.
timeout /t 1 >nul
echo We could not find the system bootloader partition.
timeout /t 1 >nul
echo The system is unable to boot without the required partition.
timeout /t 1 >nul
echo Please check the boot partition or repair the system installation.
timeout /t 1 >nul
echo If this is your first time seeing this error, try restarting your device.
timeout /t 1 >nul
echo If the problem persists, please check for updates or contact support.
timeout /t 1 >nul
echo Error Code: MISSING_BOOT_PARTITION
timeout /t 1 >nul
echo Technical Information:
timeout /t 1 >nul
echo *** STOP: 0x000000009A (0x, 0x0F1, 0x0000NOXERROR)
timeout /t 1 >nul
echo Failed to create dump file due to missing boot partition or disk (C:-).
timeout /t 1 >nul
echo Unable to dump physical memory to disk.
pause

