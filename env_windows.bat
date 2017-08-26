@echo off

set CPP_TOOLCHAIN=%1
if "%CPP_TOOLCHAIN%"=="" (
    set CPP_TOOLCHAIN=NA
)

set BOOST_TOOLSET=%2
if "%BOOST_TOOLSET%"=="" (
    set BOOST_TOOLSET=msvc
)

set DEBUG_RELEASE=release
if "%3"=="debug" (
    set DEBUG_RELEASE=debug
)

set ADDRESS_MODEL=64
if "%4"=="32" (
    set ADDRESS_MODEL=32
)

rem Base settings.
rem Note: Spaces in folder names do not currently work with build_boost.sh
set BASE_FOLDER=d:\local
set SOURCE_BASE_FOLDER=%BASE_FOLDER%\src
set TMP_BASE_FOLDER=%BASE_FOLDER%\tmp

rem Boost settings
set BOOST_VERSION=1_65_0
set BZIP2_VERSION=1.0.6
set ZLIB_VERSION=1.2.11

set BOOST_SOURCE_FOLDER=%SOURCE_BASE_FOLDER%\boost_%BOOST_VERSION%
set BZIP2_SOURCE_FOLDER=%SOURCE_BASE_FOLDER%\bzip2-%BZIP2_VERSION%
set ZLIB_SOURCE_FOLDER=%SOURCE_BASE_FOLDER%\zlib-%ZLIB_VERSION%

set BUILD_VARIANT=%CPP_TOOLCHAIN%_%DEBUG_RELEASE%_%ADDRESS_MODEL%

rem Boost paths
set BOOST_INCLUDE_FOLDER=%BASE_FOLDER%\include\boost_%BOOST_VERSION%
set BOOST_LIB_FOLDER=%BASE_FOLDER%\lib\boost_%BOOST_VERSION%_%BUILD_VARIANT%
set BOOST_TMP_FOLDER=%TMP_BASE_FOLDER%\boost_%BOOST_VERSION%_%BUILD_VARIANT%
set BOOST_EXEC_FOLDER=%BASE_FOLDER%\misc\boost_%BOOST_VERSION%_%BUILD_VARIANT%


echo BOOST_VERSION="%BOOST_VERSION%"
echo BOOST_SOURCE_FOLDER="%BOOST_SOURCE_FOLDER%"
echo BOOST_INCLUDE_FOLDER="%BOOST_INCLUDE_FOLDER%"
echo BOOST_LIB_FOLDER="%BOOST_LIB_FOLDER%"
echo BOOST_TOOLSET="%BOOST_TOOLSET%"
echo ADDRESS_MODEL="%ADDRESS_MODEL%"

rem msvc paths
set INCLUDE=%BOOST_INCLUDE_FOLDER%;%INCLUDE%
set LIBPATH=%BOOST_LIB_FOLDER%;%LIBPATH%
set LIB=%BOOST_LIB_FOLDER%;%LIB%

rem gcc-mingw paths (so they come before the system ones)
set GCC_INCLUDE_PATHS=-isystem%BOOST_INCLUDE_FOLDER%
set GCC_LIB_PATHS=-L%BOOST_LIB_FOLDER%



