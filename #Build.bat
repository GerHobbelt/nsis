:: Install MSVC in VS Installer (I've used 14.2 - VS2019)

pip install scons
scons ZLIB_W32=%CD%\zlib NSIS_MAX_STRLEN=4096 dist