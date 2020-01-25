@echo off

setlocal

REM ......................setup variables......................
if [%1]==[] (
    SET ARCH=64
) else (
    SET ARCH=%1
)

if [%2]==[] (
    goto :usage
) else (
    SET PASS=%2
)

if ["%ARCH%"]==["64"] (
    SET BINARCH=x64
    SET PYPATH=C:\Python36-x64
)

