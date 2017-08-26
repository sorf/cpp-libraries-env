@echo off

set BASH_CMD=bash
set script_file=unpack_patch.bat

if "%SOURCE_BASE_FOLDER%"=="" (
    echo %script_file%: SOURCE_BASE_FOLDER not set
    exit /b 1
)
if "%TMP_BASE_FOLDER%"=="" (
    echo %script_file%: TMP_BASE_FOLDER not set
    exit /b 1
)
if "%BOOST_VERSION%"=="" (
    echo %script_file%: BOOST_VERSION not set
    exit /b 1
)
if "%BZIP2_VERSION%"=="" (
    echo %script_file%: BZIP2_VERSION not set
    exit /b 1
)
if "%ZLIB_VERSION%"=="" (
    echo %script_file%: ZLIB_VERSION not set
    exit /b 1
)


set current_folder=%CD%
set script_dir=%~dp0
echo %script_file%: running in %current_folder%
echo %script_file%: SOURCE_BASE_FOLDER="%SOURCE_BASE_FOLDER%"
echo %script_file%: TMP_BASE_FOLDER="%TMP_BASE_FOLDER%"

cd %script_dir%
for /f "tokens=*" %%i in ( '%BASH_CMD% -c "pwd"' ) do set script_dir_bash=%%i
cd %current_folder%

cd %SOURCE_BASE_FOLDER% || exit /b 1
for /f "tokens=*" %%i in ( '%BASH_CMD% -c "pwd"' ) do set source_base_folder_bash=%%i
cd %current_folder%

mkdir "%TMP_BASE_FOLDER%"
cd %TMP_BASE_FOLDER% || exit /b 1
for /f "tokens=*" %%i in ( '%BASH_CMD% -c "pwd"' ) do set tmp_base_folder_bash=%%i
echo #!/bin/bash > source_env.sh
echo export SOURCE_BASE_FOLDER="%source_base_folder_bash%" >> source_env.sh
echo export TMP_BASE_FOLDER="%tmp_base_folder_bash%" >> source_env.sh
echo export BOOST_VERSION=%BOOST_VERSION% >> source_env.sh
echo export BZIP2_VERSION=%BZIP2_VERSION% >> source_env.sh
echo export ZLIB_VERSION=%ZLIB_VERSION% >> source_env.sh

rem Running unpack_patch from the TMP folder
%BASH_CMD% -c "bash \"%script_dir_bash%/unpack_patch.sh\""
set bash_result=%ERRORLEVEL%
cd %current_folder%


if %bash_result% NEQ 0 (
    echo %script_file%: unpack_patch.sh failed ^(code: %bash_result%^)
)
exit /b %bash_result%

