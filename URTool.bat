::DISCLAIMER: this tool can be used for free, the credits to JamFlux and other authors must be visible where the ROM has been published
@shift /0
@echo OFF
SETLOCAL ENABLEDELAYEDEXPANSION
SET APP_NAME=UR-Tool Prime v1.8 semi-stable
SET AUTHORS=[by JamFlux]
SET APP_DESCRIPTION=Extract and Repack system formats on android 5-8.1
set CYGWIN=nodosfilewarning
SET Cecho=bins\cecho.exe
SET busybox=bins\busybox.exe
set imgextractor="bins\ImgExtractor.exe"
TITLE %APP_NAME% %AUTHORS%


:start
mode con: cols=75 lines=15
if exist 01-Project rmdir /q /s 01-Project
if exist 1-Finish rmdir /q /s 1-Finish
cls
echo.
echo.
echo 	   ".##..##.#####.........######..####...####..##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   ".##..##.#####..######...##...##..##.##..##.##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   "..####..##..##..........##....####...####..######.";
echo 	   "..................................................";
echo.
%cecho%                                                       {03}by JamFlux{#}
echo.
echo.
echo.
%cecho%           {4f}%APP_DESCRIPTION%{#}
TIMEOUT /T 3 /nobreak > NUL & cls


::Find .zip files into executable directory
mode con: cols=75 lines=28
:ZIP_FILES
cls
echo.
echo.
echo 	   ".##..##.#####.........######..####...####..##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   ".##..##.#####..######...##...##..##.##..##.##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   "..####..##..##..........##....####...####..######.";
echo 	   "..................................................";
echo.
%cecho%                                                       {03}by JamFlux{#}
echo.
echo.
echo.
echo            *****************************************************
%cecho%            {0b}Please, select a zip to work with:{#}
echo.
echo            *****************************************************
echo.
echo.
SET /A i=1
FOR %%k IN (*.zip) DO (
	SET ZIP!i!=%%k
	echo *          !i! - %%k
	SET /A i+=1
)
echo.
echo.
SET /P NUMBER=*          Choose the number: 
IF NOT DEFINED NUMBER GOTO :ZIP_FILES
IF /I %NUMBER% GEQ %i% GOTO :ZIP_FILES
IF /I %NUMBER% LSS 1 GOTO :ZIP_FILES
SET FILE=!ZIP%NUMBER%!

IF NOT EXIST "%FILE%" GOTO :ZIP_FILES

::The main menu
:work_place
cls
echo.
echo.
echo 	   ".##..##.#####.........######..####...####..##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   ".##..##.#####..######...##...##..##.##..##.##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   "..####..##..##..........##....####...####..######.";
echo 	   "..................................................";
echo.
%cecho%                                                       {03}by JamFlux{#}
echo.
echo.
echo            *****************************************************
echo *          Working with:
%cecho% *          {0b}!file!{#}
echo.
echo            *****************************************************
echo.
%cecho% *                                                 {0a}Avalaible Menu{#}
echo.
echo.
echo *          1- Extract android image (BIN,IMG,DAT-BR are supported)
echo *          2- Repack android folder to its original format
echo *          3- Exit
echo.
echo.
SET /P NUMBER=*          Select an option: 
IF "%NUMBER%"=="1" GOTO Just_Unpack
IF "%NUMBER%"=="2" GOTO Just_Repack
IF "%NUMBER%"=="3" GOTO Exit
::IF "%NUMBER%"=="4" GOTO Make_zip

::Determining ROM format
:Just_Unpack
cls
echo.
echo.
echo 	   ".##..##.#####.........######..####...####..##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   ".##..##.#####..######...##...##..##.##..##.##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   "..####..##..##..........##....####...####..######.";
echo 	   "..................................................";
echo.
%cecho%                                                       {03}by JamFlux{#}
echo.
echo.
echo            *****************************************************
echo *          Working with:
%cecho% *          {0b}!file!{#}
echo.
echo            *****************************************************
echo.
echo.
echo.
%cecho% *          {0a}Extracting zip files...{#}
echo.
IF NOT EXIST "01-Project" MKDIR "01-Project"
IF NOT EXIST "01-Project\1-Sources" MKDIR "01-Project\1-Sources"
IF NOT EXIST "01-Project\temp" MKDIR "01-Project\temp"
IF NOT EXIST "01-Project\system" MKDIR "01-Project\system"
IF NOT EXIST "01-Project\1-Sources" MKDIR "01-Project\1-Sources"
::Copying extracted files to source folder
bins\7z e "%FILE%" n system.new.dat.br -o01-Project\1-Sources >nul
bins\7z e "%FILE%" n system.new.dat -o01-Project\1-Sources >nul
bins\7z e "%FILE%" n system.img -o01-Project\1-Sources >nul
bins\7z e "%FILE%" n payload.bin -o01-Project\1-Sources >nul
bins\7z e "%FILE%" n vendor.new.dat.br -o01-Project\1-Sources >nul
bins\7z e "%FILE%" n vendor.new.dat -o01-Project\1-Sources >nul
bins\7z e "%FILE%" n vendor.img -o01-Project\1-Sources >nul
bins\7z e "%FILE%" n boot.img -o01-Project\1-Sources >nul
bins\7z e "%FILE%" n system.transfer.list -o01-Project\1-Sources >nul
bins\7z e "%FILE%" n vendor.transfer.list -o01-Project\1-Sources >nul
bins\7z e "%FILE%" n file_contexts -o01-Project\1-Sources >nul
bins\7z e "%FILE%" n file_contexts.bin -o01-Project\1-Sources >nul
if exist 01-Project\1-Sources\vendor.* (goto un_vendor) else goto next
:next
::Looking for system or vendor compression format
if exist 01-Project\1-Sources\system.new.dat.br echo new.dat.br format found >>01-Project\temp\system.new.dat.br.br
if exist 01-Project\1-Sources\system.new.dat echo new.dat format found >>01-Project\temp\system.new.dat.dat
if exist 01-Project\1-Sources\payload.bin echo payload.bin format found >>01-Project\temp\payload.bin.bin
if exist 01-Project\1-Sources\system.img echo system.img format found >>01-Project\temp\system.img.img
FOR /R 01-Project\temp %%A IN (*) DO SET format=%%~nA
cls
echo.
echo.
echo 	   ".##..##.#####.........######..####...####..##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   ".##..##.#####..######...##...##..##.##..##.##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   "..####..##..##..........##....####...####..######.";
echo 	   "..................................................";
echo.
%cecho%                                                       {03}by JamFlux{#}
echo.
echo.
echo            *****************************************************
echo *          Working with:
%cecho% *          {0b}!file!{#}
echo.
echo            *****************************************************
echo.
echo.
echo.
%cecho% *           Current format is: {0a}!format!{#}
echo.
TIMEOUT /T 3 /nobreak > NUL

:check_format
cls
if "!format!"=="payload.bin" (goto un_payload) else goto next_1
:next_1
cls
if "!format!"=="system.new.dat.br" (goto un_brotli) else goto next_2
:next_2
cls
if "!format!"=="system.new.dat" (goto un_pack_dat) else goto next_3
:next_3
cls
if "!format!"=="system.img" (goto Extract_SYS) else goto not_supported
goto:eof


:un_vendor
::Unpacking vendor image
cls
echo.
echo.
echo 	   ".##..##.#####.........######..####...####..##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   ".##..##.#####..######...##...##..##.##..##.##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   "..####..##..##..........##....####...####..######.";
echo 	   "..................................................";
echo.
%cecho%                                                       {03}by JamFlux{#}
echo.
echo.
echo            *****************************************************
echo *          Working with:
%cecho% *          {0b}!file!{#}
echo.
echo            *****************************************************
echo.
echo.
echo.
%cecho% *           {0a}Vendor image found:{#} extracting...
echo.
if exist 01-Project\1-Sources\vendor.new.dat.br bins\brotli -d 01-Project\1-Sources\vendor.new.dat.br >nul
if exist 01-Project\1-Sources\vendor.new.dat bins\sdat2img 01-Project\1-Sources\vendor.transfer.list 01-Project\1-Sources\vendor.new.dat 01-Project\1-Sources\vendor.img >nul
if exist 01-Project\1-Sources\vendor.img bins\ImgExtractor 01-Project\1-Sources\vendor.img 01-Project\vendor >nul
call :Detect_vendor_size
call :write_vendor_symlinks
if exist 01-Project\1-Sources\vendor.new.dat.br !busybox! rm -rf 01-Project\1-Sources\vendor.new.dat.br >nul
if exist 01-Project\1-Sources\vendor.new.dat !busybox! rm -rf 01-Project\1-Sources\vendor.new.dat >nul
goto next


:not_supported
::Not supported android image
cls
echo.
echo.
echo 	   ".##..##.#####.........######..####...####..##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   ".##..##.#####..######...##...##..##.##..##.##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   "..####..##..##..........##....####...####..######.";
echo 	   "..................................................";
echo.
%CECHO%                                                       {03}by JamFlux{#}
echo.
echo.
echo.
%CECHO% *          {0f}I have found a format type error:{#}
echo.
echo.
echo.
echo            *****************************************************
%CECHO% *          The supplied zip {0c}does not contain a supported format{#}
echo.
echo.
%CECHO% *          Valid formats are: {0a}system.IMG/NEW.DAT/BR/payload.BIN{#}
echo.
echo            *****************************************************
echo.
pause>nul
rmdir /q /s 01-Project
goto ZIP_FILES


:un_payload
::Use only for A/B devices like pixel or mi a1, mi a2
cls
echo.
echo.
echo 	   ".##..##.#####.........######..####...####..##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   ".##..##.#####..######...##...##..##.##..##.##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   "..####..##..##..........##....####...####..######.";
echo 	   "..................................................";
echo.
%cecho%                                                       {03}by JamFlux{#}
echo.
echo.
echo            *****************************************************
%cecho% *          Working with {0b}!format!{#} ROM:
echo.
%cecho% *          {0b}!file!{#}
echo.
echo            *****************************************************
echo.
echo.
echo.
%cecho% *          Unpacking {0a}!format!{#} system images...
echo.
bins\7z x "bins\payload.7z" -o01-Project\1-Sources >nul
move /y 01-Project\1-Sources\payload.bin 01-Project\1-Sources\payload_input >nul 2>nul
cd 01-Project\1-Sources
call payload_dumper.bat
cd ..\..
move /y 01-Project\1-Sources\payload_output\system.img 01-Project\1-Sources>nul 2>nul
move /y 01-Project\1-Sources\payload_output\boot.img 01-Project\1-Sources >nul 2>nul
cls
echo.
echo.
echo 	   ".##..##.#####.........######..####...####..##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   ".##..##.#####..######...##...##..##.##..##.##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   "..####..##..##..........##....####...####..######.";
echo 	   "..................................................";
echo.
%cecho%                                                       {03}by JamFlux{#}
echo.
echo.
echo            *****************************************************
%cecho% *          Working with {0b}!format!{#} ROM:
echo.
%cecho% *          {0b}!file!{#}
echo.
echo            *****************************************************
echo.
echo.
echo.
%cecho% *          {0a}Done{#}
echo.
if exist 01-Project\1-Sources\payload_input rmdir /q /s 01-Project\1-Sources\payload_input >nul 2>nul
if exist 01-Project\1-Sources\payload_output rmdir /q /s 01-Project\1-Sources\payload_output >nul 2>nul
if exist 01-Project\1-Sources\payload_dumper.exe !busybox! rm -rf 01-Project\1-Sources\payload_dumper.exe >nul 2>nul
if exist 01-Project\1-Sources\payload_dumper.bat !busybox! rm -rf 01-Project\1-Sources\payload_dumper.bat >nul 2>nul
TIMEOUT /T 2 /nobreak > NUL
goto Extract_SYS


:un_brotli
::Unpack brotli compressed image, ROMs above android 8.1
cls
echo.
echo.
echo 	   ".##..##.#####.........######..####...####..##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   ".##..##.#####..######...##...##..##.##..##.##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   "..####..##..##..........##....####...####..######.";
echo 	   "..................................................";
echo.
%cecho%                                                       {03}by JamFlux{#}
echo.
echo.
echo            *****************************************************
%cecho% *          Working with {0b}!format!{#} ROM:
echo.
%cecho% *          {0b}!file!{#}
echo.
echo            *****************************************************
echo.
echo.
echo.
%cecho% *          Decompressing {0a}!format!{#} format...
echo.
bins\brotli.exe -dj 01-Project/1-Sources/system.new.dat.br >nul
:un_pack_dat
::Unpacking .dat compression
cls
echo.
echo.
echo 	   ".##..##.#####.........######..####...####..##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   ".##..##.#####..######...##...##..##.##..##.##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   "..####..##..##..........##....####...####..######.";
echo 	   "..................................................";
echo.
%cecho%                                                       {03}by JamFlux{#}
echo.
echo.
echo            *****************************************************
%cecho% *          Working with {0b}!format!{#} ROM:
echo.
%cecho% *          {0b}!file!{#}
echo.
echo            *****************************************************
echo.
echo.
echo.
%cecho% *          Unpacking {0a}!format!{#} format...
echo.
bins\sdat2img 01-Project\1-Sources\system.transfer.list 01-Project\1-Sources\system.new.dat 01-Project\1-Sources\system.img >nul
if exist 01-Project\1-Sources\system.new.dat.br !busybox! rm -rf 01-Project\1-Sources\system.new.dat.br >nul 2>nul
if exist 01-Project\1-Sources\system.new.dat !busybox! rm -rf 01-Project\1-Sources\system.new.dat >nul 2>nul
TIMEOUT /T 1 /nobreak > NUL
goto Extract_SYS


:Extract_SYS
::Main function for editing ROM's stuff, extracting system image to simple files folder
call :Detect_system_size
cls
echo.
echo.
echo 	   ".##..##.#####.........######..####...####..##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   ".##..##.#####..######...##...##..##.##..##.##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   "..####..##..##..........##....####...####..######.";
echo 	   "..................................................";
echo.
%cecho%                                                       {03}by JamFlux{#}
echo.
echo.
echo            *****************************************************
%cecho% *          Working with {0b}!format!{#} ROM:
echo.
%cecho% *          {0b}!file!{#}
echo.
echo            *****************************************************
echo.
echo.
echo.
%cecho% *          Extracting {0a}system.img{#}...
echo.
echo.
if not exist 01-Project\system mkdir 01-Project\system
:: ---> This is for extract system.img using 7z,  this puts wrong symlinks format, so better is use into system folder zip ROM
bins\7z x -y "01-Project\1-Sources\system.img" -o"01-Project\system" >nul 2>nul
rmdir /q /s 01-Project\system\[SYS] >nul
:: <---
call :img_extractor
call :Remove_pics_with_spaces
cls
echo.
echo.
echo 	   ".##..##.#####.........######..####...####..##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   ".##..##.#####..######...##...##..##.##..##.##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   "..####..##..##..........##....####...####..######.";
echo 	   "..................................................";
echo.
%cecho%                                                       {03}by JamFlux{#}
echo.
echo.
echo            *****************************************************
%cecho% *          Working with {0b}!format!{#} ROM:
echo.
%cecho% *          {0b}!file!{#}
echo.
echo            *****************************************************
echo.
echo.
echo.
%cecho% *          Grabbing {0a}symlinks{#} and {0a}permissions{#}...
echo.
echo.
::Converts android 7+ file_contexts.bin to plain format. Thanks to wuxianlin at github.
if not exist 01-Project\1-Sources\file_contexts call :File_Context_converter >nul 2>nul
::This part for grabbing symlinks and permissions was adapted from assayyed kitchen batch-script code. Thanks to Assayyed.
call :write_sys_symlinks
call :write_sys_permissions
if exist 01-Project\1-Sources\not_recursive !busybox! rm -rf 01-Project\1-Sources\not_recursive >nul
if exist 01-Project\1-Sources\permissions_sorted !busybox! rm -rf 01-Project\1-Sources\permissions_sorted >nul
if exist 01-Project\1-Sources\recursive !busybox! rm -rf 01-Project\1-Sources\recursive >nul
if exist 01-Project\1-Sources\rom_permissions !busybox! rm -rf 01-Project\1-Sources\rom_permissions >nul
if exist 01-Project\1-Sources\system_contexts !busybox! rm -rf 01-Project\1-Sources\system_contexts >nul
call :Detect_vendor_size
echo %SIZE%>>01-Project\1-Sources\sys_size.txt
echo.
if exist 01-Project\vendor echo %VSIZE%>>01-Project\1-Sources\vend_size.txt
if exist 01-Project\1-Sources\vendor.img !busybox! rm -rf 01-Project\1-Sources\vendor.img >nul
if exist 01-Project\1-Sources\vendor.transfer.list !busybox! rm -rf 01-Project\1-Sources\vendor.transfer.list >nul
echo.
cls
echo.
echo.
echo 	   ".##..##.#####.........######..####...####..##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   ".##..##.#####..######...##...##..##.##..##.##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   "..####..##..##..........##....####...####..######.";
echo 	   "..................................................";
echo.
%cecho%                                                       {03}by JamFlux{#}
echo.
echo.
echo            *****************************************************
%cecho% *          Working with {0b}!format!{#} ROM:
echo.
%cecho% *          {0b}!file!{#}
echo.
echo            *****************************************************
echo.
echo.
echo.
%cecho% *          Done, see {0a}01-Project\system{#} folder.
echo.
echo.
if exist 01-Project\1-Sources\system.img !busybox! rm -rf 01-Project\1-Sources\system.img >nul 2>nul
if exist 01-Project\1-Sources\system.transfer.list !busybox! rm -rf 01-Project\1-Sources\system.transfer.list >nul 2>nul
if not exist 01-Project\1-Sources\file_contexts call :File_Context_converter >nul 2>nul
TIMEOUT /T 3 /nobreak > NUL
cd 01-Project/1-Sources
if exist original_symlinks del /q original_symlinks
cd ..\..
%busybox% sort -u < 01-Project/1-Sources/symlinks >> 01-Project/1-Sources/original_symlinks
if exist 01-Project\1-Sources\vendor_symlinks %busybox% sort -u < 01-Project/1-Sources/vendor_symlinks >> 01-Project/1-Sources/original_vendor_symlinks
if exist 01-Project\1-Sources\original_vendor_symlinks type 01-Project\1-Sources\original_vendor_symlinks >> 01-Project\1-Sources\original_symlinks
cd 01-Project/1-Sources
del /q symlinks
if exist vendor_symlinks del /q vendor_symlinks
if exist original_vendor_symlinks del /q original_vendor_symlinks
cd ..\..
bins\dos2unix -q 01-Project\1-Sources\original_symlinks
bins\dos2unix -q 01-Project\1-Sources\file_contexts
goto work_place

::Magic happen here --->
:File_Context_converter
if not exist 01-Project\1-Sources\file_contexts.bin call :File_Context_finder >nul 2>nul
bins\sefcontext_decompile -o 01-Project\1-Sources\file_contexts 01-Project\1-Sources\file_contexts.bin >nul 2>nul
if exist 01-Project\1-Sources\file_contexts %busybox% sort -u < 01-Project/1-Sources/file_contexts >> 01-Project/1-Sources/file_contexts_sorted
cd 01-Project/1-Sources
move /y file_contexts_sorted file_contexts > nul
cd ..\..
goto:eof
:File_Context_finder
xcopy bins\bootimg.exe 01-Project\1-Sources /y >nul
cd 01-Project\1-Sources
bootimg.exe --unpack-bootimg >nul 2>nul
bootimg.exe --unpack-ramdisk >nul 2>nul
if exist initrd\plat_file_contexts move /y initrd\plat_file_contexts initrd\file_contexts >nul
cd ..\..
move /y 01-Project\1-Sources\initrd\file_contexts 01-Project\1-Sources >nul 2>nul
move /y 01-Project\1-Sources\initrd\file_contexts.bin 01-Project\1-Sources >nul 2>nul
if exist 01-Project\1-Sources\initrd rmdir /q /s 01-Project\1-Sources\initrd >nul 2>nul
if exist 01-Project\1-Sources\bootimg.exe !busybox! rm -rf 01-Project\1-Sources\bootimg.exe >nul 2>nul
if exist 01-Project\1-Sources\bootimg.json !busybox! rm -rf 01-Project\1-Sources\bootimg.json >nul 2>nul
if exist 01-Project\1-Sources\*.gz !busybox! rm -rf 01-Project\1-Sources\*.gz >nul 2>nul
if exist 01-Project\1-Sources\cpiolist.txt !busybox! rm -rf 01-Project\1-Sources\cpiolist.txt >nul 2>nul
if exist 01-Project\1-Sources\kernel.gz.dt !busybox! rm -rf 01-Project\1-Sources\kernel.gz.dt >nul 2>nul
if exist 01-Project\1-Sources\unknown !busybox! rm -rf 01-Project\1-Sources\unknown >nul 2>nul
goto:eof
::Till here<---

:no project
:Sin_proyecto
cls
echo.
echo.
echo 	   ".##..##.#####.........######..####...####..##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   ".##..##.#####..######...##...##..##.##..##.##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   "..####..##..##..........##....####...####..######.";
echo 	   "..................................................";
echo.
%cecho%                                                       {03}by JamFlux{#}
echo.
echo.
echo.
%cecho% *          {0f}I have found a serious error:{#}
echo.
echo.
echo.
echo            *****************************************************
%cecho% *          The supplied zip {0c}doesn't have a build.prop{#}
echo.
echo.
%cecho% *          Please, choose option {0a}1{#} before
echo.
echo *          building a new system project.
echo            *****************************************************
echo.
pause>nul
if exist 01-Project rmdir /q /s 01-Project
goto work_place


::Second part for re-pack!

:Just_Repack
:check_android_version
FOR /R 01-Project\temp %%A IN (*) DO SET format=%%~nA
if "!format!"=="payload.bin" (goto system_AB) else goto system_A
::Normal system android image
:system_A
if not exist 01-Project\system\build.prop goto Sin_proyecto
FOR /F "Tokens=2* Delims==" %%# In (
    'TYPE "01-Project\system\build.prop" ^| FINDSTR "ro.build.version.release="'
) Do (
    SET "release=%%#"
)
call :zipalign
cls
echo.
echo.
echo 	   ".##..##.#####.........######..####...####..##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   ".##..##.#####..######...##...##..##.##..##.##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   "..####..##..##..........##....####...####..######.";
echo 	   "..................................................";
echo.
%cecho%            Android version: {0a}!release!{#}                     {03}by JamFlux{#}
echo.
echo.
echo            *****************************************************
%cecho% *          Working with {0b}!format!{#} ROM:
echo.
%cecho% *          {0b}!file!{#}
echo.
echo            *****************************************************
echo.
echo.
echo.
%cecho% *          Repacking to: {0a}!format!{#} format...
echo.
if not exist 01-Project\2-New_system mkdir 01-Project\2-New_system >nul
if exist 01-Project\vendor bins\make_ext4fs -L vendor -T 2009110000 -S 01-Project\1-Sources\file_contexts -l %VSIZE% -a vendor 01-Project\2-New_system\vendor_ext4.img 01-Project\vendor\ >nul 2>nul
bins\make_ext4fs -L system -T 2009110000 -S 01-Project\1-Sources\file_contexts -C 01-Project\1-Sources\fs_config -l %SIZE% -a system 01-Project\2-New_system\system_ext4.img 01-Project\system\ >nul 2>nul
FOR %%B IN ("01-Project\2-New_system\system_ext4.img") DO SET SIZE2=%%~zB
echo %SIZE2% >> 01-Project\1-Sources\sys_size2.txt
if %SIZE2%==0 (goto no_fs_config) else (goto decide_format)
:decide_format
cls
echo.
echo.
echo 	   ".##..##.#####.........######..####...####..##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   ".##..##.#####..######...##...##..##.##..##.##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   "..####..##..##..........##....####...####..######.";
echo 	   "..................................................";
echo.
%cecho%            Android version: {0a}!release!{#}                     {03}by JamFlux{#}
echo.
echo.
echo            *****************************************************
%cecho% *          Working with {0b}!format!{#} ROM:
echo.
%cecho% *          {0b}!file!{#}
echo.
echo            *****************************************************
echo.
echo.
echo.
%cecho% *          Repacking to: {0a}!format!{#} format...
echo.
if "!format!"=="payload.bin" (goto Repack_IMG) else goto next_1.1
:next_1.1
cls
if "!format!"=="system.new.dat.br" (goto re_brotli) else goto next_2.1
:next_2.1
cls
if "!format!"=="system.new.dat" (goto re_pack_dat) else goto next_3.1
:next_3.1
cls
if "!format!"=="system.img" (goto Repack_IMG) else goto not_supported
goto:eof
if exist 01-Project\1-Sources\system.img !busybox! rm -rf 01-Project\1-Sources\system.img > nul


::Pixel and mi a1 system images, double system slot
:system_AB
if not exist 01-Project\system\system\build.prop goto Sin_proyecto
FOR /F "Tokens=2* Delims==" %%# In (
    'TYPE "01-Project\system\system\build.prop" ^| FINDSTR "ro.build.version.release="'
) Do (
    SET "release=%%#"
)
call :zipalign
cls
echo.
echo.
echo 	   ".##..##.#####.........######..####...####..##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   ".##..##.#####..######...##...##..##.##..##.##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   "..####..##..##..........##....####...####..######.";
echo 	   "..................................................";
echo.
%cecho%            Android version: {0a}!release!{#}                     {03}by JamFlux{#}
echo.
echo.
echo            *****************************************************
%cecho% *          Working with {0b}!format!{#} A/B ROM:
echo.
%cecho% *          {0b}!file!{#}
echo.
echo            *****************************************************
echo.
echo.
echo.
%cecho% *          Repacking to: {0a}system.img{#} format...
echo.
if not exist 01-Project\2-New_system mkdir 01-Project\2-New_system >nul
if exist 01-Project\vendor bins\make_ext4fs -L vendor -T 2009110000 -S 01-Project\1-Sources\file_contexts -l %VSIZE% -a vendor 01-Project\2-New_system\vendor_ext4.img 01-Project\vendor\ >nul 2>nul
bins\make_ext4fs -L system -T 2009110000 -S 01-Project\1-Sources\file_contexts -C 01-Project\1-Sources\fs_config -l %SIZE% -a system 01-Project\2-New_system\system_ext4.img 01-Project\system\ >nul 2>nul
FOR %%B IN ("01-Project\2-New_system\system_ext4.img") DO SET SIZE2=%%~zB
echo %SIZE2% >> 01-Project\1-Sources\sys_size2.txt
if %SIZE2%==0 (goto no_fs_config_AB) else (goto decide_format2)
:decide_format2
cls
echo.
echo.
echo 	   ".##..##.#####.........######..####...####..##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   ".##..##.#####..######...##...##..##.##..##.##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   "..####..##..##..........##....####...####..######.";
echo 	   "..................................................";
echo.
%cecho%            Android version: {0a}!release!{#}                     {03}by JamFlux{#}
echo.
echo.
echo            *****************************************************
%cecho% *          Working with {0b}!format!{#} A/B ROM:
echo.
%cecho% *          {0b}!file!{#}
echo.
echo            *****************************************************
echo.
echo.
echo.
%cecho% *          Done, see: {0a}1-Finish{#} folder
echo.
call :Limpieza
TIMEOUT /T 3 /nobreak > nul & cls
goto work_place


::Compression for brotli ROMs - android 8.1+
:re_brotli
cls
echo.
echo.
echo 	   ".##..##.#####.........######..####...####..##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   ".##..##.#####..######...##...##..##.##..##.##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   "..####..##..##..........##....####...####..######.";
echo 	   "..................................................";
echo.
%cecho%            Android version: {0a}!release!{#}                     {03}by JamFlux{#}
echo.
echo.
echo            *****************************************************
%cecho% *          Working with {0b}!format!{#} ROM:
echo.
%cecho% *          {0b}!file!{#}
echo.
echo            *****************************************************
echo.
echo.
echo.
%cecho% *          Compressing to: {0a}!format!{#} format...
echo.
bins\ext2simg -v 01-Project\2-New_system\system_ext4.img 01-Project\2-New_system\system.img >nul
TIMEOUT /T 3 /nobreak >nul
if exist 01-Project\2-New_system\vendor_ext4.img bins\ext2simg -v 01-Project\2-New_system\vendor_ext4.img 01-Project\2-New_system\vendor.img >nul
TIMEOUT /T 3 /nobreak >nul
bins\simg2sdat 01-Project\2-New_system\system.img 01-Project\2-New_system >nul
TIMEOUT /T 3 /nobreak >nul
if exist 01-Project\2-New_system\vendor.img bins\simg2sdat 01-Project\2-New_system\vendor.img 01-Project\2-New_system >nul
TIMEOUT /T 3 /nobreak >nul
call :Just_Touch
bins\brotli.exe -6 -j -w 24 01-Project\2-New_system\system.new.dat >nul 2>nul
TIMEOUT /T 3 /nobreak >nul
bins\brotli.exe -6 -j -w 24 01-Project\2-New_system\vendor.new.dat >nul 2>nul
TIMEOUT /T 3 /nobreak >nul
if exist 01-Project\2-New_system\system_ext4.img !busybox! rm -rf 01-Project\2-New_system\system_ext4.img
if exist 01-Project\2-New_system\vendor_ext4.img !busybox! rm -rf 01-Project\2-New_system\vendor_ext4.img
cls
echo.
echo.
echo 	   ".##..##.#####.........######..####...####..##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   ".##..##.#####..######...##...##..##.##..##.##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   "..####..##..##..........##....####...####..######.";
echo 	   "..................................................";
echo.
%cecho%            Android version: {0a}!release!{#}                     {03}by JamFlux{#}
echo.
echo.
echo            *****************************************************
%cecho% *          Working with {0b}!format!{#} ROM:
echo.
%cecho% *          {0b}!file!{#}
echo.
echo            *****************************************************
echo.
echo.
echo.
%cecho% *          Done, see: {0a}1-Finish{#} folder
echo.
call :Limpieza
TIMEOUT /T 3 /nobreak > nul & cls
goto work_place


::Simple re-packing function for .dat compression
:re_pack_dat
cls
echo.
echo.
echo 	   ".##..##.#####.........######..####...####..##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   ".##..##.#####..######...##...##..##.##..##.##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   "..####..##..##..........##....####...####..######.";
echo 	   "..................................................";
echo.
%cecho%            Android version: {0a}!release!{#}                     {03}by JamFlux{#}
echo.
echo.
echo            *****************************************************
%cecho% *          Working with {0b}!format!{#} ROM:
echo.
%cecho% *          {0b}!file!{#}
echo.
echo            *****************************************************
echo.
echo.
echo.
%cecho% *          Repacking to: {0a}!format!{#} format...
echo.
bins\ext2simg -v 01-Project\2-New_system\system_ext4.img 01-Project\2-New_system\system.img >nul
TIMEOUT /T 3 /nobreak >nul
if exist 01-Project\2-New_system\vendor_ext4.img bins\ext2simg -v 01-Project\2-New_system\vendor_ext4.img 01-Project\2-New_system\vendor.img >nul
TIMEOUT /T 3 /nobreak >nul
bins\simg2sdat 01-Project\2-New_system\system.img 01-Project\2-New_system >nul
TIMEOUT /T 3 /nobreak >nul
if exist 01-Project\2-New_system\vendor.img bins\simg2sdat 01-Project\2-New_system\vendor.img 01-Project\2-New_system >nul
TIMEOUT /T 3 /nobreak >nul
call :Just_Touch
if exist 01-Project\2-New_system\system_ext4.img !busybox! rm -rf 01-Project\2-New_system\system_ext4.img >nul
cls
echo.
echo.
echo 	   ".##..##.#####.........######..####...####..##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   ".##..##.#####..######...##...##..##.##..##.##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   "..####..##..##..........##....####...####..######.";
echo 	   "..................................................";
echo.
%cecho%            Android version: {0a}!release!{#}                     {03}by JamFlux{#}
echo.
echo.
echo            *****************************************************
%cecho% *          Working with {0b}!format!{#} ROM:
echo.
%cecho% *          {0b}!file!{#}
echo.
echo            *****************************************************
echo.
echo.
echo.
%cecho% *          Done, see: {0a}1-Finish{#} folder
echo.
call :Limpieza
TIMEOUT /T 3 /nobreak > nul & cls
goto work_place


::Repacking into stock ext4 raw image
:Repack_IMG
cls
echo.
echo.
echo 	   ".##..##.#####.........######..####...####..##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   ".##..##.#####..######...##...##..##.##..##.##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   "..####..##..##..........##....####...####..######.";
echo 	   "..................................................";
echo.
%cecho%            Android version: {0a}!release!{#}                     {03}by JamFlux{#}
echo.
echo.
echo            *****************************************************
%cecho% *          Working with {0b}!format!{#} ROM:
echo.
%cecho% *          {0b}!file!{#}
echo.
echo            *****************************************************
echo.
echo.
echo.
%cecho% *          Done, see: {0a}1-Finish{#} folder
echo.
call :Limpieza
TIMEOUT /T 3 /nobreak > nul
goto work_place



::It's needed for some reason...
:Just_Touch
!busybox! touch 01-Project\2-New_system\system.new.dat
TIMEOUT /T 3 /nobreak > nul
if exist 01-Project\2-New_system\vendor.new.dat !busybox! touch 01-Project\2-New_system\vendor.new.dat
TIMEOUT /T 3 /nobreak > nul
goto:eof



::Cleaning directories and non needed files
:Limpieza
if not exist 1-Finish mkdir 1-Finish
move /y 01-Project\2-New_system\system.new.dat.br 1-Finish >nul 2>nul
move /y 01-Project\2-New_system\system.new.dat 1-Finish >nul 2>nul
move /y 01-Project\2-New_system\system_ext4.img 1-Finish\system.img >nul 2>nul
move /y 01-Project\2-New_system\system.transfer.list 1-Finish >nul 2>nul
move /y 01-Project\2-New_system\vendor.new.dat.br 1-Finish >nul 2>nul
move /y 01-Project\2-New_system\vendor.new.dat 1-Finish >nul 2>nul
move /y 01-Project\2-New_system\vendor_ext4.img 1-Finish\vendor.img >nul 2>nul
move /y 01-Project\2-New_system\vendor.transfer.list 1-Finish >nul 2>nul
move /y 01-Project\1-Sources\boot.img 1-Finish >nul 2>nul
move /y 01-Project\1-Sources\file_contexts 1-Finish >nul 2>nul
move /y 01-Project\1-Sources\original_symlinks 1-Finish >nul 2>nul
move /y 01-Project\1-Sources\original_permissions 1-Finish >nul 2>nul
if exist 01-Project rmdir /q /s 01-Project >nul 2>nul
goto:eof


::--->Thanks to assayyed for his knowledge
:write_sys_symlinks
	if not exist "01-Project\1-Sources\symlinks" for /f "delims=" %%a in ('bins\find 01-Project/system -type l ^| !busybox! sed "s/01-Project//"') do (
		for /f "delims=" %%b in ('!busybox! readlink 01-Project%%a') do echo symlink("%%b", "%%a";;;| !busybox! sed "s/;;;/);/">>01-Project\1-Sources\symlinks
	)
	for /f "delims=" %%a in ('echo "%cd%" ^| !busybox! cut -d":" -f1') do set drive_up=%%a
	for /f "delims=" %%a in ('echo "%cd%"^| !busybox! cut -d":" -f2') do set second=%%a
	set drive_low=!drive_up!
	for %%b in (a b c d e f g h i j k l m n o p q r s t u v w x y z) DO SET drive_low=!drive_low:%%b=%%b!
	for /f "delims=" %%a in ('echo \cygdrive\!drive_low!!second!\01-Project\system^| !busybox! tr \\ /') do set rm1=%%a
	for /f "delims=" %%a in ('echo \cygdrive\!drive_up!!second!\01-Project\system^| !busybox! tr \\ /') do set rm2=%%a
	set rm1=!rm1:/=\/!
	set rm2=!rm2:/=\/!
	set rm1=!rm1:"=!
	set rm2=!rm2:"=!
	set symlink_test=0
	for /f "delims=" %%a in ('!busybox! grep -cw "symlink" 01-Project/1-Sources/symlinks') do set symlink_test=%%a
	if exist "01-Project\system\bin\app_process64" (
		!busybox! sed -i '/^symlink("app_process32", "\/system\/bin\/app_process"/d' 01-Project/1-Sources/symlinks
		!busybox! sed -i '/^symlink("dalvikvm32", "\/system\/bin\/dalvikvm"/d' 01-Project/1-Sources/symlinks
	)
:second
start bins\patchsyms.bat >nul
TIMEOUT /T 5 /nobreak > NUL
:third
if exist "01-Project\1-Sources\symlinks" !busybox! sort -u < "01-Project/1-Sources/symlinks" >> "01-Project/1-Sources/original_symlinks"
goto:eof


:write_vendor_symlinks
	if not exist "01-Project\1-Sources\symlinks" for /f "delims=" %%a in ('bins\find 01-Project/vendor -type l ^| !busybox! sed "s/01-Project//"') do (
		for /f "delims=" %%b in ('!busybox! readlink 01-Project%%a') do echo symlink("%%b", "%%a";;;| !busybox! sed "s/;;;/);/">>01-Project\1-Sources\vendor_symlinks
	)
	for /f "delims=" %%a in ('echo "%cd%" ^| !busybox! cut -d":" -f1') do set drive_up=%%a
	for /f "delims=" %%a in ('echo "%cd%"^| !busybox! cut -d":" -f2') do set second=%%a
	set drive_low=!drive_up!
	for %%b in (a b c d e f g h i j k l m n o p q r s t u v w x y z) DO SET drive_low=!drive_low:%%b=%%b!
	for /f "delims=" %%a in ('echo \cygdrive\!drive_low!!second!\01-Project\vendor^| !busybox! tr \\ /') do set rm1=%%a
	for /f "delims=" %%a in ('echo \cygdrive\!drive_up!!second!\01-Project\vendor^| !busybox! tr \\ /') do set rm2=%%a
	set rm1=!rm1:/=\/!
	set rm2=!rm2:/=\/!
	set rm1=!rm1:"=!
	set rm2=!rm2:"=!
	set symlink_test=0
	for /f "delims=" %%a in ('!busybox! grep -cw "symlink" 01-Project/1-Sources/vendor_symlinks') do set symlink_test=%%a
	if exist "01-Project\vendor\bin\app_process64" (
		!busybox! sed -i '/^symlink("app_process32", "\/vendor\/bin\/app_process"/d' 01-Project/1-Sources/vendor_symlinks
		!busybox! sed -i '/^symlink("dalvikvm32", "\/vendor\/bin\/dalvikvm"/d' 01-Project/1-Sources/vendor_symlinks
	)
:second
start bins\v_patchsyms.bat >nul
TIMEOUT /T 5 /nobreak > NUL
:third
if exist "01-Project\1-Sources\vendor_symlinks" !busybox! sort -u < "01-Project/1-Sources/symlinks" >> "01-Project/1-Sources/original_vendor_symlinks"
goto:eof


:write_sys_permissions
	!busybox! sed 's/--//g' 01-Project\1-Sources\file_contexts | !busybox! grep "^/system/" | !busybox! sort > 01-Project\1-Sources\system_contexts
	!busybox! sed 's/\\\././g; s/\\\+/+/g; s/(\/\.\*)?//g; s/\.\*//g; s/(\.\*)//g' 01-Project\1-Sources\system_contexts | bins\gawk "{ print $1, $NF }" | !busybox! sort > 01-Project\1-Sources\system_contexts2
	!busybox! mv 01-Project\1-Sources\system_contexts2 01-Project\1-Sources\system_contexts
	if exist "01-Project/1-Sources/file_contexts" for /f "delims=" %%f in ('!busybox! cat "bins\metadata.txt" ^| !busybox! cut -d"""" -f2') do (
		set replace=no
		for /f "delims=" %%a in ('!busybox! grep -m 1 "%%f " 01-Project\1-Sources\system_contexts ^| bins\gawk "{ print $NF }"') do set replace=%%a
		if "!replace!"=="no" set replace=u:object_r:system_file:s0
		if exist "01-Project%%f" !busybox! grep -w '"%%f"' bins/metadata.txt | !busybox! sed "s/REPLACE_HERE/!replace!/">>01-Project\1-Sources\rom_permissions
	)
	for /f "delims=" %%a in ('type 01-Project\1-Sources\system_contexts') do (
		for /f "delims=" %%b in ('echo %%a ^| bins\gawk "{print $1}"') do set file2=%%b
		for /f "delims=" %%b in ('echo %%a ^| bins\gawk "{print $NF}"') do set contexts=%%b
		for /f "delims=" %%v in ('!busybox! grep -cw '"!file2!"' 01-Project/1-Sources/rom_permissions') do set check=%%v
		for /f "delims=" %%z in ('echo !file2!') do if "!check!"=="0" if not exist "01-Project\system\bins\%%~nz" if exist "01-Project!file2!" echo set_metadata("!file2!", "capabilities", 0x0, "selabel", "!contexts!";;; | !busybox! sed "s/;;;/);/">>01-Project\1-Sources\rom_permissions
		for /f "delims=" %%z in ('echo !file2!') do if exist "01-Project\system\bins\%%~nz" echo set_metadata("!file2!", "uid", 0, "gid", 2000, "mode", 0755, "capabilities", 0x0, "selabel", "!contexts!";;; | !busybox! sed "s/;;;/);/">>01-Project\1-Sources\rom_permissions
	)
	if exist "01-Project/1-Sources/file_contexts" (
		bins\dos2unix -q 01-Project\1-Sources\rom_permissions
		!busybox! sed -i -e "s/); /);/g" 01-Project/1-Sources/rom_permissions
		!busybox! sort -u < 01-Project/1-Sources/rom_permissions >> 01-Project/1-Sources/permissions_sorted
		!busybox! grep "set_metadata_recursive" 01-Project/1-Sources/permissions_sorted >> 01-Project/1-Sources/recursive
		!busybox! grep -v "set_metadata_recursive" 01-Project/1-Sources/permissions_sorted >> 01-Project/1-Sources/not_recursive
		!busybox! cat 01-Project/1-Sources/not_recursive >> 01-Project/1-Sources/recursive
		type 01-Project\1-Sources\recursive >> 01-Project\1-Sources\original_permissions
	)
	goto:eof
::Till here<---
	

:Detect_vendor_size
FOR %%B IN ("01-Project\1-Sources"\vendor.img) DO SET VSIZE=%%~zB
goto:eof

:Detect_system_size
FOR %%A IN ("01-Project\1-Sources"\system.img) DO SET SIZE=%%~zA
::for %%A in (%peso%) do if %%~zA==0 (goto Peso_w10) else (goto:eof)
goto:eof

:img_extractor
IF EXIST 01-Project\1-Sources\system.img (
"%imgextractor%" 01-Project\1-Sources\system.img 01-Project\system > nul
if exist 01-Project\system_statfile.txt move /y 01-Project\system_statfile.txt 01-Project\1-Sources\fs_config >nul 2>nul
)
goto:eof

:Remove_pics_with_spaces
for /R %%j in (*.png*) do (
set filename=%%~nj
set filename=!filename:.=_!
set filename=!filename: =_!
if not "!filename!"=="%%~nj" del "%%j" > nul
)
for /R %%k in (*.jpg*) do (
set filename=%%~nk
set filename=!filename:.=_!
set filename=!filename: =_!
if not "!filename!"=="%%~nk" del "%%k" > nul
)
goto:eof

:no_fs_config
cls
echo.
echo.
echo 	   ".##..##.#####.........######..####...####..##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   ".##..##.#####..######...##...##..##.##..##.##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   "..####..##..##..........##....####...####..######.";
echo 	   "..................................................";
echo.
%cecho%            Android version: {0a}!release!{#}                     {03}by JamFlux{#}
echo.
echo.
echo            *****************************************************
%cecho% *          Working with {0b}!format!{#} ROM:
echo.
%cecho% *          {0b}!file!{#}
echo.
echo            *****************************************************
echo.
echo.
echo.
%cecho% *          Repacking to: {0a}!format!{#} format...
echo.
if exist 01-Project\2-New_system rmdir /q /s 01-Project\2-New_system >nul
if not exist 01-Project\2-New_system mkdir 01-Project\2-New_system >nul
bins\make_ext4fs -L system -T 2009110000 -S 01-Project\1-Sources\file_contexts -l %SIZE% -a system 01-Project\2-New_system\system_ext4.img 01-Project\system\ >nul 2>nul
goto decide_format


:no_fs_config_AB
cls
echo.
echo.
echo 	   ".##..##.#####.........######..####...####..##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   ".##..##.#####..######...##...##..##.##..##.##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   "..####..##..##..........##....####...####..######.";
echo 	   "..................................................";
echo.
%cecho%            Android version: {0a}!release!{#}                     {03}by JamFlux{#}
echo.
echo.
echo            *****************************************************
%cecho% *          Working with {0b}!format!{#} ROM:
echo.
%cecho% *          {0b}!file!{#}
echo.
echo            *****************************************************
echo.
echo.
echo.
%cecho% *          Repacking to: {0a}!format!{#} format...
echo.
if exist 01-Project\2-New_system rmdir /q /s 01-Project\2-New_system >nul
if not exist 01-Project\2-New_system mkdir 01-Project\2-New_system >nul
bins\make_ext4fs -L system -T 2009110000 -S 01-Project\1-Sources\file_contexts -l %SIZE% -a system 01-Project\2-New_system\system_ext4.img 01-Project\system\ >nul 2>nul
goto decide_format2


:zipalign
:: Batch file to recursively zip align *.apk files in a directory
:: and its sub-directories. This is significantly easier and faster
:: than manually zip aligning them.
cls
echo.
echo.
echo 	   ".##..##.#####.........######..####...####..##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   ".##..##.#####..######...##...##..##.##..##.##.....";
echo 	   ".##..##.##..##..........##...##..##.##..##.##.....";
echo 	   "..####..##..##..........##....####...####..######.";
echo 	   "..................................................";
echo.
%cecho%            Android version: {0a}!release!{#}                     {03}by JamFlux{#}
echo.
echo.
echo            *****************************************************
%cecho% *          Working with {0b}!format!{#} ROM:
echo.
%cecho% *          {0b}!file!{#}
echo.
echo            *****************************************************
echo.
echo.
echo.
%cecho% *          {0a}Zipaligning{#} applications...
echo.
for /R %%X in (*.apk) do bins\zipalign -f 4 "%%X" "%%~dpX%%~nX.new"
for /R %%X in (*.new) do move /Y "%%X" "%%~dpX%%~nX.apk" >nul 2>nul
goto:eof



:Exit
exit

