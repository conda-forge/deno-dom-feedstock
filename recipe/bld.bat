cargo bundle-licenses --format yaml --output DENO_DOM_THIRDPARTY_LICENSES.yml
IF %errorlevel% NEQ 0 exit 1

cargo build --release
IF %errorlevel% NEQ 0 exit 1

:: conda-forge's rust activation sets CARGO_BUILD_TARGET, so cargo writes to
:: target\<triple>\release. Fall back to target\release when it is unset.
set "CARGO_OUT=target\release"
IF DEFINED CARGO_BUILD_TARGET set "CARGO_OUT=target\%CARGO_BUILD_TARGET%\release"

IF NOT EXIST "%LIBRARY_PREFIX%\lib" MKDIR "%LIBRARY_PREFIX%\lib"
COPY "%CARGO_OUT%\plugin.dll" "%LIBRARY_PREFIX%\lib\deno_dom.dll"
IF %errorlevel% NEQ 0 exit 1

MKDIR "%PREFIX%\etc\conda\activate.d"
MKDIR "%PREFIX%\etc\conda\deactivate.d"
echo set "DENO_DOM_PLUGIN=%LIBRARY_PREFIX:/=\%\lib\deno_dom.dll" > %PREFIX%\etc\conda\activate.d\deno_dom.bat
echo set "DENO_DOM_VERSION=%PKG_VERSION%-alpha" >> %PREFIX%\etc\conda\activate.d\deno_dom.bat
echo set DENO_DOM_PLUGIN= > %PREFIX%\etc\conda\deactivate.d\deno_dom.bat
echo set DENO_DOM_VERSION= >> %PREFIX%\etc\conda\deactivate.d\deno_dom.bat
