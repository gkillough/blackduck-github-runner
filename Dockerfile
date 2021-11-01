FROM alpine:3.13

RUN apk update && apk add bash && apk add curl
RUN apk --no-cache add openjdk11-jre

ENV BDS_JAVA_HOME=/usr/lib/jvm/java-11-openjdk

ARG DETECT_SOURCE=https://sig-repo.synopsys.com/bds-integrations-release/com/synopsys/integration/synopsys-detect/7.7.0/synopsys-detect-7.7.0.jar

COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]