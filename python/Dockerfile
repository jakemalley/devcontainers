FROM builder_tools_image AS tools
FROM builder_base_image AS base

COPY --chown=root:root --from=tools /tools/include /usr/local/include/
COPY --chown=root:root --from=tools /tools/bin/* /usr/local/bin/
COPY requirements.txt /requirements.txt

RUN \
  export DEBIAN_FRONTEND=noninteractive && \
  curl -LsSf https://astral.sh/uv/install.sh -o /tmp/install.sh && \
  UV_INSTALL_DIR=/usr/local/bin bash /tmp/install.sh

USER code

ARG PYTHON_VERSION=3
RUN \
  uv python install --default ${PYTHON_VERSION} && \
  uv venv --python ${PYTHON_VERSION} /home/code/venv

ENV \
    PATH="${PATH}:/home/code/venv/bin:/home/code/.local/bin"
