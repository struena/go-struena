FROM ubuntu:xenial

ENV PATH=/usr/lib/go-1.9/bin:$PATH

RUN \
  apt-get update && apt-get upgrade -q -y && \
  apt-get install -y --no-install-recommends golang-1.9 git make gcc libc-dev ca-certificates && \
  git clone --depth 1 https://github.com/struena/go-struena && \
  (cd go-struena && make struena) && \
  cp go-struena/build/bin/struena /struena && \
  apt-get remove -y golang-1.9 git make gcc libc-dev && apt autoremove -y && apt-get clean && \
  rm -rf /go-struena

EXPOSE 7680
EXPOSE 30303

ENTRYPOINT ["/struena"]
