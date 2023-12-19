#!/bin/sh

if [[ "${AUTH_ENABLED}" = "true" ]]; then
    echo "Authentication is enabled -> check/create password file"
    mv /mosquitto/config/mosquitto_with_auth.conf /mosquitto/config/mosquitto.conf

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
    mv /mosquitto/config/mosquitto_without_auth.conf /mosquitto/config/mosquitto.conf
fi 

echo "Start command"
exec "$@"