#!/usr/bin/env bash

echo "Environments:"
echo "- NEXTCLOUD_PROVIDER=$NEXTCLOUD_PROVIDER"
echo "- NEXTCLOUD_IP=$NEXTCLOUD_IP"
echo "- NEXTCLOUD_DOMAIN=$NEXTCLOUD_DOMAIN"
echo "- NEXTCLOUD_EMAIL=$NEXTCLOUD_EMAIL"
echo "- NEXTCLOUD_SSH_KEY_FILE_PATH=$NEXTCLOUD_SSH_KEY_FILE_PATH"
echo

HAS_ERROR=false
if [ -z "$NEXTCLOUD_PROVIDER" ]; then
  echo "ERROR: NEXTCLOUD_PROVIDER value is empty." 1>&2
  HAS_ERROR=true
  return
fi

function validate_password() {
  echo "** Important **"
  echo "Input nextcloud database user 'root' password:"
  read -s NEXTCLOUD_DB_ROOT_PASSWORD
  echo "Input nextcloud database user 'root' confirm password:"
  read -s NEXTCLOUD_DB_ROOT_PASSWORD_CONFIRM
  echo "Input nextcloud database user 'nextcloud' password:"
  read -s NEXTCLOUD_DB_PASSWORD
  echo "Input nextcloud database user 'nextcloud' confirm password:"
  read -s NEXTCLOUD_DB_PASSWORD_CONFIRM
  echo

  if [ "$NEXTCLOUD_DB_ROOT_PASSWORD" != "$NEXTCLOUD_DB_ROOT_PASSWORD_CONFIRM" ]; then
    ECHO "ERROR: Nextcloud database user 'root' password not equals."
    return 1
  fi;
  if [ "$NEXTCLOUD_DB_PASSWORD" != "$NEXTCLOUD_DB_PASSWORD_CONFIRM" ]; then
    ECHO "ERROR: Nextcloud database user 'nextcloud' password not equals."
    return 1
  fi;

  return 0
}

function do_aws_provider() {
  if [ -z "$NEXTCLOUD_IP" ]; then
    echo "ERROR: NEXTCLOUD_IP value is empty." 1>&2
    HAS_ERROR=true
  fi

  if [ -z "$NEXTCLOUD_SSH_KEY_FILE_PATH" ]; then
    echo "ERROR: NEXTCLOUD_SSH_KEY_FILE_PATH value is empty" 1>&2
    HAS_ERROR=true
  fi

  if $HAS_ERROR; then
    return
  fi

  echo "[nextcloud-web]
$NEXTCLOUD_IP ansible_user=ec2-user" > hosts.ini

  echo "MYSQL_ROOT_PASSWORD=$NEXTCLOUD_DB_ROOT_PASSWORD
MYSQL_PASSWORD=$NEXTCLOUD_DB_PASSWORD" > files/db.env

  echo "MYSQL_PASSWORD=$NEXTCLOUD_DB_PASSWORD
NEXTCLOUD_ADMIN_USER=admin
NEXTCLOUD_ADMIN_PASSWORD=admin
NEXTCLOUD_TRUSTED_DOMAINS=$(echo ${NEXTCLOUD_IP} ${NEXTCLOUD_DOMAIN} | xargs)" > files/app.env

  echo "VIRTUAL_HOST=${NEXTCLOUD_DOMAIN:-$NEXTCLOUD_IP}
LETSENCRYPT_HOST=$NEXTCLOUD_DOMAIN
LETSENCRYPT_EMAIL=$NEXTCLOUD_EMAIL" > files/web.env

  #echo "[nextcloud-web]" > hosts.ini
  #echo "$NEXTCLOUD_IP ansible_user=ec2-user" >> hosts.ini

  ansible-playbook playbook.yaml \
                   -i hosts.ini \
                   --key-file $NEXTCLOUD_SSH_KEY_FILE_PATH \
                   -e "NEXTCLOUD_DB_ROOT_PASSWORD=$NEXTCLOUD_DB_ROOT_PASSWORD" \
                   -e "NEXTCLOUD_DB_PASSWORD=$NEXTCLOUD_DB_PASSWORD"
}

validate_password
VALIDATION_RESULT=$?
if [ $VALIDATION_RESULT = 1 ]; then
  return
fi

case "$NEXTCLOUD_PROVIDER" in
  aws)
    do_aws_provider
    ;;
  azure)
    ;;
  *)
    ;;
esac