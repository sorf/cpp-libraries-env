@echo off
title MinGW nuwen.net 15 debug
%comspec% /k ""d:\local\mingw-nuwen.net\MinGW\set_distro_paths.bat" & "%~dp0env_windows.bat" gcc_nuwen_15 gcc debug 64"
