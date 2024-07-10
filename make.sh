#!/bin/sh

cd "$(dirname "${0}")"

kernel_config="${1}"

if ! [ -e "${kernel_config}" ]; then
    echo "Please provide a valid kernel config file"
    exit 2
fi

shift

cd build

ln -sf "../${kernel_config}" .config

cd ../linux

make O=../build ${@}
