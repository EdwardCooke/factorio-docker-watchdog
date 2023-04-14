FROM alpine:3.17.0

ENV GIT_ORG=
ENV GIT_REPO=
ENV GIT_BRANCH=
ENV GIT_SSHFILE=
ENV FORCE=

WORKDIR /app

RUN apk add jq git curl bash
COPY *.sh .
ENV GIT_SSH=/app/myssh.sh

ENTRYPOINT ./run.sh