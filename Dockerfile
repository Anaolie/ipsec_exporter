# Build environment
FROM golang:1.15.6-alpine AS build-env

WORKDIR /go/src/github.com/Anatolie/ipsec_exporter

COPY . .
RUN GOSUMDB=off CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build --buildmode=exe *.go
RUN GOSUMDB=off CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go install

# Final image
FROM alpine:3.10
RUN apk update && apk add ca-certificates && apk add tzdata && rm -rf /var/cache/apk/*

WORKDIR /go/bin
COPY --from=build-env /go/bin/ipsec_exporter /go/bin
