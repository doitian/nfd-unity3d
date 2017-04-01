@echo off

if not exist build md build
if not exist build\x86_64 (
    md build\x86_64
    cd build\x86_64
    if "%1" == "" (
        cmake -G "Visual Studio 11 2012" ..\..
    ) else (
        cmake -G "%1" ..\..
    )
    cd ..\..
)

cmake --build build\x86_64 --config Release
copy build\x86_64\Release\nfd.dll Assets\nfd\Plugins\x86_64
