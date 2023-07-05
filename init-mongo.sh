#!/bin/bash
set -Eeuo pipefail

_js_escape() {
  printf '%s\n' "$1" | sed -e 's/[]\/$*.^[]/\\&/g'
}

if [ ! -z ${MONGO_CRON_TELEBOT_PASSWORD_FILE+x} ]; then
  MONGO_CRON_TELEBOT_PASSWORD=$(cat ${MONGO_CRON_TELEBOT_PASSWORD_FILE})
fi


if [ ! -z ${MONGO_INITDB_ROOT_PASSWORD_FILE+x} ]; then
  MONGO_INITDB_ROOT_PASSWORD=$(cat ${MONGO_INITDB_ROOT_PASSWORD_FILE})
fi


if [ "$MONGO_CRON_TELEBOT_USERNAME" ] && [ "$MONGO_CRON_TELEBOT_PASSWORD" ]; then
  mongosh mongodb://0.0.0.0:27017/admin -u "$MONGO_INITDB_ROOT_USERNAME" -p "$MONGO_INITDB_ROOT_PASSWORD" <<-EOJS
    use $MONGO_INITDB_DATABASE;
    db.createUser({ 
      user: "$MONGO_CRON_TELEBOT_USERNAME", pwd: "$MONGO_CRON_TELEBOT_PASSWORD", roles: [{ role: "readWrite", db: "$MONGO_INITDB_DATABASE"}]
    });
EOJS
fi

