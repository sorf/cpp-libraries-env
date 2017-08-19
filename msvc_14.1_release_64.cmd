@echo off
title msvc_14.1 release 64
%comspec% /k ""C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvars64.bat" & "%~dp0env_windows.bat" msvc_14.1 msvc release 64"