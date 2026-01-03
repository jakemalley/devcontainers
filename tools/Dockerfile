FROM builder_base_image AS base
# Installing unzip so we can download (and unzip!) some of the tools
RUN \
    apt update && apt install -y unzip && \
    apt clean all && rm -rf /var/lib/apt/lists

RUN \
    mkdir -p /tools/bin /tools/include && \
    ln -s /usr/bin/fdfind /tools/bin/fd && \
    curl -fsSL "https://github.com/tailwindlabs/tailwindcss/releases/latest/download/tailwindcss-linux-arm64" \
      -o /tools/bin/tailwindcss && \
    curl -fsSL "https://github.com/junegunn/fzf/releases/download/v0.57.0/fzf-0.57.0-linux_arm64.tar.gz" | tar zxf - -C /tools/bin/ && \
    curl -fsSL "https://github.com/jqlang/jq/releases/latest/download/jq-linux-amd64" \
      -o /tools/bin/jq && \
    curl -fsSL "https://github.com/mikefarah/yq/releases/latest/download/yq_linux_arm64" \
      -o /tools/bin/yq && \
    curl -fsSL "https://github.com/protocolbuffers/protobuf/releases/download/v30.2/protoc-30.2-linux-x86_64.zip" \
       -o /tmp/protoc-30.2-linux-x86_64.zip && unzip /tmp/protoc-30.2-linux-x86_64.zip -d /tools && \
    curl -fsSL "https://github.com/fullstorydev/grpcurl/releases/download/v1.9.3/grpcurl_1.9.3_linux_x86_64.tar.gz" | \
      tar zxf - -C /tools/bin/ grpcurl && \
    chmod +x /tools/bin/*