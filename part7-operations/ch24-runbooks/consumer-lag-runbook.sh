#!/usr/bin/env bash
set -euo pipefail

NS="quote"
GROUP="quote-consumer"

echo "STEP 1: confirm the symptom. Is the consumer group lagging?"
lag=$(kubectl -n "$NS" exec deploy/lag-tool -- consumer-lag "$GROUP" --total)
echo "  current total lag: $lag messages"

echo "STEP 2: confirm the consumers are ALIVE (the alive-but-stuck case)."
kubectl -n "$NS" get pods -l app=quote-consumer \
  -o jsonpath='{range .items[*]}{.metadata.name}{" restarts="}{.status.containerStatuses[0].restartCount}{"\n"}{end}'

echo "STEP 3: the fix for alive-but-stuck is a rolling restart of the group."
read -r -p "  Proceed with rolling restart? [y/N] " ok
if [[ "$ok" == "y" ]]; then
  kubectl -n "$NS" rollout restart deploy/quote-consumer
  kubectl -n "$NS" rollout status deploy/quote-consumer --timeout=120s
  echo "STEP 4: confirm recovery. Lag should now be falling."
  kubectl -n "$NS" exec deploy/lag-tool -- consumer-lag "$GROUP" --total
else
  echo "  Not restarting. Escalate per the on-call policy (Chapter 23)."
fi
