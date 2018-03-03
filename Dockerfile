# Build Struena in a stock Go builder container
FROM golang:1.9-alpine as builder

RUN apk add --no-cache make gcc musl-dev linux-headers

ADD . /go-struena
RUN cd /go-struena && make struena

# Pull Struena into a second stage deploy alpine container
FROM alpine:latest

RUN apk add --no-cache ca-certificates
COPY --from=builder /go-struena/build/bin/struena /usr/local/bin/

EXPOSE 7680 7681 30303 30303/udp 30304/udp
ENTRYPOINT ["struena"]
