#!/bin/bash

set -euxo pipefail

if [ ${EUID} != 0 ]; then
    sudo "$0" "$@"
    exit $?
fi

TERRAFORM_VERSION=0.12.24
TERRAFORM_TEMP_DIR="/tmp/terraform-${TERRAFORM_VERSION}"
TERRAFORM_INSTALL_DIR="/opt/terraform/${TERRAFORM_VERSION}"
TERRAFORM_ARCHIVE_URL="https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
TERRAFORM_ARCHIVE_FILE="terraform_${TERRAFORM_VERSION}_linux_amd64.zip"
TERRAFORM_ARCHIVE_PATH="${TERRAFORM_TEMP_DIR}/${TERRAFORM_ARCHIVE_FILE}"

mkdir -p "${TERRAFORM_TEMP_DIR}" "${TERRAFORM_INSTALL_DIR}"
curl -L -o "${TERRAFORM_ARCHIVE_PATH}" "${TERRAFORM_ARCHIVE_URL}"
unzip -o -d "${TERRAFORM_TEMP_DIR}" "${TERRAFORM_ARCHIVE_PATH}"
mv "${TERRAFORM_TEMP_DIR}/terraform" "${TERRAFORM_INSTALL_DIR}/terraform"
rm -rf "${TERRAFORM_TEMP_DIR}"
update-alternatives --install "/usr/bin/terraform" "terraform" "${TERRAFORM_INSTALL_DIR}/terraform" 1
update-alternatives --set terraform "${TERRAFORM_INSTALL_DIR}/terraform"
