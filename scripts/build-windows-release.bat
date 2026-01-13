@echo off
REM Build script for MapMap Windows Release
REM This script builds MapMap and creates a release package

echo ========================================
echo MapMap Windows Release Build Script
echo ========================================
echo.

REM Check if Qt is in PATH
where qmake >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: qmake not found in PATH
    echo Please ensure Qt is installed and added to PATH
    echo Example: set PATH=C:\Qt\5.15.2\mingw81_64\bin;%PATH%
    exit /b 1
)

REM Check if GStreamer is installed
if not exist "C:\gstreamer\1.0\mingw_x86_64\bin" (
    echo WARNING: GStreamer not found at C:\gstreamer\1.0\mingw_x86_64
    echo Please install GStreamer from https://gstreamer.freedesktop.org/
)

REM Get version
set /p VERSION=<VERSION.txt
echo Building MapMap version %VERSION%
echo.

REM Clean previous build
echo Cleaning previous build...
if exist release rmdir /s /q release
if exist debug rmdir /s /q debug
if exist Makefile del /q Makefile

REM Configure
echo Configuring with qmake...
qmake mapmap.pro CONFIG+=release
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: qmake configuration failed
    exit /b 1
)

REM Build
echo Building...
mingw32-make -j%NUMBER_OF_PROCESSORS%
if %ERRORLEVEL% NEQ 0 (
    echo ERROR: Build failed
    exit /b 1
)

REM Create package
echo.
echo Creating release package...
set PACKAGE_NAME=MapMap-%VERSION%-Windows-x64
mkdir release\%PACKAGE_NAME%

REM Copy executable
copy release\mapmap.exe release\%PACKAGE_NAME%\MapMap.exe

REM Deploy Qt dependencies
echo Deploying Qt dependencies...
windeployqt --release --no-translations release\%PACKAGE_NAME%\MapMap.exe

REM Copy GStreamer DLLs
echo Copying GStreamer DLLs...
if exist "C:\gstreamer\1.0\mingw_x86_64\bin" (
    xcopy "C:\gstreamer\1.0\mingw_x86_64\bin\*.dll" release\%PACKAGE_NAME%\ /Y /Q
    mkdir release\%PACKAGE_NAME%\gstreamer-plugins
    xcopy "C:\gstreamer\1.0\mingw_x86_64\lib\gstreamer-1.0\*.dll" release\%PACKAGE_NAME%\gstreamer-plugins\ /Y /Q
)

REM Copy documentation
copy README.md release\%PACKAGE_NAME%\
copy LICENSE release\%PACKAGE_NAME%\
copy INSTALL.md release\%PACKAGE_NAME%\
copy CHANGELOG.md release\%PACKAGE_NAME%\

REM Create README for Windows users
echo MapMap for Windows > release\%PACKAGE_NAME%\WINDOWS_README.txt
echo ================== >> release\%PACKAGE_NAME%\WINDOWS_README.txt
echo. >> release\%PACKAGE_NAME%\WINDOWS_README.txt
echo Installation: >> release\%PACKAGE_NAME%\WINDOWS_README.txt
echo 1. Extract all files to a folder of your choice >> release\%PACKAGE_NAME%\WINDOWS_README.txt
echo 2. Run MapMap.exe >> release\%PACKAGE_NAME%\WINDOWS_README.txt
echo. >> release\%PACKAGE_NAME%\WINDOWS_README.txt
echo For more information, visit: https://mapmapteam.github.io/ >> release\%PACKAGE_NAME%\WINDOWS_README.txt

REM Create ZIP archive
echo Creating ZIP archive...
cd release
if exist "%PACKAGE_NAME%.zip" del "%PACKAGE_NAME%.zip"
powershell Compress-Archive -Path %PACKAGE_NAME% -DestinationPath %PACKAGE_NAME%.zip
cd ..

echo.
echo ========================================
echo Build completed successfully!
echo Package: release\%PACKAGE_NAME%.zip
echo ========================================
