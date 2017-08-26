@echo off

if "%BOOST_TOOLSET%"=="" (
    echo BOOST_TOOLSET not set
    exit /b 1
)
if "%DEBUG_RELEASE%"=="" (
    echo DEBUG_RELEASE not set
    exit /b 1
)
if "%ADDRESS_MODEL%"=="" (
    echo ADDRESS_MODEL not set
    exit /b 1
)
if "%BOOST_SOURCE_FOLDER%"=="" (
    echo BOOST_SOURCE_FOLDER not set
    exit /b 1
)
if "%BZIP2_SOURCE_FOLDER%"=="" (
    echo BZIP2_SOURCE_FOLDER not set
    exit /b 1
)
if "%ZLIB_SOURCE_FOLDER%"=="" (
    echo ZLIB_SOURCE_FOLDER not set
    exit /b 1
)
if "%BOOST_INCLUDE_FOLDER%"=="" (
    echo BOOST_INCLUDE_FOLDER not set
    exit /b 1
)
if "%BOOST_LIB_FOLDER%"=="" (
    echo BOOST_LIB_FOLDER not set
    exit /b 1
)
if "%BOOST_TMP_FOLDER%"=="" (
    echo BOOST_TMP_FOLDER not set
    exit /b 1
)
if "%BOOST_EXEC_FOLDER%"=="" (
    echo BOOST_EXEC_FOLDER not set
    exit /b 1
)

set current_folder=%CD%

set layout=system
set with_libraries=^
 --with-atomic^
 --with-chrono^
 --with-container^
 --with-context^
 --with-coroutine^
  --with-fiber^
 --with-iostreams^
 --with-program_options^
 --with-test^
 --with-thread


set additional_flags=^
 -sBZIP2_SOURCE="%BZIP2_SOURCE_FOLDER%"^
 -sZLIB_SOURCE="%ZLIB_SOURCE_FOLDER%"

set b2_command=b2^
 --build-dir="%BOOST_TMP_FOLDER%"^
 --includedir="%BOOST_INCLUDE_FOLDER%"^
 --libdir="%BOOST_LIB_FOLDER%"^
 --exec-prefix="%BOOST_EXEC_FOLDER%"^
 --layout=%layout%^
 %with_libraries%^
 toolset=%BOOST_TOOLSET%^
 variant=%DEBUG_RELEASE%^
 address-model=%ADDRESS_MODEL%^
 link=static^
 runtime-link=shared^
 %additional_flags%^
 install

echo Building libraries: %with_libraries%
echo %b2_command%

mkdir "%BOOST_INCLUDE_FOLDER%"
cd %BOOST_SOURCE_FOLDER%
%b2_command%
cd %current_folder%

