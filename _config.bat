
if not exist "%PF32%" set PF32=%PROGRAMFILES(X86)%
if not exist "%PF32%" set PF32=%PROGRAMFILES%

if not exist "%MINGW64%\bin\gcc.exe" set MINGW64=%MINGW64_INSTDIR%
if not exist "%MINGW64%\bin\gcc.exe" set MINGW64=%SYSTEMDRIVE%\msys2\mingw64

if not exist "%MINGW32%\bin\gcc.exe" set MINGW32=%MINGW32_INSTDIR%
if not exist "%MINGW32%\bin\gcc.exe" set MINGW32=%SYSTEMDRIVE%\msys2\mingw32

REM =================================================

REM :: CONFIG_ARCH=x86|amd64
if not defined CONFIG_ARCH set CONFIG_ARCH=x86

if /i "%CONFIG_ARCH%" equ "x86"   goto :CONFIG_X86
if /i "%CONFIG_ARCH%" equ "amd64" goto :CONFIG_AMD64
echo ERROR: Invalid architecture "%CONFIG_ARCH%" && pause && exit /B 57

REM :: https://gcc.gnu.org/onlinedocs/gcc/Option-Summary.html
REM :: http://linux.die.net/man/1/gcc
REM :: http://linux.die.net/man/1/ld

REM :: Run "gcc -Q --help=target" to see the defaults
REM :: Use -static to remove libgcc*.dll, libstdc++*.dll, libwinpthread*.dll dependencies
:CONFIG_X86
set CONFIG_CFLAGS=-march=pentium2
set CONFIG_LFLAGS=-static -Wl,--gc-sections -Wl,--nxcompat -Wl,--dynamicbase -Wl,--enable-auto-image-base -Wl,--enable-stdcall-fixup
set MINGW=%MINGW32%
goto :CONFIG_END

:CONFIG_AMD64
set CONFIG_CFLAGS=-march=x86-64
set CONFIG_LFLAGS=-static -Wl,--gc-sections -Wl,--nxcompat -Wl,--dynamicbase -Wl,--enable-auto-image-base -Wl,--enable-stdcall-fixup -Wl,--high-entropy-va
set MINGW=%MINGW64%
goto :CONFIG_END

:CONFIG_END

REM =================================================

pushd "%~dp0"
set DEV_PATH=%CD%
popd

for /F "tokens=3" %%f in ('py.exe -0p 2^> nul ^| findstr /C:"-V:3."') do if not defined PYTHON_PATH set PYTHON_PATH=%%~dpf
echo PYTHON_PATH = %PYTHON_PATH%
set ZLIB_PATH=%DEV_PATH%\zlib
set HTMLHELP_PATH=%PF32%\HTML Help Workshop

if not exist "%PYTHON_PATH%"	echo ERROR: Missing Python("%PYTHON_PATH%") && exit /B 2
if not exist "%PYTHON_PATH%\Scripts\scons.*" echo ERROR: Missing Scons("%PYTHON_PATH%\Scripts\scons.*") && exit /B 2
if not exist "%HTMLHELP_PATH%"	echo ERROR: Missing HtmlHelp("%HTMLHELP_PATH%") && exit /B 2
if not exist "%ZLIB_PATH%"		echo ERROR: Missing zlib("%ZLIB_PATH%") && exit /B 2
if not exist "%MINGW%\bin\gcc.exe" echo ERROR: Missing MINGW(%CONFIG_ARCH%) && exit /B 2

exit /B 0