@echo off
setlocal enabledelayedexpansion

@REM Set static variables
set website=https://nim-lang.org/install_windows.html
set temp=install_windows_temp.html
set print=powershell write-host -fore

@REM Detect the latest stable version from nim on the official website
curl -s %website% > %temp%

@REM Read the content of the fetched HTML file
set "html="
for /f "delims=" %%a in (%temp%) do (
    set "html=!html!%%a"
)

%print% DarkGray "Searching for the most stable nim version..."
@REM Extract nim version number
for /f "tokens=2 delims=-" %%a in ('type install_windows_temp.html ^| findstr /r "nim-[0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*"') do (
    set "version=%%a"
    set "version=!version:~0,5!"
)

@REM Print the nim version we found
%print% Green Current nim stable version is !version!

@REM Delete the temp file 
del %temp%

@REM Get the windows binary version from user
echo:
set /p windows_version="What binary version you want to download? x64 or x32 ( Default: x64 ): " || set "windows_version=x64"
echo The windows binary version was set to %windows_version%

@REM Set the download URL
set filename=nim-!version!_!windows_version!.zip
set output_folder=nim-!version!_!windows_version!
set download_url=https://nim-lang.org/download/!filename!

echo:
%print% DarkGreen "Downloading nim binary from !download_url!"

@REM Download the binary zip using curl
curl -O !download_url!
%print% Green Successfully downloaded the nim binary

@REM Unzip the archieve using powershell
echo:
%print% DarkGray Extracting the archieve from !filename!
powershell Expand-Archive -Force !filename! .
%print% Green Successfully extracted the archieve to !output_folder!

@REM Remove the local zip file
del !filename!

@REM Move the folder content to the current directory
echo:
%print% DarkGray "Getting everything ready for installiation"
call move.bat nim-!version!\ .
rd /s /q nim-!version!\

@REM Wait for 2 seconds
ping 127.0.0.10 -n 2 > nul

@REM Install nim now
echo:
%print% DarkGray Installing nim on the local machine
finish.exe
%print% Green Successfully installed nim on the local machine!

pause