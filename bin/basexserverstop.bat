@echo off
setlocal

REM Path to this script
set PWD=%~dp0

REM Paths to distributed files or source directories
set BASEX=%PWD%/../BaseX.jar

REM Run code
java -cp "%BASEX%" org.basex.BaseXServer %* stop
