FROM alpine

LABEL "com.github.actions.name"="Merginator"
LABEL "com.github.actions.description"="Merges a pull request."
LABEL "com.github.actions.icon"="git-merge"
LABEL "com.github.actions.color"="orange"

RUN apk add --no-cache \
        bash \
        git \
        jq && \
        which bash && \
        which git && \
        which jq

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
COPY sample_pull_request_event.json /sample_pull_request_event.json

ENTRYPOINT ["entrypoint.sh"]
