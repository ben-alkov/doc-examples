#!/usr/bin/env bash

PROJECT_NAME=simple_color_output

HERMETO_CMD="podman run --rm -ti -v "$PWD:$PWD:z" -w $PWD quay.io/konflux-ci/hermeto:latest"

# Only uncomment if dependencies are broken and need to be resolved again
# pip-compile --output-file=requirements.txt requirements.in

$HERMETO_CMD fetch-deps --source . '{
  "type": "pip",
  "requirements_files": ["requirements.txt"]
}'

$HERMETO_CMD generate-env ./hermeto-output -o ./hermeto.env --for-output-dir /tmp/hermeto-output

podman build . \
  --volume "$(realpath ./hermeto-output)":/tmp/hermeto-output:Z \
  --volume "$(realpath ./hermeto.env)":/tmp/hermeto.env:Z \
  --network none \
  --tag $PROJECT_NAME

podman run --rm localhost/$PROJECT_NAME:latest
