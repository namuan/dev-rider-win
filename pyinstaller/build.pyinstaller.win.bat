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

