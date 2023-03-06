#!/usr/bin/env bash

cargo bundle-licenses --format yaml --output DENO_DOM_THIRDPARTY_LICENSES.yml
cargo build --release


if [ "$(uname -s)" = "Linux" ]; then
    ext="so"
else
    ext="dylib"
fi

mkdir -p $PREFIX/lib
LIB_OUTPUT=$(find target -name libplugin.$ext | tail -n 1)
cp $LIB_OUTPUT $PREFIX/lib/deno_dom.$ext

activateFile="${PREFIX}/etc/conda/activate.d/deno_dom.sh"
deactivateFile="${PREFIX}/etc/conda/deactivate.d/deno_dom.sh"
mkdir -p $(dirname $activateFile)
mkdir -p $(dirname $deactivateFile)
echo "export DENO_DOM_PLUGIN=$PREFIX/lib/deno_dom.$ext" > "${activateFile}"
echo "export DENO_DOM_VERSION=$PKG_VERSION-alpha" >> "${activateFile}"

echo "unset DENO_DOM_PLUGIN" > "${deactivateFile}"
echo "unset DENO_DOM_VERSION" >> "${deactivateFile}"
