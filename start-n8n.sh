#!/bin/bash

cd /home/filip/Documents/Projekti/n8n || exit 1

# Start both containers
docker compose -f docker-compose.local.yml up -d

# Wait for ngrok to come online
echo "Waiting for ngrok..."
sleep 5

# Try up to 10 times to get the URL
for i in {1..10}; do
    NGROK_URL=$(curl -s localhost:4040/api/tunnels | jq -r '.tunnels[0].public_url' 2>/dev/null)
    if [[ "$NGROK_URL" == https* ]]; then
        echo "Ngrok URL: $NGROK_URL"
        break
    fi
    sleep 2
done

# Fallback if ngrok URL was not retrieved
if [[ -z "$NGROK_URL" || "$NGROK_URL" == "null" ]]; then
    echo "Failed to fetch Ngrok URL"
    exit 1
fi

# Update the WEBHOOK_URL in .env
sed -i "s|^WEBHOOK_URL=.*|WEBHOOK_URL=$NGROK_URL|" .env

# Restart only the n8n container to apply new env
docker compose restart n8n
