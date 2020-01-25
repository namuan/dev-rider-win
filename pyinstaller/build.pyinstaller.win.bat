@echo off

setlocal

REM ......................setup variables......................
if [%1]==[] (
    SET ARCH=64
) else (
    SET ARCH=%1
)

