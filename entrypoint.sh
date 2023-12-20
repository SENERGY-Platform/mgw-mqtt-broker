#!/bin/sh

echo "Setup config file"

if [[ "${AUTH_ENABLED}" = "true" ]]; then
    echo "Create config with authentication"
    CONFIG_PATH=/mosquitto/config/mosquitto_with_auth.conf
    if [ -f $CONFIG_PATH ]; then
        mv /mosquitto/config/mosquitto_with_auth.conf /mosquitto/config/mosquitto.conf
        echo "Config file was set successfully"
    else
        echo "Config file already exists"
    fi
else 
    echo "Create config without authentication"
    CONFIG_PATH=/mosquitto/config/mosquitto_without_auth.conf
    if [ -f $CONFIG_PATH ]; then
        mv /mosquitto/config/mosquitto_without_auth.conf /mosquitto/config/mosquitto.conf
        echo "Config file was set successfully"
    else
        echo "Config file already exists"
    fi
fi 

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

echo "Start command"
exec "$@"