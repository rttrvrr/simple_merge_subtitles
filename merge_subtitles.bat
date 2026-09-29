@echo off
setlocal enabledelayedexpansion

:: ==========================================================
:: CONFIGURATION & PATHS (Adjust these as needed)
:: ==========================================================
set "MKVMERGE_PATH=C:\Program Files\MKVToolNix\mkvmerge.exe"
set "OUTPUT_DIR=D:\Videos\tmp"
:: ==========================================================

:: Create the output folder automatically if it does not exist
if not exist "%OUTPUT_DIR%" mkdir "%OUTPUT_DIR%"

echo Starting batch merging process...
echo Target Directory: %OUTPUT_DIR%
echo --------------------------------------------------------

:: Loop through all .mkv files in the current folder
for %%F in (*.mkv) do (
    set "FILENAME=%%~nF"
    
    :: Check if a matching .ass subtitle file exists
    if exist "!FILENAME!.ass" (
        echo Processing: "!FILENAME!"
        
        "%MKVMERGE_PATH%" -o "%OUTPUT_DIR%\!FILENAME!.mkv" "%%F" --language 0:ind --default-track-flag 0:yes "!FILENAME!.ass"
        
        echo --------------------------------------------------------
    ) else (
        echo Skipping: "%%F" (Matching .ass file not found)
        echo --------------------------------------------------------
    )
)

echo All tasks completed successfully!
pause
