@echo off
title msvc_14.1 debug 32
%comspec% /k ""C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\VC\Auxiliary\Build\vcvars32.bat" & "%~dp0env_windows.bat" msvc_14.1 msvc debug 32"