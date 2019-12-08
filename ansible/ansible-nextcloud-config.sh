#!/usr/bin/env bash

echo "Environments:"
echo "- NEXTCLOUD_PROVIDER=$NEXTCLOUD_PROVIDER"
echo "- NEXTCLOUD_IP=$NEXTCLOUD_IP"
echo "- NEXTCLOUD_DOMAIN=$NEXTCLOUD_DOMAIN"
echo "- NEXTCLOUD_EMAIL=$NEXTCLOUD_EMAIL"
echo "- NEXTCLOUD_SSH_KEY_FILE_PATH=$NEXTCLOUD_SSH_KEY_FILE_PATH"
echo

function do_aws_provider() {
  if [ -z "$NEXTCLOUD_DOMAIN" ] && [ -z "$NEXTCLOUD_EMAIL" ]; then
    echo "You do not need to apply ssl."
  else
    ansible-playbook playbook-nextcloud-config.yaml -i hosts.ini --key-file $NEXTCLOUD_SSH_KEY_FILE_PATH
  fi
}

case "$NEXTCLOUD_PROVIDER" in
  aws)
    do_aws_provider
    ;;
  azure)
    ;;
  *)
    ;;
esac