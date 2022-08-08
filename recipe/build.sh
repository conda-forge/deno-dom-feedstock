#!/usr/bin/env sh

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

mkdir -p "${PREFIX}/etc/conda/activate.d"
echo "export DENO_DOM_PLUGIN=$PREFIX/lib/deno_dom.$ext" > "${PREFIX}/etc/conda/activate.d/deno_dom.sh"
echo "export DENO_DOM_VERSION=$PKG_VERSION-alpha" >> "${PREFIX}/etc/conda/activate.d/deno_dom.sh"

mkdir -p "${PREFIX}/etc/conda/deactivate.d"
echo "unset DENO_DOM_PLUGIN" > "${PREFIX}/etc/conda/deactivate.d/deno_dom.sh"
echo "unset DENO_DOM_VERSION" >> "${PREFIX}/etc/conda/deactivate.d/deno_dom.sh"
