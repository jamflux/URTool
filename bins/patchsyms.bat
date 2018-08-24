setlocal DisableDelayedExpansion
mode con: cols=75 lines=10
 
set BUILDIR=01-Project\1-Sources
set INTEXTFILE=symlinks
 
set OUTTEXTFILE=temp.txt
set SEARCHTEXT=/01-Project/system
set VER=
set OUTPUTLINE=
 
for /f "tokens=1,* delims=¶" %%A in ( '"type %BUILDIR%\%INTEXTFILE%"') do (
    SET string=%%A
    setLocal EnableDelayedExpansion
    SET modified=!string:%SEARCHTEXT%=%VER%!
    echo.!modified! >> %BUILDIR%\%OUTTEXTFILE%
    endlocal
 )
 
del %BUILDIR%\%INTEXTFILE%
rename %BUILDIR%\%OUTTEXTFILE% %INTEXTFILE%
exit