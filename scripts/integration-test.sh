#!/bin/bash
set -e

TIMEOUT=120
ELAPSED=0

echo "Waiting for frontend to be ready..."
until curl -sf http://localhost:3000/health | grep -q "ok"; do
  if [ $ELAPSED -ge $TIMEOUT ]; then
    echo "Timeout waiting for frontend"
    exit 1
  fi
  sleep 2
  ELAPSED=$((ELAPSED + 2))
done
echo "Frontend is ready"

echo "Submitting job..."
RESPONSE=$(curl -sf -X POST http://localhost:3000/submit)
echo "Response: $RESPONSE"
JOB_ID=$(echo "$RESPONSE" | python3 -c "import sys,json; print(json.load(sys.stdin)['job_id'])")
echo "Job ID: $JOB_ID"

echo "Polling for job completion..."
for i in $(seq 1 30); do
  STATUS=$(curl -sf "http://localhost:3000/status/$JOB_ID" | python3 -c "import sys,json; print(json.load(sys.stdin)['status'])")
  echo "Status: $STATUS"
  if [ "$STATUS" = "completed" ]; then
    echo "Job completed successfully"
    exit 0
  fi
  sleep 2
done

echo "Job did not complete in time"
exit 1