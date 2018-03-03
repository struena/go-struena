FROM alpine:3.7

RUN \
  apk add --update go git make gcc musl-dev linux-headers ca-certificates && \
  git clone --depth 1 https://github.com/struena/go-struena && \
  (cd go-struena && make struena) && \
  cp go-struena/build/bin/struena /struena && \
  apk del go git make gcc musl-dev linux-headers && \
  rm -rf /go-struena && rm -rf /var/cache/apk/*

EXPOSE 7680
EXPOSE 30303

ENTRYPOINT ["/struena"]
