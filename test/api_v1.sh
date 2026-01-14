#!/bin/bash
set -e

# Kill any existing daemon
pkill eternal-daemon || true

# Define fixed token
TOKEN="the-test-token"
CONFIG_FILE="$HOME/.eternal/config.yaml"
mkdir -p "$HOME/.eternal"

# Write config with fixed token
echo "token: \"$TOKEN\"" > "$CONFIG_FILE"
echo "Created config at $CONFIG_FILE with token: $TOKEN"

# Start daemon in background
./eternal-daemon &
DAEMON_PID=$!
echo "Started daemon with PID $DAEMON_PID"

# Wait for startup
sleep 2

# Cleanup previous run artifacts to ensure clean state
# We use curl with token
# Let's try to stop and delete via API first, ignoring errors.
curl -s -X POST -H "access-token: $TOKEN" http://127.0.0.1:9093/v1/processes/test_sleep/stop > /dev/null || true
curl -s -X DELETE -H "access-token: $TOKEN" http://127.0.0.1:9093/v1/processes/test_sleep > /dev/null || true

# Helper function
check() {
    echo "----------------------------------------"
    echo "Running: $1"
    eval "$1"
    echo ""
}

# 1. List services (should be empty or existing)
check "curl -s -H 'access-token: $TOKEN' http://127.0.0.1:9093/v1/processes"

# 2. Create a new service
echo "Creating service 'test_sleep'..."
check "curl -s -X PUT -H 'Content-Type: application/json' -H 'access-token: $TOKEN' -d '{\"exec\": \"sleep 100\", \"dir\": \"/tmp\"}' http://127.0.0.1:9093/v1/processes/test_sleep"

# 3. List again to see if it appears 
check "curl -s -H 'access-token: $TOKEN' http://127.0.0.1:9093/v1/processes"

# 4. Enable it
check "curl -s -X POST -H 'access-token: $TOKEN' http://127.0.0.1:9093/v1/processes/test_sleep/enable"

# 5. Start it
check "curl -s -X POST -H 'access-token: $TOKEN' http://127.0.0.1:9093/v1/processes/test_sleep/start"

# 6. Check status
check "curl -s -H 'access-token: $TOKEN' http://127.0.0.1:9093/v1/processes/test_sleep"

# 7. Stop it
check "curl -s -X POST -H 'access-token: $TOKEN' http://127.0.0.1:9093/v1/processes/test_sleep/stop"

# 8. Delete it
check "curl -s -X DELETE -H 'access-token: $TOKEN' http://127.0.0.1:9093/v1/processes/test_sleep"

# 9. List final
check "curl -s -H 'access-token: $TOKEN' http://127.0.0.1:9093/v1/processes"

# Cleanup
echo "Killing daemon..."
kill $DAEMON_PID
