@echo off

if not exist build md build
if not exist build\x86 (
    md build\x86
    cd build\x86
    if "%1" == "" (
        cmake -G "Visual Studio 11 2012" ..\..
    ) else (
        cmake -G "%1" ..\..
    )
    cd ..\..
)

cmake --build build\x86 --config Release
copy build\x86\Release\nfd.dll Assets\nfd\Plugins\x86
