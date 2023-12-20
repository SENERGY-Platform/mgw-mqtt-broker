#!/bin/sh

echo "Setup config file"
CONFIG_PATH=/mosquitto/config/mosquitto.conf

if [[ "${AUTH_ENABLED}" = "true" ]]; then
    echo "Use config with authentication"
    cp /mosquitto/config/mosquitto_with_auth.conf ${CONFIG_PATH}
else 
    echo "Use config without authentication"
    cp /mosquitto/config/mosquitto_without_auth.conf ${CONFIG_PATH} 
fi 
echo "Config file was set successfully"


if [[ "${AUTH_ENABLED}" = "true" ]]; then
    echo "Authentication is enabled -> check/create password file"

    PASSWDFILE=/mosquitto/passwd/passwd

    if [ ! -f $PASSWDFILE ]; then
        echo "Password file does not exist -> create with credentials from env"
        if [[ -z "${USERNAME}" ]]; then
            echo "USERNAME env is missing"
            return
        fi 
        if [[ -z "${PASSWORD}" ]]; then
            echo "PASSWORD env is missing"
            return
        fi 
        yes | mosquitto_passwd -c $PASSWDFILE $USERNAME
        mosquitto_passwd -b $PASSWDFILE $USERNAME $PASSWORD
    else
        echo "Password file already exists"
    fi
else 
    echo "Authentication is disabled" 
fi 

echo "Set permissions for mosquitto user"
user="$(id -u)"
if [ "$user" = '0' ]; then
	[ -d "/mosquitto" ] && chown -R mosquitto:mosquitto /mosquitto || true
fi
echo "Start command"
exec "$@"