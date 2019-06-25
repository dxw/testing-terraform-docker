#!/bin/bash

# exit on failures
set -e
set -o pipefail


TFLINT_CURRENT_VERSION=$(grep "wget.*tflint" Dockerfile | awk '{for(i=1;i<=NF;i++)if($i ~ "https")split($i,a,"/");print a[8]}')
TFLINT_AVAILABLE_VERSION=$(brew info tflint | head -n1 | awk '{for(i=1;i<=NF;i++)if($i=="wata727/tflint/tflint:")print "v"$(i+2)}')
TFLINT_SOURCE="https://github.com/wata727/tflint/releases/download/VERSION/tflint_linux_amd64.zip"

# Check and update tflint
if [ "$TFLINT_AVAILABLE_VERSION" != "$TFLINT_CURRENT_VERSION" ]; then
  echo "Updating tflint from $TFLINT_CURRENT_VERSION to $TFLINT_AVAILABLE_VERSION..."
  NEW_TFLINT_SOURCE=${TFLINT_SOURCE/VERSION/$TFLINT_AVAILABLE_VERSION}
  NEW_TFLINT_SOURCE_STATUS=$(curl -s -w "%{http_code}" --head "$NEW_TFLINT_SOURCE" -o /dev/null)
  if [[ "$NEW_TFLINT_SOURCE_STATUS" != 200 && "$NEW_TFLINT_SOURCE_STATUS" != 30* ]]; then
    echo "Error: $NEW_TFLINT_SOURCE returned $NEW_TFLINT_SOURCE_STATUS"
    exit 1
  fi
  sed -i '' "s#wget https[^ ]*tflint[^ ]*#wget ${NEW_TFLINT_SOURCE}#g" Dockerfile
fi
