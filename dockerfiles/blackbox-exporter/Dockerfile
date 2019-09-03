FROM alpine AS building

LABEL maintainer="alessander.viana@hotmial.com"
LABEL version="1.0"

ENV exporter_version 0.14.0

RUN apk --no-cache add curl \
    && curl -LO https://github.com/prometheus/blackbox_exporter/releases/download/v${exporter_version}/blackbox_exporter-${exporter_version}.linux-amd64.tar.gz \
    && tar -xvzf blackbox_exporter-${exporter_version}.linux-amd64.tar.gz  \
    && cp blackbox_exporter-${exporter_version}.linux-amd64/blackbox_exporter /tmp/

FROM alpine

COPY --from=building /tmp/blackbox_exporter /usr/local/bin/
COPY blackbox.yml /etc/blackbox_exporter/config.yml

EXPOSE      9115

ENTRYPOINT  [ "/usr/local/bin/blackbox_exporter" ]
CMD         [ "--config.file=/etc/blackbox_exporter/config.yml" ]
