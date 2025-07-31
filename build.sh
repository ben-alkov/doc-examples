#!/usr/bin/env bash

PROJECT_NAME=mcp-pandoc

HERMETO_CMD="podman run --rm -ti -v "$PWD:$PWD:z" -w $PWD quay.io/konflux-ci/hermeto:latest"

# pip-compile --output-file=requirements.txt requirements.in

$HERMETO_CMD fetch-deps --source . '{
  "type": "pip",
  "requirements_files": ["requirements.txt"],
  "requirements_build_files": ["requirements-build.txt"]
}'

$HERMETO_CMD generate-env ./hermeto-output -o ./hermeto.env --for-output-dir /tmp/hermeto-output

$HERMETO_CMD inject-files ./hermeto-output --for-output-dir /tmp/hermeto-output

podman build -f Dockerfile.hermeto . \
  --volume "$(realpath ./hermeto-output)":/tmp/hermeto-output:Z \
  --volume "$(realpath ./hermeto.env)":/tmp/hermeto.env:Z \
  --network none \
  --tag $PROJECT_NAME

podman run --rm localhost/$PROJECT_NAME:latest
