FROM alpine:3.24

RUN apk add --no-cache curl jq

COPY script.sh /usr/local/bin/script.sh
COPY job.sh /usr/local/bin/job.sh
RUN chmod +x /usr/local/bin/script.sh /usr/local/bin/job.sh

ENV CRON_SCHEDULE="0 * * * *"

CMD ["/usr/local/bin/script.sh"]
