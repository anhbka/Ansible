@echo off
:loop

netsh wlan show hostednetwork | find "Status" | find "started" > nul
if %errorlevel% neq 0 (
    echo Mobile hotspot is not running. Starting it...
    netsh wlan start hostednetwork
) else (
    echo Mobile hotspot is running.
)

timeout /t 600 > nul
goto loop