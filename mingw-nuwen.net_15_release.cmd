@echo off
title MinGW nuwen.net 15 release
%comspec% /k ""d:\local\mingw-nuwen.net\MinGW\set_distro_paths.bat" & "%~dp0env_windows.bat" gcc_nuwen_15 gcc release 64"
