FROM alpine:3.24

RUN apk add --no-cache dcron

COPY script.sh /usr/local/bin/script.sh
RUN chmod +x /usr/local/bin/script.sh

ENV CRON_SCHEDULE="0 * * * *"

CMD ["/usr/local/bin/script.sh"]
