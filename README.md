# Scripts to set up a C++ with Boost environment

The environment for a flavor of platform/compiler version is set up for both building and using the
supported libraries.

To use the scripts:
- update the environment definition script (`env_linux.sh` / `env_windows.bat`) with the base folder
    where libraries will be installed; Boost related versions and folders and so on
- verify and update if necessary to reflect your environment one of the existing platform setting scripts
    - for Windows with Visual Studio 2017 see: `msvc_14.1_<debug/release>_<32/64>.cmd`
    - for Windows with Mingw (from https://nuwen.net/) see: `mingw-nuwen.net_15_<debug/release>.cmd`
    - for Linux with GCC 6 or 7 see: `gcc_<6/7>_<debug/release>.sh`
    - for Linux with Clang 3.8 see: `clang_3.8_release.sh`
- run the script in a Windows CMD prompt / Linux shell console:
    e.g.
    
        Windows:   ...\env> msvc_14.1_debug_64.cmd
        Linux:      .../env> sh gcc_7_debug.sh
    On Linux, the script will update the command prompt; use 'exit' to exist the environment
- build the Boost collection of libraries (see build_boost.bat/.sh for customizing it)
    e.g.
    
        Windows:   ...\env> build_boost.bat
        Linux:      [gcc_7-debug].../env>sh build_boost.sh
- check that the Boost libraries have been compiled and installed properly:
    e.g.
    
        Windows:   env>dir %BOOST_LIB_FOLDER%
            Directory of d:\local\lib\boost_1_64_0_msvc_14.1_debug_64

            08/19/2017  08:07 AM    <DIR>          .
            08/19/2017  08:07 AM    <DIR>          ..
            08/19/2017  08:05 AM            69,748 libboost_atomic.lib
            08/19/2017  07:46 AM           474,770 libboost_bzip2.lib
            08/19/2017  07:46 AM         2,157,300 libboost_chrono.lib
            ...

        Linux:      [gcc_7-debug].../env>ls -l $BOOST_LIB_FOLDER
            -rw-r--r-- 1 sorin users    17954 Aug 19 08:11 libboost_atomic.a
            -rw-r--r-- 1 sorin users   198722 Aug 12 13:44 libboost_bzip2.a
            -rw-r--r-- 1 sorin users   779158 Aug 12 13:44 libboost_chrono.a
            ...
- compile and run a test program

