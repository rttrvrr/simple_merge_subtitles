@echo off
setlocal enabledelayedexpansion

:: ==========================================================
:: CONFIGURATION & PATHS (Adjust these as needed)
:: ==========================================================
set "MKVMERGE_PATH=.\mkvmerge.exe"
set "OUTPUT_DIR=D:\Videos\tmp"
:: ==========================================================

echo ========================================================
echo        MKVMERGE BATCH SUBTITLE INTEGRATION RUNNER
echo ========================================================
echo Target Output Directory: %OUTPUT_DIR%
echo.
echo Running pre-check folder scan...
echo --------------------------------------------------------

set /a TOTAL_VIDEOS=0
set /a MISSING_SUBS=0

:: Step 1: Pre-check loop to look for missing .ass files
for %%F in (*.mkv) do (
    set /a TOTAL_VIDEOS+=1
    set "FILENAME=%%~nF"
    if not exist "!FILENAME!.ass" (
        set /a MISSING_SUBS+=1
        echo [WARNING] Missing .ass file for: "%%F"
    )
)

echo --------------------------------------------------------
echo Scan Complete: Found %TOTAL_VIDEOS% video files.
if %MISSING_SUBS% GTR 0 (
    echo [ALERT] %MISSING_SUBS% video^(s^) do not have a matching .ass subtitle file.
    echo Please make sure the video and subtitle names match exactly!
) else (
    echo [SUCCESS] All videos have a matching .ass subtitle file.
)
echo --------------------------------------------------------
echo.

:CONFIRMATION
set /p "CHOICE=Do you still want to start the merging process? (Y/N): "

if /i "%CHOICE%"=="Y" goto START_PROCESS
if /i "%CHOICE%"=="N" goto CANCEL_PROCESS

echo Invalid input. Please enter Y or N.
echo.
goto CONFIRMATION

:START_PROCESS
echo.
echo Starting batch merging process...
echo --------------------------------------------------------

:: Create the output folder automatically if it does not exist
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

:: Loop through all .mkv files and perform the actual merge
for %%F in (*.mkv) do (
    set "FILENAME=%%~nF"
    
    :: Check if a matching .ass subtitle file exists
    if exist "!FILENAME!.ass" (
        echo Processing: "!FILENAME!"
        
        "%MKVMERGE_PATH%" -o "%OUTPUT_DIR%\!FILENAME!.mkv" "%%F" --language 0:ind --track-name "0:Indonesian" --default-track-flag 0:yes "!FILENAME!.ass"
        
        echo --------------------------------------------------------
    ) else (
        echo Skipping: "%%F" (Matching .ass file not found)
        echo --------------------------------------------------------
    )
)

echo All tasks completed successfully!
goto END

:CANCEL_PROCESS
echo.
echo Operation canceled by the user. Exiting script.
goto END

:END
pause
