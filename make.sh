#!/bin/bash

cd "$(dirname "${0}")"

kernel_config="${1}"

mkdir -p build "out/${kernel_config}"

die() {
    echo "${1}"
    exit 2
}

if ! [ -e "${kernel_config}" ]; then
    die "Please provide a valid kernel config file"
fi

shift

pushd build > /dev/null

cp "../${kernel_config}" .config

pushd ../linux > /dev/null

export INSTALL_MOD_PATH="../out/${kernel_config}"
export INSTALL_PATH="../out/${kernel_config}/boot"
export INSTALL_HDR_PATH="../out/${kernel_config}"

make -j $(nproc) O=../build INSTALL_MOD_STRIP=1 ${@} || die "Invocation failed"

popd > /dev/null

if ! diff -q ".config" "../${kernel_config}"; then
    echo "Updating configuration ${kernel_config}"
    cp ".config" "../${kernel_config}"
    exit 1;
fi

popd > /dev/null

exit 0;
