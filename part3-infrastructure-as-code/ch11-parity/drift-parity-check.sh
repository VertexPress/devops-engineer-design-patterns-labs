#!/usr/bin/env bash
set -euo pipefail

code=0
terraform plan -input=false -var-file=environments/production.tfvars -detailed-exitcode || code=$?

if [ "$code" -eq 2 ]; then
  echo "DRIFT: production differs from its declaration. Investigate before promoting."
  exit 1
elif [ "$code" -eq 0 ]; then
  echo "OK: production matches its declaration."
fi
