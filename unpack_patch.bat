@echo off

set OLD_PATH=%PATH%
set current_folder=%CD%
set script_dir=%~dp0

rem Uncomment/update this to use Cygwin instead of Bash on Windows
rem set PATH=d:\local\cygwin\bin\;%PATH%
set BASH_CMD=bash
set script_file=unpack_patch.bat

if "%BIN_BASE_FOLDER%"=="" (
    echo %script_file%: BIN_BASE_FOLDER not set
    goto exit_abort
)
if "%SOURCE_BASE_FOLDER%"=="" (
    echo %script_file%: SOURCE_BASE_FOLDER not set
    goto exit_abort
)
if "%TMP_BASE_FOLDER%"=="" (
    echo %script_file%: TMP_BASE_FOLDER not set
    goto exit_abort
)
if "%BOOST_VERSION%"=="" (
    echo %script_file%: BOOST_VERSION not set
    goto exit_abort
)
if "%BOOST_SOURCE_FOLDER%"=="" (
    echo %script_file%: BOOST_SOURCE_FOLDER not set
    goto exit_abort
)
if "%BZIP2_VERSION%"=="" (
    echo %script_file%: BZIP2_VERSION not set
    goto exit_abort
)
if "%ZLIB_VERSION%"=="" (
    echo %script_file%: ZLIB_VERSION not set
    goto exit_abort
)


echo %script_file%: running in %current_folder%
echo %script_file%: BIN_BASE_FOLDER="%BIN_BASE_FOLDER%"
echo %script_file%: SOURCE_BASE_FOLDER="%SOURCE_BASE_FOLDER%"
echo %script_file%: TMP_BASE_FOLDER="%TMP_BASE_FOLDER%"

cd %script_dir%
for /f "tokens=*" %%i in ( '%BASH_CMD% -c "pwd"' ) do set script_dir_bash=%%i
cd %current_folder%

mkdir "%BIN_BASE_FOLDER%"
cd %BIN_BASE_FOLDER% || goto exit_abort
for /f "tokens=*" %%i in ( '%BASH_CMD% -c "pwd"' ) do set bin_base_folder_bash=%%i
cd %current_folder%

mkdir "%SOURCE_BASE_FOLDER%"
cd %SOURCE_BASE_FOLDER% || goto exit_abort
for /f "tokens=*" %%i in ( '%BASH_CMD% -c "pwd"' ) do set source_base_folder_bash=%%i
cd %current_folder%

mkdir "%TMP_BASE_FOLDER%"
cd %TMP_BASE_FOLDER% || goto exit_abort
for /f "tokens=*" %%i in ( '%BASH_CMD% -c "pwd"' ) do set tmp_base_folder_bash=%%i
echo #!/bin/bash > source_env.sh
echo export BIN_BASE_FOLDER="%bin_base_folder_bash%" >> source_env.sh
echo export SOURCE_BASE_FOLDER="%source_base_folder_bash%" >> source_env.sh
echo export TMP_BASE_FOLDER="%tmp_base_folder_bash%" >> source_env.sh
echo export BOOST_VERSION=%BOOST_VERSION% >> source_env.sh
echo export BZIP2_VERSION=%BZIP2_VERSION% >> source_env.sh
echo export ZLIB_VERSION=%ZLIB_VERSION% >> source_env.sh

rem Running unpack_patch from the TMP folder
%BASH_CMD% -c "bash \"%script_dir_bash%/unpack_patch.sh\" --skip_boost_bootstrap"
set bash_result=%ERRORLEVEL%
cd %current_folder%
set PATH=%OLD_PATH%
if %bash_result% NEQ 0 (
    echo %script_file%: unpack_patch.sh failed ^(code: %bash_result%^)
    goto exit_abort
) 

if exist %BIN_BASE_FOLDER%\b2.exe (
    if exist %BIN_BASE_FOLDER%\bjam.exe (
        echo %script_file%: Skipping already run Boost.bootstrap
        goto exit_success
    )
)
echo %script_file%: Running Boost.bootstrap..
cd %BOOST_SOURCE_FOLDER%\tools\build || goto exit_abort
call bootstrap.bat >bootstrap.bat.output.txt
set bootstrap_result=%ERRORLEVEL%
if %bootstrap_result% NEQ 0 (
    echo %script_file%: bootstrap.bat failed ^(code: %bootstrap_result%^)
    goto exit_abort
)
else (
    echo %script_file%: bootstrap.bat is done
)
copy b2.exe %BIN_BASE_FOLDER%\b2.exe || goto exit_abort
copy bjam.exe %BIN_BASE_FOLDER%\bjam.exe || goto exit_abort

:exit_success
set PATH=%OLD_PATH%
cd %current_folder%
echo %script_file%: successful
exit /b 0

:exit_abort
cd %current_folder%
set PATH=%OLD_PATH%
echo %script_file%: failed
exit /b 1

