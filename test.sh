#!/bin/bash
set -euo pipefail

TAG="${1:?Usage: $0 <image-tag>}"
TESTS_DIR="$(cd "$(dirname "$0")" && pwd)/tests"
GOSS_IMAGE="dev-build-tools-goss:${TAG}"
FAILED=0

for test_dir in "$TESTS_DIR"/*/; do
    name="$(basename "$test_dir")"
    image="dev-${name}:${TAG}"

    echo "--- Testing ${image}"
    if docker run --rm \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v "${test_dir}:/tests" \
        -e GOSS_FILES_PATH=/tests \
        -e GOSS_FILES_STRATEGY=cp \
        "${GOSS_IMAGE}" dgoss run "${image}" sleep infinity; then
        echo "--- PASS: ${image}"
    else
        echo "--- FAIL: ${image}"
        FAILED=1
    fi
    echo
done

exit $FAILED
