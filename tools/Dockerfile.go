FROM library/golang:latest AS golang
RUN \
    go install github.com/a-h/templ/cmd/templ@latest && \
    go install github.com/air-verse/air@latest && \
    go install github.com/go-task/task/v3/cmd/task@latest && \
    go install google.golang.org/protobuf/cmd/protoc-gen-go@latest && \
    go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest