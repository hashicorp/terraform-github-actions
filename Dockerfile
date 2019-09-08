FROM golang:1.13-alpine

COPY ["src", "/go/src/"]

RUN ["/bin/sh", "-c", "go build -o /go/bin/tfactions /go/src/*.go"]

ENTRYPOINT ["tfactions"]
