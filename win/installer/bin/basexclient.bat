@setlocal
@echo off

REM Path to this script
set PWD=%~dp0

REM Paths to distributed files or source directories
set BASEX=%PWD%/../BaseX.jar

REM Run BaseX client
java -cp "%BASEX%" org.basex.BaseXClient %*

@endlocal
