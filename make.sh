#!/bin/sh

cd "$(dirname "${0}")"

kernel_config="${1}"

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

make O=../build ${@} || die "Invocation failed"

popd > /dev/null

if ! diff -q ".config" "../${kernel_config}"; then
    echo "Updating configuration ${kernel_config}"
    cp ".config" "../${kernel_config}"
    exit 1;
fi

exit 0;
