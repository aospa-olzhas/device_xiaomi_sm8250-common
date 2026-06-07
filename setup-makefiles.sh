#!/bin/bash
#
# SPDX-FileCopyrightText: 2024 The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

set -e

DEVICE=munch
VENDOR=xiaomi

# Load extract_utils and do some sanity checks
MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}"
    exit 1
fi
source "${HELPER}"

function lib_to_package_fixup_vendor_variants() {
    if [ "$2" != "vendor" ]; then
        return 1
    fi

    case "$1" in
        com.qualcomm.qti.dpm.api@1.0 | \
        libmmosal | \
        vendor.qti.hardware.wifidisplaysession@1.0 | \
        vendor.qti.imsrtpservice@3.0 | \
        vendor.qti.hardware.radio.ims@1.0 | \
        vendor.qti.hardware.radio.ims@1.1 | \
        vendor.qti.hardware.radio.ims@1.2 | \
        vendor.qti.hardware.radio.ims@1.3 | \
        vendor.qti.hardware.radio.ims@1.4 | \
        vendor.qti.hardware.radio.ims@1.5 | \
        vendor.qti.hardware.radio.ims@1.6 | \
        vendor.qti.hardware.radio.ims@1.7 | \
        vendor.qti.ims.callcapability@1.0 | \
        vendor.qti.ims.callinfo@1.0 | \
        vendor.qti.ims.factory@1.0 | \
        vendor.qti.ims.factory@1.1 | \
        vendor.qti.ims.rcsconfig@1.0 | \
        vendor.qti.ims.rcsconfig@1.1 | \
        vendor.qti.ims.rcsconfig@2.0 | \
        vendor.qti.ims.rcsconfig@2.1 | \
        vendor.qti.imsrtpservice@3.0 | \
        com.qualcomm.qti.imscmservice@1.0 | \
        com.qualcomm.qti.imscmservice@2.0 | \
        com.qualcomm.qti.imscmservice@2.1 | \
        com.qualcomm.qti.imscmservice@2.2 | \
        com.qualcomm.qti.uceservice@2.0 | \
        com.qualcomm.qti.uceservice@2.1 | \
        com.qualcomm.qti.uceservice@2.2 | \
        com.qualcomm.qti.uceservice@2.3 | \
        vendor.qti.data.factory@2.0 | \
        vendor.qti.data.factory@2.1 | \
        vendor.qti.data.factory@2.2 | \
        vendor.qti.data.factory@2.3 | \
        vendor.qti.data.mwqem@1.0 | \
        vendor.qti.data.slm@1.0 | \
        vendor.qti.hardware.data.cne.internal.api@1.0 | \
        vendor.qti.hardware.data.cne.internal.constants@1.0 | \
        vendor.qti.hardware.data.cne.internal.server@1.0 | \
        vendor.qti.hardware.data.connection@1.0 | \
        vendor.qti.hardware.data.connection@1.1 | \
        vendor.qti.hardware.data.dynamicdds@1.0 | \
        vendor.qti.hardware.data.iwlan@1.0 | \
        vendor.qti.hardware.data.latency@1.0 | \
        vendor.qti.hardware.data.lce@1.0 | \
        vendor.qti.hardware.data.qmi@1.0 | \
        vendor.qti.hardware.mwqemadapter@1.0 | \
        vendor.qti.hardware.slmadapter@1.0 | \
        vendor.qti.latency@2.0 | \
        vendor.qti.latency@2.1 | \
        vendor.qti.hardware.radio.am@1.0 | \
        vendor.qti.hardware.radio.atcmdfwd@1.0 | \
        vendor.qti.hardware.radio.internal.deviceinfo@1.0 | \
        vendor.qti.hardware.radio.lpa@1.0 | \
        vendor.qti.hardware.radio.lpa@1.1 | \
        vendor.qti.hardware.radio.qcrilhook@1.0 | \
        vendor.qti.hardware.radio.qtiradio@1.0 | \
        vendor.qti.hardware.radio.qtiradio@2.0 | \
        vendor.qti.hardware.radio.qtiradio@2.1 | \
        vendor.qti.hardware.radio.qtiradio@2.2 | \
        vendor.qti.hardware.radio.qtiradio@2.3 | \
        vendor.qti.hardware.radio.qtiradio@2.4 | \
        vendor.qti.hardware.radio.uim@1.0 | \
        vendor.qti.hardware.radio.uim@1.1 | \
        vendor.qti.hardware.radio.uim@1.2 | \
        vendor.qti.hardware.radio.uim_remote_client@1.0 | \
        vendor.qti.hardware.radio.uim_remote_client@1.1 | \
        vendor.qti.hardware.radio.uim_remote_client@1.2 | \
        vendor.qti.hardware.radio.uim_remote_server@1.0)
            echo "${1}_vendor"
            ;;
        *)
            return 1
            ;;
    esac
}

function lib_to_package_fixup() {
    lib_to_package_fixup_clang_rt_ubsan_standalone "$1" ||
        lib_to_package_fixup_proto_3_9_1 "$1" ||
        lib_to_package_fixup_vendor_variants "$@"
}

# Initialize the helper
setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}"

# Warning headers and guards
write_headers

write_makefiles "${MY_DIR}/proprietary-files.txt"

# Finish
write_footers
