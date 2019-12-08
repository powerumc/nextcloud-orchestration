#!/usr/bin/env bash

terraform apply
export NEXTCLOUD_PROVIDER="aws"
export NEXTCLOUD_IP=$(terraform output nextcloud_eip)
export NEXTCLOUD_DOMAIN=$(terraform output nextcloud_domain)
export NEXTCLOUD_EMAIL=$(terraform output nextcloud_email)
export NEXTCLOUD_SSH_KEY_FILE_PATH=$(terraform output nextcloud_ssh_key_file_path)