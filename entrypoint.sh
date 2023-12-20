#!/bin/sh

echo "Setup config file"

CONFIG_PATH=/mosquitto/config/mosquitto.conf
if [[ "${AUTH_ENABLED}" = "true" ]]; then
    echo "Create config with authentication"
    if [ ! -f $CONFIG_PATH ]; then
        mv /mosquitto/config/mosquitto_with_auth.conf /mosquitto/config/mosquitto.conf
    else
        echo "Config file already exists"
    fi
else 
    echo "create config without authentication"
 if [ ! -f $CONFIG_PATH ]; then
        mv /mosquitto/config/mosquitto_without_auth.conf /mosquitto/config/mosquitto.conf
    else
        echo "Config file already exists"
    fi
fi 

if [[ "${AUTH_ENABLED}" = "true" ]]; then
    echo "Authentication is enabled -> check/create password file"

    PASSWDFILE=/mosquitto/passwd/passwd

    if [ ! -f $PASSWDFILE ]; then
        echo "password file does not exist -> create with credentials from env"
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

echo "Start command"
exec "$@"