FROM golang:1.11-alpine3.8 as builder

LABEL maintainer="Oleg Ozimok ozimokoleg@gmail.com"

ARG KANIKO_VERSION="master"

RUN apk add --update make

WORKDIR /go/src/github.com/GoogleContainerTools/kaniko

RUN wget -q -O- https://github.com/GoogleContainerTools/kaniko/archive/${KANIKO_VERSION}.tar.gz | tar --strip-components=1 -zx -C /go/src/github.com/GoogleContainerTools/kaniko

RUN make

FROM alpine:3.8

RUN apk add --update --no-cache ca-certificates

COPY --from=builder /go/src/github.com/GoogleContainerTools/kaniko/out/executor /usr/local/bin/kaniko-executor
COPY config.json /root/.docker/

ENV DOCKER_CONFIG /root/.docker/

WORKDIR /workspace

ENTRYPOINT ["/usr/local/bin/kaniko-executor"]