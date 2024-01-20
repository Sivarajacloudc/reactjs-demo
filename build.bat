@echo off

rem Check if both username and password arguments are provided
if "%~1"=="" if "%~2"=="" (
    echo Usage: %0 ^<docker-hub-username^> ^<tag-name^>
    exit /b 1
)

set DOCKER_HUB_USERNAME=%~1
set TAG=%~2

rem Build Docker image
docker build -t %DOCKER_HUB_USERNAME%/reactjs-demo:%TAG% .
