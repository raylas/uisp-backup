FROM alpine:3.14.0
LABEL org.opencontainers.image.authors="r@rymnd.org"

COPY uisp_backup.sh /uisp_backup.sh
COPY cronjobs /etc/crontabs/root

RUN apk --no-cache add bash curl jq

CMD ["crond", "-f", "-d", "8"]
