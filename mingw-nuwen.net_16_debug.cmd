@echo off
title MinGW nuwen.net 16 debug
%comspec% /k ""C:\MinGW\set_distro_paths.bat" & "%~dp0env_windows.bat" gcc_nuwen_16 gcc debug 64"
