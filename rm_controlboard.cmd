@echo off
:: ensure that environment variables will be deleted after programm termination
setlocal
:: You might want to customize these
set APPNAME=Controlboard
set ENVIRONMENT_FILE_PATH=.\datalab-stacks\environment.env
set COMPOSE_FILE=controlboard.yml

:: Switch the windows codepage to utf-8 to let us read files correctly
:: Do this temporarily to not mess with other programs - safe the current value
FOR /F "tokens=2 delims=:" %%i IN ('chcp') DO SET "CHCP_CURRENT=%%i"
:: Get rid of the period. at the end
SET CHCP_CURRENT=%CHCP_CURRENT:~0,-1%
:: Change codepage to utf-8
CHCP 65001 >nul

if not exist %ENVIRONMENT_FILE_PATH% (
    echo ERROR: Environment file %ENVIRONMENT_FILE_PATH% not found!
    echo Please edit %ENVIRONMENT_FILE_PATH%.EXAMPLE and save it as %ENVIRONMENT_FILE_PATH%
    echo.
    goto end_of_file
)


:: Need to set the Windows environment variables from a dedicated environment
:: file. The environmnent variables will be used/referenced within the
:: docker-compose.yml
:: Set environment variables from file. Skip lines starting with #
FOR /F "tokens=*" %%i in ('findstr /v /c:"#" %ENVIRONMENT_FILE_PATH%') do SET %%i
:: set Docker's environemtn variable COMPOSE_FILE - this way we can deal with
:: SEVERAL docker-composes in ONE environment.env


docker-compose down

echo.
echo %APPNAME% container has been shut down and removed completely
echo The container will be recreated from scratch next time
echo.
echo You might want to shut down other running containers:
echo     list running containers: docker ps
echo     stop container:          docker stop CONTAINER_ID
echo     remove container:        docker remove CONTAINER_ID
echo.

:end_of_file
:: Switch codepage back
chcp %CHCP_CURRENT% >nul
