@echo off
title CRASHED
type bsod.txt
timeout /t 5 >nul
cd..
cd..
echo System encounted an error! 0x000CRASH (0x000000) >> crashed.log
exit