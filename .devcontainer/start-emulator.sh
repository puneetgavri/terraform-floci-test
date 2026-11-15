#!/usr/bin/env bash
set -euo pipefail

# Wait for the Docker daemon (docker-in-docker can take a moment to start)
for i in $(seq 1 30); do
  docker info >/dev/null 2>&1 && break
  echo "Waiting for Docker daemon... ($i)"
  sleep 2
done

if [ "$(docker ps -q -f name=^floci$)" ]; then
  echo "Floci is already running."
else
  # Remove a stopped container with the same name, if any
  docker rm -f floci >/dev/null 2>&1 || true
  echo "Starting Floci AWS emulator..."
  docker run -d --name floci -p 4566:4566 hectorvent/floci:latest
  sleep 5
fi

echo "Floci is ready at http://localhost:4566"
