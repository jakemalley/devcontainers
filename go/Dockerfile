ARG GO_VERSION=latest
FROM library/golang:${GO_VERSION} AS golang
FROM builder_tools_image AS tools
FROM builder_tools_go_image AS tools-go
FROM builder_tools_claude_image AS tools-claude
FROM builder_base_image AS base

COPY --chown=root:root --from=golang /usr/local/go /usr/local/go
COPY --chown=root:root --from=tools /tools/include /usr/local/include/
COPY --chown=root:root --from=tools /tools/bin/* /usr/local/bin/
COPY --chown=root:root --from=tools-go /go/bin/* /usr/local/bin/
COPY --chown=root:root --from=tools-claude /usr/local/bin/node /usr/local/bin/
COPY --chown=root:root --from=tools-claude /usr/local/lib/node_modules/@anthropic-ai /usr/local/lib/node_modules/@anthropic-ai
COPY --chown=root:root --from=tools-claude /usr/local/bin/claude /usr/local/bin/

ENV \
    GOPATH=/home/code/go \
    PATH="${PATH}:/usr/local/go/bin:/home/code/go/bin"

USER code

RUN \
    mkdir -p "${GOPATH}" && \
    go install golang.org/x/tools/gopls@latest && \
    go install github.com/cweill/gotests/gotests@latest && \
    go install github.com/fatih/gomodifytags@latest && \
    go install github.com/josharian/impl@latest && \
    go install github.com/haya14busa/goplay/cmd/goplay@latest && \
    go install github.com/go-delve/delve/cmd/dlv@latest && \
    go install honnef.co/go/tools/cmd/staticcheck@latest
