FROM alpine:3 

RUN ["/bin/sh", "-c", "apk add --update --no-cache bash ca-certificates curl git jq openssh openssl"]

COPY ["src", "/src/"]

ENTRYPOINT ["/src/main.sh"]
