FROM eclipse-mosquitto:2.0.18

COPY mosquitto_with_auth.conf /mosquitto/config/
COPY mosquitto_without_auth.conf /mosquitto/config/

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["sh", "/entrypoint.sh"]
CMD [ "/usr/sbin/mosquitto", "-c", "/mosquitto/config/mosquitto.conf" ]