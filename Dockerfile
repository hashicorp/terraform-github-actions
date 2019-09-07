FROM golang:1.13-alpine

RUN ["/bin/sh", "-c", "mkdir -p /root/src"]

COPY ["/src/*", "/root/src/"]

RUN ["/bin/sh", "-c", "go build -o /usr/local/bin/tfactions /root/src/*"]

ENTRYPOINT ["tfactions"]
